//
//  SigninByEmailView.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/26.
//

import SwiftUI

struct SigninByEmailView: View {
    @ObservedObject var emailLoginStore: EmailLoginStore
    
    @State private var isPasswordVisible = false // 비밀번호 보이기
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea(.all) // 배경색
            
            VStack(alignment: .leading) {
                
                Rectangle().frame(height: 50) // Spacer() 공간
                
                Text("계정이 없습니다. \n가입할 이름과 휴대폰 번호를 입력해 주세요.")
                    .foregroundColor(.white)
                    .font(.title2)
                    .fontWeight(.semibold)
                    .padding(.bottom, 10)
                    .padding(.leading, 15)
                
                Group {
                    // 이름 입력 칸
                    HStack {
                        TextField("닉네임", text: $emailLoginStore.nickName, prompt: Text("닉네임").foregroundColor(.gray))
                            .foregroundColor(Color.white)
                            .opacity(0.9)
                            .font(.title3)
                            .fontWeight(.semibold)
                            .autocapitalization(.none)
                            .frame(height: 35)
                        
                        // 입력한 내용 지우기 버튼
                        Button {
                            emailLoginStore.nickName = ""
                        } label: {
                            Image(systemName: "x.circle.fill")
                        }
                    }
                    .foregroundColor(.white.opacity(0.4))
                    
                    Rectangle().frame(height: 1)
                        .foregroundStyle(.white.opacity(0.5))
                        .padding(.bottom, 5)
                    
                    // 하단 안내 문구
                    HStack {
                        Text("프로필 수정에서 변경 가능합니다.")
                            .font(.subheadline)
                            .foregroundStyle(.white.opacity(0.7))
                        Spacer()
                    }
                    
                    // 휴대폰 번호 입력 칸
                    Spacer()
                        .frame(height: 20) // 공간용
                    
                    Group {
                        HStack {
                            TextField("휴대폰 번호", text: $emailLoginStore.phoneNumber, prompt: Text("휴대폰 번호").foregroundColor(.gray))
                                .foregroundColor(Color.white)
                                .opacity(0.9)
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                                .keyboardType(.numberPad)
                            
                            // 입력한 내용 지우기 버튼
                            Button {
                                emailLoginStore.phoneNumber = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                            }
                        }
                        .foregroundColor(.white.opacity(0.4))
                        
                        // 텍스트필드 줄
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.bottom, 5)
                        
                        HStack {
                            Text("본인인증 수단으로 사용됩니다.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Spacer()
                        }
                    }
                    
                    Spacer()
                        .frame(height: 20)// 공간용
                    
                    Group {
                        HStack {
                            SecureField("비밀번호", text: $emailLoginStore.password, prompt: Text("비밀번호").foregroundColor(.gray))
                                .foregroundColor(Color.white.opacity(0.3))
                                .font(.title3)
                                .fontWeight(.semibold)
                                .autocapitalization(.none)
                                .frame(height: 35)
                            
                            // 입력한 내용 지우기 버튼
                            Button {
                                emailLoginStore.password = ""
                            } label: {
                                Image(systemName: "x.circle.fill")
                            }
                        }
                        .foregroundColor(.white.opacity(0.4))
                        
                        Rectangle().frame(height: 1)
                            .foregroundStyle(.white.opacity(0.5))
                            .padding(.bottom, 5)
                        
                        // 하단 안내 문구
                        HStack {
                            Text("6자리 이상 입력해주세요.")
                                .font(.subheadline)
                                .foregroundStyle(.white.opacity(0.7))
                            
                            Spacer()
                        }
                    }// Group 휴대폰번호 입력 창
                    Spacer()
                } // Group
                .padding(.leading, 15)
                .padding(.trailing, 15)
                .background(Color.black)
                .navigationBarItems(trailing: NavigationLink(destination: {
                    SigninByEmail2View(emailLoginStore: emailLoginStore)
                }, label: {
                    Text("다음")
                        .fontWeight(.semibold)
                        .padding(.trailing, 5)
                        .font(.headline)
                }))
            }
        }
    }
}
#Preview {
    SigninByEmailView(emailLoginStore: EmailLoginStore())
}
