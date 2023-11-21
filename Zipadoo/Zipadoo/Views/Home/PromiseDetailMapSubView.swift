//
//  PromiseDetailMapSubView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/12.
//

import SwiftUI
import CoreLocation
import MapKit

// MARK: - 구성원 위치 현황 및 약속 시간 현황 나열 메뉴 뷰
/// PromiseDetailMapView에서 사용
struct PromiseDetailMapSubView: View {
    // 위치 정보 관리를 위한 ObservedObject
    @ObservedObject var locationStore: LocationStore
    
    // 맵뷰의 카메라 위치를 제어하는 Binding
    @Binding var region: MapCameraPosition
    
    // 목적지 좌표
    let destinationCoordinate: CLLocationCoordinate2D
    
    // 약속 정보
    var promise: Promise
    
    // 친구 현황 시트를 보여주는 Binding
    @Binding var isShowingFriendSheet: Bool
    
    // 프로그레스 바 갱신을 제어하는 State 변수
    @State private var progressTrigger: Bool = false
    
    // 현재 표시되는 높이를 제어하는 Binding
    @Binding var detents: PresentationDetent
    
    var body: some View {
        VStack(alignment: .leading) {
            // 약속 정보 및 시간을 표시하는 뷰
            PromiseTitleAndTimeView(promise: promise)
            
            // 스크롤 가능한 뷰 내에 프로그레스 바를 표시하는 뷰
            ScrollView {
                PromiseDetailProgressBarView(locationStore: locationStore, isShowingFriendSheet: $isShowingFriendSheet, region: $region, destinationCoordinate: destinationCoordinate, promise: promise, progressTrigger: $progressTrigger, detents: $detents)
            }
            .scrollIndicators(.hidden)
        }
        .toolbar(content: {
            // 상단 툴바에 닫기 버튼 추가
            ToolbarItem(placement: .topBarTrailing) {
                Button {
                    isShowingFriendSheet = false
                } label: {
                    Image(systemName: "x.square")
                }
            }
        })
        .padding()
        .onDisappear {
            // 뷰가 사라질 때 프로그레스 바 갱신 및 높이 초기화
            progressTrigger = false
            detents = .medium
        }
    }
}

#Preview {
    PromiseDetailMapSubView(locationStore: LocationStore(), region: .constant(.automatic),
                            destinationCoordinate: CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323),
                            promise: Promise(id: "", makingUserID: "", promiseTitle: "사당역 모여라", promiseDate: 1697694660, destination: "왕십리 캐치카페", address: "서울특별시 관악구 청룡동", latitude: 37.47694972793077, longitude: 126.98195644152227, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10),
                            isShowingFriendSheet: .constant(true), detents: .constant(.medium))
}
