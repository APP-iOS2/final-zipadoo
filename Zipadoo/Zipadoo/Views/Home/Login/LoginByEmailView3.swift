//
//  SwiftUIView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import SwiftUI

struct LoginByEmailView3: View {

    @ObservedObject var viewModel: EmailLoginStore 
    @State var isShowingImagePicker = false
    @State var gotoHome: Bool = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all)
            
                VStack(alignment: .leading) {
                    Rectangle().frame(height: 50)
                    HStack {
                        Text("프로필 사진을 등록해주세요.")
                            .foregroundColor(.white)
                            .font(.title2)
                            .fontWeight(.semibold)
                            .padding(.bottom, 10)
                        
                        Spacer()
                     
                    }
                    HStack {
                        Spacer()
                        Button {
                            isShowingImagePicker.toggle()
                        } label: {
                            VStack {
                                if let profileImage = viewModel.profileImage {
                                    Image(uiImage: profileImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                        .foregroundColor(.white.opacity(0.5))
                                        .clipShape(Circle())
                                } else {
                                     Image(systemName: "perosn.circle")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: UIScreen.main.bounds.width * 0.8)
                                        .foregroundColor(.white.opacity(0.5))
                                        .background(Color.white)
                                        .clipShape(Circle())
                                }
                            }

                        }
                        .sheet(isPresented: $isShowingImagePicker) {
                            ImagePickerView(selectedImage: $viewModel.profileImage)
                                .ignoresSafeArea(.all)
                        }
                        Spacer()

                    }
                    Spacer()
                    
                }
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.black)
                .navigationBarItems(trailing: Button(action: {
                    viewModel.registerUserAction()
                    gotoHome = true
//                    viewModel.isLoginMode = true
                }, label: {
                    Text("회원가입")
                                            .fontWeight(.semibold)
                                            .padding(.trailing, 5)
                                            .font(.headline)
                }
                                                     
                                                            ))
            
//            navigationDestination(isPresented: $isLoginMode) {
//                ContentView()
//                Text("")
//                    .hidden()
//            }
            NavigationLink(
               destination: ContentView(),
               isActive: $gotoHome, // gotoHome가 true일 때 ContentView로 이동
               label: {
                   Text("")
               }
            )
        }
    }
    
}
