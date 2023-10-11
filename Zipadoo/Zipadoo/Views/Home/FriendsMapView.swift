//
//  FriendsMapView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/11.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - 친구와 자신의 현황을 표시하는 뷰
/// gpsStore를 가지고 위도 경도 등 위치 데이터 가져오기
/// view에 더 필요한 내용이 있으면 ViewModel 따로 작업하기
/// 1. 나의 현재위치 표시, 도착지점 표시?
/// 2. 친구 시트 구현하기
/// 3. 친구 클릭시 친구 위치 확인가능, annotation으로 표현하는게 낫지 않을까? -> 일단 파베 데이터 올라가는거 확인 후 그 뒤에 다같이 Location 어떻게할지 얘기하면서 변경
/// 4. 위도 경도 파베에 보내기
/// 참고 상규님 MapView, NewMapView

// 사용자 정의 Annotation 유형
struct MyAnnotation: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
    let name: String
    let city: String
    let imageString: String
}

struct FriendsMapView: View {
    @StateObject var gpsStore = GPSStore()
    // Annotation 배열 생성
    @State private var friendsAnnotation = [
        MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.547551, longitude: 127.080315), name: "정한두", city: "서울", imageString: "dragon"),
        MyAnnotation(coordinate: CLLocationCoordinate2D(latitude: 37.536981, longitude: 126.999426), name: "임병구", city: "서울", imageString: "bear")
    ]
    
    let destinationCoordinate = CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323)
    @State var isShowingFriendSheet: Bool = false
    @Namespace var mapScope
    /// 초기 위치 값
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    /// 주소 값
    @State var address = ""
    /// 화면 클릭 값(직접설정맵뷰)
    @State private var selectedPlace: Bool = false
    // Marker는 시각적, Anntation은 정보 포함
    var body: some View {
        NavigationStack {
            VStack {
                Map {
                    // 현재 위치 표시
                    UserAnnotation(anchor: .center)
                    // 도착 위치 표시
                    Annotation("도착지점", coordinate: destinationCoordinate) {
                        Image(systemName: "apple.logo")
                    }
                    // 친구 위치 표시
                    ForEach(friendsAnnotation) { annotation in
                        Annotation(annotation.name, coordinate: annotation.coordinate, anchor: .center) {
                            Image(annotation.imageString)
                                .resizable()
                                .resizable()
                                .frame(width: 30, height: 30) // 크기 조절
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                }
                .mapControls {
                    MapUserLocationButton()
                }
                Button {
                    isShowingFriendSheet = true
                } label: {
                    Text("어디까지 왔나")
                }

            }
            .sheet(isPresented: $isShowingFriendSheet) {
                FriendsLocationListView(isShowingFriendSheet: $isShowingFriendSheet)
                    .presentationDragIndicator(.visible)
            }
        }
    }
}

#Preview {
    FriendsMapView()
}
