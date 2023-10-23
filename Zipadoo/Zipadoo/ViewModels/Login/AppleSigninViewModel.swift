//
//  AppleSignInViewModel.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/18/23.
//

import SwiftUI
import Firebase
import CryptoKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseFirestoreSwift
import AuthenticationServices

class AppleSigninViewModel: ObservableObject {
    /// 로그인 상태
    @AppStorage ("logState") var logState = false
    @Published var nonce = ""
    
    @Published var id: String = ""
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var nickName: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
    @Published var selectedImage: UIImage?
    @Published var profileString: String = ""
    
    @State var loginResult: Bool = false // 로그인 성공 시 풀스크린 판별한 Bool 값
    @State var uniqueEmail: Bool = false // 이메일 중복 체크
    @State var isSigninLinkActive: Bool = false // uniqueEmail = false일 경우 회원가입뷰 버튼으로 활성화
    
    let dbRef = Firestore.firestore().collection("Users")
    
    /// 유저 로그인
    func login() async throws -> Bool {
        try await AuthStore.shared.login(email: Auth.auth().currentUser?.email ?? "not found email", password: Auth.auth().currentUser?.uid ?? "not found uid")
    }
    
    @MainActor
    /// 유저 회원가입
    func createUser() async throws {
        do {
            if let uiImage = selectedImage {
                profileString = try await ProfileImageUploader.uploadImage(image: uiImage) ?? "https://cdn.freebiesupply.com/images/large/2x/apple-logo-transparent.png"
                let user = User(id: id, name: name, nickName: nickName, phoneNumber: phoneNumber, potato: 0, profileImageString: profileString, crustDepth: 0, tardyCount: 0, friendsIdArray: [], friendsIdRequestArray: [])
                try dbRef.document(id).setData(from: user)
            }
        }
        //        try await AuthStore.shared.addUserDataApple(id: id, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImageString: profileString)
        //        try await AppleSigninStore.shared.createUser(email: email, password: password, name: name, nickName: nickName, phoneNumber: phoneNumber, profileImage: selectedImage)
    }
    
    // 이메일 중복 체크 (기존 회원 여부)
    func emailCheck(email: String, completion: @escaping (Bool) -> Void) {
        
        let userDB = Firestore.firestore().collection("User email")
        
        // 입력한 이메일이 있는지 확인하는 쿼리
        userDB.whereField("email", isEqualTo: email).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("데이터베이스 조회 중 오류 발생: \(error.localizedDescription)")
                completion(false) // 오류 발생 시 false를 반환
                return
            }
            
            // 중복된 이메일이 없으면 querySnapshot은 비어 있을 것입니다.
            if querySnapshot?.isEmpty == true {
                print("이메일 데이터 중복 없음, 회원 가입 뷰로 진행")
                completion(true) // 중복된 이메일이 없을 경우 true를 반환
            } else {
                print("이메일 데이터 중복 있음, 로그인 뷰로 진행")
                completion(false) // 중복된 이메일이 있을 경우 false를 반환
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
    
    func SigninWithAppleRequest(_ request: ASAuthorizationOpenIDRequest) {
        nonce = randomNonceString()
        request.requestedScopes = [.fullName, .email]
        request.nonce = sha256(nonce)
    }
    
    //@MainActor?
    func SinginWithAppleCompletion(_ result: Result <ASAuthorization, Error>) {
        switch result {
        case .success(let user):
            guard let credential = user.credential as? ASAuthorizationAppleIDCredential else {
                print("credential 26")
                return
            }
            guard let token = credential.identityToken else {
                print("error with token 30")
                return
            }
            guard let tokenString = String(data: token, encoding: .utf8) else {
                print("error with tokenString 34")
                return
            }
            let credwtion = OAuthProvider.credential(withProviderID: "apple.com", idToken: tokenString, rawNonce: nonce)
            Auth.auth().signIn(with: credwtion) { [weak self] authResult, error in
                guard let self = self else { return }
                
                if let error = error {
                    print("Firebase 로그인 실패: \(error.localizedDescription)")
                    // Firebase 로그인 실패에 대한 처리
                } else if let authResult = authResult {
                    print("Firebase 로그인 성공, 사용자 ID: \(authResult.user.uid)")
                    
                    // Firestore에 사용자 정보 저장
                    let userRef = dbRef.document(authResult.user.uid)
                    
                    let userData: [String: Any] = [
                        "id": authResult.user.uid,
                        "email": authResult.user.email ?? "",
                        "friendsIdArray": [],
                        "name": "빈 값",
                        "nickName": "빈 값",
                        "phoneNumber": "빈 값",
                        "phtato": 0,
                        "profileImageString": "",
                        "promiseCount": 0,
                        "crustDepth": 0,
                        "tardyCount": 0
                    ]
                    
                    userRef.setData(userData, merge: true) { error in
                        if let error = error {
                            print("Firestore에 사용자 정보 저장 실패: \(error.localizedDescription)")
                        } else {
                            print("Firestore에 사용자 정보 저장 성공")
                        }
                    }
                    // 사용자 로그인 상태 유지 (예: UserDefaults를 사용)
                    UserDefaults.standard.set(true, forKey: "isUserLoggedIn")
                }
            }
        case .failure(let failure):
            print("ASAuthorization 실패: \(failure.localizedDescription)")
        }
    }
    
    /// 회원가입인척 정보 수정 로직
    func editUsersStore() {
        
    }
}

func randomNonceString(length: Int = 32) -> String {
    precondition(length > 0)
    var randomBytes = [UInt8](repeating: 0, count: length)
    let errorCode = SecRandomCopyBytes(kSecRandomDefault, randomBytes.count, &randomBytes)
    if errorCode != errSecSuccess {
        fatalError(
            "Unable to generate nonce. SecRandomCopyBytes failed with OSStatus \(errorCode)"
        )
    }
    
    let charset: [Character] =
    Array("0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._")
    
    let nonce = randomBytes.map { byte in
        charset[Int(byte) % charset.count]
    }
    return String(nonce)
}

private func sha256(_ input: String) -> String {
    let inputData = Data(input.utf8)
    let hashedData = SHA256.hash(data: inputData)
    let hashString = hashedData.compactMap {
        String(format: "%02x", $0)
    }.joined()
    
    return hashString
}
