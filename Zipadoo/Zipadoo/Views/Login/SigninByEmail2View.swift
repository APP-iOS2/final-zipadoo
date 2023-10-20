//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct SigninByEmail2View: View {
    
    @ObservedObject var emailLoginStore: EmailLoginStore
    
    /// 이미지 피커 Bool 값
    @State private var isShowingImagePicker = false
    /// 상단 안내 문구
    @State private var adminMessage = "\n프로필 사진을 등록해주세요."
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
                .frame(width: 50, height: 50)
            
            // MARK: - 상단 메세지: 프로필 사진 등록해주세요
            Text(adminMessage)
                .foregroundColor(.primary)
                .font(.title2)
                .fontWeight(.semibold)
                .padding(.bottom, 10)
                .padding(.leading, 15)
            
            // MARK: - 앨범 이미지 선택 버튼
            Button {
                isShowingImagePicker.toggle()
            } label: {
                // 프로필 사진 선택할 경우 프로필 사진으로 표시, 아닐 경우 기본 이미지를 보이도록 함
                if let profileImage = emailLoginStore.selectedImage {
                    Image(uiImage: profileImage)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .profileImageModifier()
                } else {
                    Image("defaultProfile")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .profileImageModifier()
                }
            }
            .sheet(isPresented: $isShowingImagePicker) {
                ImagePicker(selectedImage: $emailLoginStore.selectedImage)
                    .ignoresSafeArea(.all)
            }
            
            Spacer()
        } // VStack
        .padding(.horizontal, 15)
        
        // MARK: - 상단 회원가입 버튼
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                Button("회원가입") {
                    Task {
                        try await emailLoginStore.createUser()
                    }
                }
            }
        } // toolbar
    } // body
} // struct

#Preview {
    SigninByEmail2View(emailLoginStore: EmailLoginStore())
}
