//
//  ProfileImageView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

struct ProfileImageView: View {
    
    /// 파베작업 후 받아올 유저의 프로필 이미지
    let imageString: String
    
    let size: ProfileImageSize
    
    var body: some View {
        
        // 일단 Async이미지로 작성 -> 스토리지에 사진 삭제됐을때도 대비해서 코드작성
        AsyncImage(url: URL(string: imageString)) { phase in // 이미지
            if let image = phase.image {
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(Circle())
            } else {
                Image(systemName: "person.circle")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: size.dimension, height: size.dimension)
                    .clipShape(Circle())
                    .foregroundColor(.gray)
            }
        } // AsyncImage
    } // body
} // struct

#Preview {
    ProfileImageView(imageString: "", size: .medium)
}
