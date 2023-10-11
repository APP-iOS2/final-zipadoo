//
//  ArrivalResultTempView.swift
//  Zipadoo
//
//  Created by 나예슬 on 2023/10/10.
//

import SwiftUI
import UIKit

struct ArrivalResultTempView: View {
    @ObservedObject private var promiseDetailStore = PromiseDetailStore()
    @Environment(\.dismiss) private var dismiss
    @State private var currentDate: Double = 0.0
    @State private var remainingTime: Double = 0.0
    @State private var isShowingAlert: Bool = false
    var color: UIColor = #colorLiteral(red: 0.9529411793, green: 0.6862745285, blue: 0.1333333403, alpha: 1)
    
    @ObservedObject var userStore = UserStore() // 임시로 넣은 viewModel
    
    var statusColor: Color {
        remainingTime < 60 * 30 ? .primary : .secondary
    }
    
    var body: some View {
        NavigationStack {
            VStack(alignment: .leading) {
                titleView
                
                destinationView
                
                dateView
                
                remainingTimeView
                
                ScrollView(showsIndicators: false) {
                    HStack {
                        Image(systemName: "person.circle")
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(width: 50, height: 50)
                            .clipShape(Circle())
                            .foregroundColor(.gray)
                        
                        VStack(alignment: .leading) {
                            
                            Text("지각 안하는 사람")
                                .fontWeight(.semibold)
                            
                            Text("10분 먼저 도착")
                                .font(.footnote)
                            
                        }
                        
                        Spacer()
                        
                        Text("1등")
                            .padding(3)
                            .foregroundColor(.white)
                            .frame(width: 90)
                            .background(Color(color))
                            .cornerRadius(5)
                    }
                    .padding(.bottom, 12)
                    
                    ForEach(userStore.userFetchArray) { friend in
                        
                        arrivedLateDataCell(friend: friend)
                            .padding(.bottom, 12)
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 15, bottom: 0, trailing: 15))
            }
            .padding(.horizontal, 15)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        isShowingAlert.toggle()
                    } label: {
                        Text("삭제")
                    }
                    .alert(isPresented: $isShowingAlert) {
                        Alert(
                        title: Text("약속 내역을 삭제합니다."),
                        message: Text("해당 작업은 복구되지 않습니다."),
                        primaryButton: .destructive(Text("삭제하기"), action: {
                        dismiss()
                        }),
                        secondaryButton: .default(Text("돌아가기"), action: {
                                
                            })
                        )
                    }
                }
            }
            .onAppear {
                Task {
                    userStore.fetchAllUsers()
                }
            }
        }
    }
    
    private var titleView: some View {
        Text(promiseDetailStore.promise.promiseTitle)
            .font(.largeTitle)
            .bold()
            .padding(.vertical, 12)
    }
    
    private var dateView: some View {
        Text(("일시 : \(promiseDetailStore.calculateDate(date: promiseDetailStore.promise.promiseDate))"))
            .padding(.vertical, 3)
    }
    
    private var destinationView: some View {
        Text("장소 : \(promiseDetailStore.promise.destination)")
    }
    
    private var remainingTimeView: some View {
        Text("약속 종료")
            .foregroundStyle(.white)
            .bold()
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .background(.gray)
            .clipShape(RoundedRectangle(cornerRadius: 12))
            .padding(.vertical, 12)
    }
    
    private func arrivedEarlyDataCell(friend: User) -> some View {
        HStack {
            // 이미지
            ProfileImageView(imageString: friend.profileImageString, size: .xSmall)
            
            VStack(alignment: .leading) {
                
                Text(friend.nickName)
                    .fontWeight(.semibold)
                
                Text("10분 먼저 도착")
                    .font(.footnote)
                
            }
            
            Spacer()
            
            Text("1등")
                .padding(3)
                .foregroundColor(.white)
                .frame(width: 90)
                .background(Color(color))
                .cornerRadius(5)
        }
    }
    
    private func arrivedLateDataCell(friend: User) -> some View {
        HStack {
            // 이미지
            ProfileImageView(imageString: friend.profileImageString, size: .xSmall)
            
            VStack(alignment: .leading) {
                
                Text(friend.nickName)
                    .fontWeight(.semibold)
                
                Text("-500 감자")
                    .font(.footnote)
            }
            
            Spacer()
            
            Text("15분 지각")
                .padding(3)
                .foregroundColor(.white)
                .frame(width: 90)
                .background(.red)
                .cornerRadius(5)
        }
    }
}

#Preview {
    ArrivalResultTempView()
}
