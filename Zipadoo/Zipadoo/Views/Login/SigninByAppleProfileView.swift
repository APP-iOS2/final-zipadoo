//
//  SigninByAppleProfileView.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/18/23.
//

import SwiftUI

struct SigninByAppleProfileView: View {
    
    @ObservedObject var appleLoginViewModel: AppleLoginViewModel
    @State private var isShowingImagePicker = false
    /// 상단 안내 문구
    @State private var adminMessage = "\n프로필 사진을 등록해주세요."
    @State private var defaultProfileImage = Image("person.circle")
    
    var body: some View {
        ZStack {
            Color.primary.ignoresSafeArea(.all) // 배경색
            
            VStack(alignment: .leading) {
                Spacer().frame(width: 50, height: 50)// 공간
                HStack {
                    Spacer()
                    // - MARK: 상단 메세지: 프로필 사진 등록해주세요
                    Text(adminMessage)
                        .foregroundColor(.primary)
                        .colorInvert()
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                        .padding(.leading, 15)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    // MARK: - 앨범 이미지 선택 버튼
                    ZStack {
                        
                        Button {
                            isShowingImagePicker.toggle()
                            
                        } label: {
                            // 프로필 사진 선택할 경우 프로필 사진으로 표시, 아닐 경우 기본 이미지를 보이도록 함
                            VStack {
                                if let profileImage = appleLoginViewModel.selectedImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                                        .foregroundColor(Color.secondary)
                                        .clipShape(Circle())
                                } else {
                                    Image("defaultProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                                        .foregroundColor(Color.secondary
                                        )
                                        .background(Color.secondary)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImage: $appleLoginViewModel.selectedImage)
                                .ignoresSafeArea(.all)
                        } // ZStack
                    }
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .background(Color.primary)
            // MARK: - 상단 회원가입 버튼
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        Task {
                            try await appleLoginViewModel.createUser()
                        }
                    } label: {
                        Text("회원가입")
                            .fontWeight(.semibold)
                            .padding(.trailing, 5)
                            .font(.headline)
                    }
                }
            }
        }
    }
}

#Preview {
    SigninByEmail2View(emailLoginStore: EmailLoginStore(), appleLoginViewModel: AppleLoginViewModel())
}
