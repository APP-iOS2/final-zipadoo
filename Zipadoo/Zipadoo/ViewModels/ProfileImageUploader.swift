//
//  ProfileImageUploader.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/24.
//

import FirebaseStorage
import SwiftUI

/// 파베 스토리지에 사진 업로드 한 뒤 스토리지 URL반환
struct ProfileImageUploader {
    
    static func uploadImage(image: UIImage) async throws -> String? {
        
        guard let image = image.jpegData(compressionQuality: 0.5) else { return nil }
        
        // Create a root reference
        let storageRef = Storage.storage().reference()
        
        // Point to "ProfileImages/filename"
        let filename = UUID().uuidString
        let imageRef = storageRef.child("ProfileImages/\(filename)")
        
        do {
            // 업로드
            _ = try await imageRef.putDataAsync(image)
            // access to download URL after upload
            let imageUrl = try await imageRef.downloadURL()
            
            return imageUrl.absoluteString
            
        } catch {
            print("error: \(error.localizedDescription)")
            return nil // nil 반환시 에러
        }
    }
}
