//
//  AppleLoginViewModel.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/17/23.
//

import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseFirestore
import AuthenticationServices
import CryptoKit

enum AuthenticationState {
    case unauthenticated
    case authenticating
    case authenticated
}

enum AuthenticationFlow {
    case login
    case signUp
}

@MainActor
class AppleLoginViewModel: ObservableObject {
    @Published var email = ""
    @Published var password = ""
    @Published var confirmPassword = ""
    
    @Published var flow: AuthenticationFlow = .login
    
    @Published var isValid = false
    @Published var authenticationState: AuthenticationState = .unauthenticated
    @Published var errorMessage = ""
    @Published var user: FirebaseAuth.User?
    @Published var displayName = ""
    
    @Published var nickName: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedImage: UIImage?
    
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    
    let dbRef = Firestore.firestore().collection("Users")
    
    private var currentNonce: String?
    
    init() {
        registerAuthStateHandler()
        verifySignInWithAppleAuthenticationState()
        
        $flow
            .combineLatest($email, $password, $confirmPassword)
            .map { flow, email, password, confirmPassword in
                flow == .login
                ? !(email.isEmpty || password.isEmpty)
                : !(email.isEmpty || password.isEmpty || confirmPassword.isEmpty)
            }
            .assign(to: &$isValid)
        
        Task {
            try await loadUserData()
        }
    }
    @MainActor
    func loadUserData() async throws {
        do {
            // 현재 로그인한 사용자 가져오기
            self.userSession = Auth.auth().currentUser
            
            guard let currentUid = userSession?.uid else { return }
            
            // 토큰의 유저 id로 User찾은 후 currentUser에 저장
            self.currentUser = try await UserStore.fetchUser(userId: currentUid)
            
            print("loadUserData 성공")
            
        } catch {
            print("loadUserData()실패 : 토큰 가져오기 실패!")
        }
        
    }
    
    private var authStateHandler: AuthStateDidChangeListenerHandle?
    
    func registerAuthStateHandler() {
        if authStateHandler == nil {
            authStateHandler = Auth.auth().addStateDidChangeListener { auth, user in
                self.user = user
                self.authenticationState = user == nil ? .unauthenticated : .authenticated
                self.displayName = user?.displayName ?? user?.email ?? ""
            }
        }
    }
    
    func switchFlow() {
        flow = flow == .login ? .signUp : .login
        errorMessage = ""
    }
    
    private func wait() async {
        do {
            print("Wait")
            try await Task.sleep(nanoseconds: 1_000_000_000)
            print("Done")
        } catch {
            print(error.localizedDescription)
        }
    }
    
    func reset() {
        flow = .login
        email = ""
        password = ""
        confirmPassword = ""
    }
}

// MARK: - Email and Password Authentication

extension AppleLoginViewModel {
    func signInWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do {
            try await Auth.auth().signIn(withEmail: self.email, password: self.password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signUpWithEmailPassword() async -> Bool {
        authenticationState = .authenticating
        do  {
            try await Auth.auth().createUser(withEmail: email, password: password)
            return true
        } catch {
            print(error)
            errorMessage = error.localizedDescription
            authenticationState = .unauthenticated
            return false
        }
    }
    
    func signOut() {
        do {
            try Auth.auth().signOut()
        } catch {
            print(error)
            errorMessage = error.localizedDescription
        }
    }
    
    func deleteAccount() async -> Bool {
        do {
            try await user?.delete()
            return true
        } catch {
            errorMessage = error.localizedDescription
            return false
        }
    }
}

// MARK: Sign in with Apple

extension AppleLoginViewModel {
    
    func handleSignInWithAppleRequest(_ request: ASAuthorizationAppleIDRequest) {
        request.requestedScopes = [.fullName, .email]
        let nonce = randomNonceString()
        currentNonce = nonce
        request.nonce = sha256(nonce)
    }
    
    // 애플 로그인 요청의 결과를 처리하는 함수
    func handleSignInWithAppleCompletion(_ result: Result<ASAuthorization, Error>) async throws {
        if case .failure(let failure) = result {
            errorMessage = failure.localizedDescription
        } else if case .success(let authorization) = result {
            if let appleIDCredential = authorization.credential as? ASAuthorizationAppleIDCredential {
                guard let nonce = currentNonce else {
                    fatalError("Invalid state: a login callback was received, but no login request was sent.")
                }
                guard let appleIDToken = appleIDCredential.identityToken else {
                    print("Unable to fetch identity token.")
                    return
                }
                guard let idTokenString = String(data: appleIDToken, encoding: .utf8) else {
                    print("Unable to serialize token string from data: \(appleIDToken.debugDescription)")
                    return
                }

                let credential = OAuthProvider.credential(withProviderID: "apple.com",
                                                          idToken: idTokenString,
                                                          rawNonce: nonce)
                
                do {
                    let authResult = try await Auth.auth().signIn(with: credential)
                    let appleID = appleIDCredential.user
                    let email = appleIDCredential.email ?? "" // You might want to use the email if available

                    // Save the user to Firebase's Users collection
                    try await createUser()

                    // Perform any additional actions after successful login
                    await updateDisplayName(for: authResult.user, with: appleIDCredential)
                } catch {
                    print("Error authenticating: \(error.localizedDescription)")
                }
            }
        }
    }
    
    // Firebase 인증에 성공한 사용자의 디스플레이 이름을 Apple ID 크레덴셜의 이름으로 업데이트하는 함수
    func updateDisplayName(for user: FirebaseAuth.User, with appleIDCredential: ASAuthorizationAppleIDCredential, force: Bool = false) async {
        if let currentDisplayName = Auth.auth().currentUser?.displayName, !currentDisplayName.isEmpty {
            
        } else {
            let changeRequest = user.createProfileChangeRequest()
            changeRequest.displayName = appleIDCredential.displayName()
            do {
                try await changeRequest.commitChanges()
                self.displayName = Auth.auth().currentUser?.displayName ?? ""
            } catch {
                print("Unable to update the user's displayname: \(error.localizedDescription)")
                errorMessage = error.localizedDescription
            }
        }
    }
    
    // 닉네임 중복체크
    func nicknameCheck(completion: @escaping (Bool) -> Void) {
        dbRef.whereField("nickName", isEqualTo: nickName).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                completion(false) // 오류 발생 시 false를 반환
                return
            }
            // 중복된 닉네임이 없으면 querySnapshot은 비어 있을 것입니다.
            if querySnapshot?.isEmpty == true {
                print("중복되는 닉네임 없음")
                completion(false) // 중복된 이메일이 없을 경우 false를 반환
            } else {
                print("중복되는 닉네임 있음")
                completion(true) // 중복된 이메일이 있을 경우 true를 반환
            }
        }
    }
    func createUser() async throws {
        
        try await AuthStore.shared.createUser(email: email, password: password, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImage: selectedImage)
        
    }
    
//    // Users에 데이터 넣기
//    func createUser(id: String, email: String, appleID: String, nickname: String, phoneNumber: String) async throws {
//        // Firebase's Users collection reference
//        let usersRef = Firestore.firestore().collection("Users")
//        
//        // Create a document with the user's Apple ID as the document ID
//        try await usersRef.document(appleID).setData([
//            "id": appleID, "email": email, "nickname": nickname, "phoneNumber": phoneNumber// You can add more user data fields here
//        ])
//    }
    
    /// 로그인 스토어 데이터를 받아서 파이어베이스에 보내기 (email, 카카오, 애플)
    func addUserData(id: String, name: String, nickName: String, phoneNumber: String, profileImageString: String) async throws {
        do {
            let user = User(id: id, name: name, nickName: nickName, phoneNumber: phoneNumber, potato: 0, profileImageString: profileImageString, crustDepth: 0, tardyCount: 0, friendsIdArray: [], friendsIdRequestArray: [])
            try dbRef.document(id).setData(from: user)
            
        } catch {
            print("User 등록 실패")
        }
    }
    
    func login(email: String, password: String) async throws -> Bool {

        // 로그인한 유저 userSession에 저장
        self.userSession = try await Auth.auth().signIn(withEmail: email, password: password).user
        
        try await loadUserData()
        print("로그인 성공!")
  
        // 로그인 성공 여부 반환 필요
        return true
    }
    
    func verifySignInWithAppleAuthenticationState() {
        let appleIDProvider = ASAuthorizationAppleIDProvider()
        let providerData = Auth.auth().currentUser?.providerData
        if let appleProviderData = providerData?.first(where: { $0.providerID == "apple.com" }) {
            Task {
                do {
                    let credentialState = try await appleIDProvider.credentialState(forUserID: appleProviderData.uid)
                    switch credentialState {
                    case .authorized:
                        break // The Apple ID credential is valid.
                    case .revoked, .notFound:
                        // The Apple ID credential is either revoked or was not found, so show the sign-in UI.
                        self.signOut()
                    default:
                        break
                    }
                }
                catch {
                }
            }
        }
    }
    
}

extension ASAuthorizationAppleIDCredential {
    func displayName() -> String {
        return [self.fullName?.givenName, self.fullName?.familyName]
            .compactMap( {$0})
            .joined(separator: " ")
    }
}

// Adapted from https://auth0.com/docs/api-auth/tutorials/nonce#generate-a-cryptographically-random-nonce
private func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    var result = ""
    var remainingLength = length
    
    while remainingLength > 0 {
        let randoms: [UInt8] = (0 ..< 16).map { _ in
            var random: UInt8 = 0
            let errorCode = SecRandomCopyBytes(kSecRandomDefault, 1, &random)
            if errorCode != errSecSuccess {
                fatalError(
                    "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
                )
            }
            return random
        }
        
        randoms.forEach { random in
            if remainingLength == 0 {
                return
            }
            
            if random < charset.count {
                result.append(charset[Int(random)])
                remainingLength -= 1
            }
        }
    }
    
    return result
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
