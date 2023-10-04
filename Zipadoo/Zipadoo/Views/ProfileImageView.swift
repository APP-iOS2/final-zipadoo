//
//  ProfileImageView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

enum ProfileImageSize {
    case xSmall
    case small
    case medium
    case large

    var dimension: CGFloat {
        switch self {
        case .xSmall:
            return 50
        case .small:
            return 60
        case .medium:
            return 150
        case .large:
            return 200
        }
    }
}
/*
let dummyImageString: String = "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSW47UEfYkQQFKwJfi2sD9SjB4uMYS6zC_RAw&usqp=CAU"
*/
struct ProfileImageView: View {
    
    /// 파베작업 후 받아올 유저의 프로필 이미지
    let imageString: String
    let size: ProfileImageSize
    
    var body: some View {
        
        // 일단 Async이미지로 작성 -> 스토리지에 사진 삭제됐을때도 대비해서 코드작성
        AsyncImage(url: URL(string: imageString)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: size.dimension, height: size.dimension)
                .clipShape(Circle())
            
        } placeholder: {
            ProgressView()
        }
    }
}

#Preview {
    ProfileImageView(imageString: "", size: .medium)
}
