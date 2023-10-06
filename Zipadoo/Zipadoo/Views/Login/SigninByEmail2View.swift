//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct SigninByEmail2View: View {
    
    @ObservedObject var emailLoginStore: EmailLoginStore
    
    @State private var isShowingImagePicker = false
    /// 상단 안내 문구
    @State private var adminMessage = "\n프로필 사진을 등록해주세요."
    @State private var defaultProfileImage = Image("person.circle")
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all) // 배경색
            
            VStack(alignment: .leading) {
                Rectangle().frame(height: 30) // Spacer() 대용
                
                HStack {
                    Spacer()
                    
                    Text(adminMessage) // 상단 안내 문구
                        .foregroundColor(.white)
                        .font(.title2)
                        .fontWeight(.semibold)
                        .padding(.bottom, 10)
                        .padding(.leading, 15)
                    
                    Spacer()
                }
                
                HStack {
                    Spacer()
                    
                    // 앨범 이미지 선택 버튼
                    ZStack {
                        
                        Button {
                            isShowingImagePicker.toggle()
                            
                        } label: {
                            // 프로필 사진 선택할 경우 프로필 사진으로 표시, 아닐 경우 기본 이미지를 보이도록 함
                            VStack {
                                if let profileImage = emailLoginStore.selectedImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .clipShape(Circle())
                                } else {
                                    Image("defaultProfile")
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: UIScreen.main.bounds.width * 0.8, height: UIScreen.main.bounds.width * 0.8)
                                        .foregroundColor(Color.white.opacity(0.5))
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                            }
                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePicker(selectedImage: $emailLoginStore.selectedImage)
                                .ignoresSafeArea(.all)
                            
                        } // ZStack
                    }
                    
                    Spacer()
                }
                
                Spacer()
            }
            .padding(.leading, 15)
            .padding(.trailing, 15)
            .background(Color.black)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    
                    Button {
                        Task {
                            try await emailLoginStore.createUser()
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
    SigninByEmail2View(emailLoginStore: EmailLoginStore())
}
