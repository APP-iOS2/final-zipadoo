//
//  PromiseTrackingView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/15.
//

import SwiftUI
/*
 struct PromiseTrackingView: View {
 
 @StateObject var promiseViewModel: PromiseViewModel
 let currentUser = AuthStore.shared.currentUser
 
 var body: some View {
 NavigationStack {
 if let loginUserID = currentUser?.id {
 // 내가만든 약속 또는 참여하는 약속 불러오기
 let filteredPromises = promiseViewModel.fetchTrackingPromiseData.filter { promise in
 return loginUserID == promise.makingUserID || promise.participantIdArray.contains(loginUserID)
 }
 
 if filteredPromises.isEmpty {
 Text("추적중인 약속이 없습니다")
 } else {
 ScrollView {
 ForEach(filteredPromises) { promise in
 NavigationLink {
 PromiseDetailView(promise: promise)
 } label: {
 VStack(alignment: .leading) {
 
 // MARK: - 약속 제목, 맵 버튼
 HStack {
 Text(promise.promiseTitle)
 .font(.title)
 .fontWeight(.bold)
 
 Spacer()
 
 Image(systemName: "map.fill")
 .fontWeight(.bold)
 .foregroundStyle(Color.primary)
 .colorInvert()
 .padding(8)
 .background(Color.primary)
 .clipShape(RoundedRectangle(cornerRadius: 10))
 .overlay(
 RoundedRectangle(cornerRadius: 10)
 .shadow(color: .primary, radius: 1, x: 1, y: 1)
 .opacity(0.3)
 //
 )
 }
 .padding(.vertical, 15)
 // MARK: - 장소, 시간
 Group {
 HStack {
 Image(systemName: "pin")
 Text("\(promise.destination)")
 }
 .padding(.bottom, 5)
 
 /// 저장된 promiseDate값을 Date 타입으로 변환
 let datePromise = Date(timeIntervalSince1970: promise.promiseDate)
 
 HStack {
 Image(systemName: "clock")
 Text("\(formatDate(date: datePromise))")
 }
 .padding(.bottom, 25)
 
 // MARK: - 도착지까지 거리, 벌금
 HStack {
 Text("6km")
 Spacer()
 
 Text("5,000원")
 .fontWeight(.semibold)
 .font(.title3)
 }
 .padding(.vertical, 10)
 
 }
 .font(.callout)
 .fontWeight(.semibold)
 .foregroundStyle(Color.primary).opacity(0.5)
 // 참여자의 ID를 통해 참여자 정보 가져오기
 }
 // MARK: - 약속 테두리
 .padding()
 .overlay(
 ZStack {
 RoundedRectangle(cornerRadius: 10)
 .foregroundColor(.primary)
 .opacity(0.05)
 .shadow(color: .primary, radius: 10, x: 5, y: 5)
 }
 
 )
 .foregroundStyle(Color.primary)
 
 }
 
 .padding()
 
 }
 }
 }
 }
 }
 .onAppear {
 Task {
 try await promiseViewModel.fetchData()
 }
 }
 .refreshable {
 Task {
 try await promiseViewModel.fetchData()
 }
 }
 }
 }
 
 #Preview {
 PromiseTrackingView(promiseViewModel: PromiseViewModel())
 }
 */
