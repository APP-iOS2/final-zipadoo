//
//  LoginStore.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import Foundation
import SwiftUI
import Firebase

class EmailLoginStore : ObservableObject {
    
    @Published var email: String = ""
    @Published var password: String = ""
    @Published var nickName: String = ""
    @Published var name: String = ""
    @Published var phoneNumber: String = ""
//    @Published var isLoggedIn: Bool = false
    @Published var errorMessage: String?
    
    @Published var profileImage: UIImage?
 
    @Published var selectedImage: UIImage?
    
  
    
    
    // 함수
    
    func registerUserAction() {
        FirebaseUtil.shared.auth.createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("회원가입 중 오류 발생: \(error.localizedDescription)")
                return
            }
            // 회원가입 성공
            print("회원가입 사용자: \(authResult?.user.email ?? "")")
            
            // 프로필 이미지 업로드, 다른 뷰로 이동하는 등 추가 작업 수행
            self.uploadImage()
        }
    }
    
    func uploadImage() {
        guard let safeProfileImage = profileImage else {
            print("이미지 선택 안됨")
            return
        }
        // 파이어베이스 스토리지에 업로드하려면, 인증된 사용자여야 됨.
        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else { // 현재 로그인 상태인지 체크
            print("로그인 안됨")
            return
        }
        // 스토리지에 저장할 경로
        let imagePath = "images/\(UUID().uuidString).jpg" // images 폴더 밑에 UUID를 생성한 뒤 .jpg 형태로 이미지 생성
        
        uploadImageToStorage(safeProfileImage, path: imagePath) { result in
            switch result {
            case .success(let downloadURL):
                print("이미지 업로드 성공: \(downloadURL)")
                // 회원정보 DB에. 수록 : 인증(uid, 이메일, 프로필 이미지 경로)
                self.storeUserInformation(profileImageUrl: downloadURL)
            case .failure(let error):
                print("이미지 업로드 실패: \(error.localizedDescription)")
            }
        }
    }
    
    func storeUserInformation(profileImageUrl: String?) {
        guard let profileImageUrl = profileImageUrl else {
            print("프로필 이미지 경로가 nil입니다.")
            return
        }
        
        guard let uid = FirebaseUtil.shared.auth.currentUser?.uid else {
            print("로그인 안됨")
            return
        }
        
        let userEmail = FirebaseUtil.shared.auth.currentUser?.email ?? ""
        let userInfo: [String: Any] = [
            "uid": uid,
            "email": userEmail,
            "profileImageUrl": profileImageUrl
        ]
        
        FirebaseUtil.shared.firestore.collection("Users").document(uid).setData(userInfo) { error in
            if let error = error {
                print("회원 정보 저장 중 오류 발생: \(error.localizedDescription)")
            } else {
                print("회원 정보 저장 성공")
                // 회원 정보 저장이 완료되면 이동하건 다른 작업을 수행할 수 있음
                
            }
        }
        
    }
    
    func uploadImageToStorage(_ image: UIImage, path: String, completion: @escaping (Result<String, Error>) -> Void) {
        // @escaping는 이 클로저 함수가 이 블록을 이 함수 호출을 넘어서도 한번 더 호출될 수 있도록 해주는 지시어
        // 1. 이미지를 Data로 변환 (jpegData로 0.5(50%) 축소된 상태로 올라감)
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            completion(.failure(NSError(domain: "ImageConversion", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to convert image to data"])))
            return
        }
        
        // 2. Firebase 스토리지 참조 생성
        let storageRef = FirebaseUtil.shared.storage.reference().child(path)
        
        // 3. 이미지 데이터 업로드
        storageRef.putData(imageData, metadata: nil) { metadata, error in
            if let error = error {
                // 오류 발생 시 에러 로그 찍어줌
                completion(.failure(error))
                return
            }
            // 4. 다운로드 URL 가져오기
            storageRef.downloadURL { url, error in
                if let error = error {
                    // 오류 발생 시
                    completion(.failure(error))
                    return
                }
                // url이 completion 클로저에 담겨오기 때문에 아래 URL을 사용하면 됨
                if let url = url {
                    // 다운로드 URl 성공적으로 가져옴 (성공했을 때 결국 URL 객체에 absoluteString에 실제적으로 URL이 찍힘)
                    completion(.success(url.absoluteString))
                } else {
                    completion(.failure(NSError(domain: "DownloadURL", code: -1, userInfo: [NSLocalizedDescriptionKey: "Failed to get download URL"])))
                }
            }
        }
    }
    
    func loginUserAction() {
        FirebaseUtil.shared.auth.signIn(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("로그인 중 오류 발생: \(error.localizedDescription)")
                return
            }
            
            // 로그인 성공
                     print("로그인한 사용자: \(authResult?.user.email ?? "")")
                     print("로그인한 사용자: \(authResult?.user.uid ?? "")")
            
            // 다른 뷰로 이동하는 등 추가 작업 수행
            
        }
    }
    
}
