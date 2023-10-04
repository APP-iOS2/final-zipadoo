//
//  ArriveResultView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/22.
//

import SwiftUI

/// 지각 안한 사람 닉네임
var dummyPercentage = ["닉넴1", "닉넴2", "닉넴3", "닉넴4", "닉넴4", "닉넴4", "닉넴4"]
/// 지각자 닉네임
var lateCommer = ["지각자1", "지각자2", "지각자3"]

struct ArriveResultView: View {

    @ObservedObject var userStore = UserStore() // 임시로 넣은 viewModel

    var body: some View {
        
        VStack {
            Text("참석자들의 도착 정보에요!")
                .padding()
            
            ScrollView {
                ForEach(userStore.userFetchArray) { friend in
                    
                    arrivedDataCell(friend: friend)
                        .padding(.bottom, 12)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            
            // 지각자
            ZStack {
                
                // conerRadius 적용위해 ZStack사용 했습니다
                Rectangle()
                    .cornerRadius(15)
                    .ignoresSafeArea()
                    .foregroundColor(.gray) // 임시 색
                    
                ScrollView {
                    ForEach(userStore.userFetchArray) { lateFriend in
                        
                        arrivedDataCell(friend: lateFriend)
                            .padding(.bottom, 12)
                    }
                }
                .padding()
                
            }
            .frame(height: UIScreen.main.bounds.size.height * 0.35)

        }
        .onAppear {
            Task {
                userStore.fetchAllUsers()
            }
        }
    }
    
    /// 약속 멤버 도착정보 행(row)
    private func arrivedDataCell(friend: User) -> some View {
        HStack {
            // 이미지
            ProfileImageView(imageString: friend.profileImageString, size: .xSmall)
            
            VStack(alignment: .leading) {
                
                Text(friend.nickName)
                    .fontWeight(.semibold)
                
                Text("Comment")
                    .font(.footnote)
                
            }
            
            Spacer()

            Text("순위/지각")
                .padding(3)
                .background(.yellow) // 임시 색
                .cornerRadius(5)
            
        }
    }
}

#Preview {
    
    ArriveResultView()
    
}
