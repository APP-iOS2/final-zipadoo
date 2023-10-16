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

struct FriendsMapView: View {
    @StateObject private var locationStore = LocationStore()
    @StateObject private var gpsStore = GPSStore()
    
    // 친구 위치 배열
    @State private var friendsAnnotation = [
        Location(participantId: "유저 아이디 넣을거임", departureLatitude: 37.547551, departureLongitude: 127.080315, currentLatitude: 37.547551, currentLongitude: 127.080315),
        Location(participantId: "유저 아이디 넣을거임", departureLatitude: 37.536981, departureLongitude: 126.999426, currentLatitude: 37.536981, currentLongitude: 126.999426)
    ]
    // 도착지점, 로케이션이 아닌 약속에 가져야하는가?
    let destinationCoordinate = CLLocationCoordinate2D(latitude: 37.497940, longitude: 127.027323)
    // 로케이션 데이터 분기를 위한 프로퍼티
    @State private var firstUploadLocation: Bool = true
    // 파베에 로케이션 보내기 위한 구조체
    @State private var myLocation: Location = Location(id: "F3A8AE7F-2820-4D39-8768-80B8B89AB5A7", participantId: "", departureLatitude: 0, departureLongitude: 0, currentLatitude: 0, currentLongitude: 0)
    // 예상 경로 색
    let strokeColors: [UIColor] = [
        .red, .orange, .yellow, .green, .blue, .cyan, .purple, .brown, .black
    ]
    // 프로필 이미지 (유저 프로필 이미지가 없을 때)
    let profileImages: [String] = [
        "bear", "dragon", "elephant", "lion", "owl", "rabbit", "seahorse", "snake", "wolf"
    ]
    // 프로필 이름 (테스트용)
    let profileNames: [String] = [
        "임병구", "김상규", "나예슬", "남현정", "선아라", "이재승", "윤해수", "장여훈", "정한두"
    ]
    // 맵뷰 카메라 세팅
    @State private var region: MapCameraPosition = .userLocation(fallback: .automatic)
    // 현황 뷰 띄우기
    @State private var isShowingFriendSheet: Bool = false
    // 길 안내 토글
    @State private var isShowingRoute: Bool = false
    // 사용확인필요
    @State private var mapSelection: MKMapItem?
    // 길 안내 프로퍼티
    @State private var getDirections = false
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    // Location배열 패치를 위한 id배열
    @State var locationIdArray: [String] = ["CEBCB8FA-2759-4EE5-827F-5C31CC08F148", "F3A8AE7F-2820-4D39-8768-80B8B89AB5A7", "CE5EF632-978E-4EBD-83A4-71D21DBCD2E2"]
    
    // Marker는 시각적, Anntation은 정보 포함
    var body: some View {
        NavigationStack {
            VStack {
                Map(position: $region, selection: $mapSelection) {
                    // 현재 위치 표시
                    UserAnnotation(anchor: .center)
                    // 도착 위치 표시
                    Annotation("약속 위치", coordinate: destinationCoordinate, anchor: .bottom) {
                        Image(systemName: "figure.2.arms.open")
                            .foregroundColor(.brown)
                    }
                    // 친구 위치 표시
                    ForEach(friendsAnnotation) { annotation in
                        Annotation(profileNames.randomElement() ?? "이름없음", coordinate: annotation.currentCoordinate, anchor: .center) {
                            Image(profileImages.randomElement() ?? "bear")
                                .resizable()
                                .frame(width: 25, height: 25) // 크기 조절
                                .aspectRatio(contentMode: .fill)
                        }
                    }
                    // 경로 그리기
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(Color(strokeColors.randomElement() ?? .blue), lineWidth: 6)
                    }
                    
                }
                .mapControls {
                    MapCompass()
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                // 맵뷰 탭바같은거
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        Menu {
                            Button {
                                withAnimation(.easeIn(duration: 1)) {
                                    region = .region(MKCoordinateRegion(center: destinationCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                                }
                                // 맵 화면을 약속 위치로 움직여주는 버튼 기능
                            } label: {
                                Text("약속 위치")
                            }
                            Toggle("길 안내", isOn: $isShowingRoute)
                        } label: {
                            Image(systemName: "lineweight")
                                .padding(15)
                                .background(.white)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                                .padding(4)
                        }
                    }
                }
                Button {
                    isShowingFriendSheet = true
                } label: {
                    Text("친구현황보기")
                        .font(.title3)
                        .padding()
                }
            }
            .sheet(isPresented: $isShowingFriendSheet) {
                FriendsMapSubView(isShowingFriendSheet: $isShowingFriendSheet, friendsAnnotation: friendsAnnotation, region: $region, myLocation: $myLocation, destinationCoordinate: destinationCoordinate, promiseTitle: "약속가져와야돼요", remaningPromiseTime: "약속에서 계산?")
                    .presentationDetents([.medium, .large])
                    .presentationCompactAdaptation(.none)
            }
        }
        .task {
            // 테스트용
            myLocation = Location(participantId: "k6VioFa0mfTc1oRIUzMs9dzjHVf1", departureLatitude: 37.547551, departureLongitude: 127.080315, currentLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, currentLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
            // 자신의 로케이션 데이터 보내기
            LocationStore.addLocationData(location: myLocation)
            firstUploadLocation = false
            // 패치해주는 코드
            do {
                try await locationStore.fetchData(locationIdArray: locationIdArray)
                friendsAnnotation = locationStore.locationDatas
                print("파베 패치 완료")
            } catch {
                print("파이어베이스 에러")
            }
        }
        .onAppear {
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                print("5초 지남")
                locationStore.updateCurrentLocation(locationId: myLocation.id, newLatitude: myLocation.currentLatitude, newLongtitude: myLocation.currentLongitude)
                
                Task {
                    do {
                        try await locationStore.fetchData(locationIdArray: locationIdArray)
                        friendsAnnotation = locationStore.locationDatas
                        print("파베 패치 완료")
                        
                        // 테스트를 위해 친구 위도값 계속 변경
                        if friendsAnnotation.isEmpty {
                            print("friendsAnnotation이 없습니다.")
                        } else {
                            friendsAnnotation[0].currentLatitude -= 0.001
                            locationStore.updateCurrentLocation(locationId: friendsAnnotation[0].id, newLatitude: friendsAnnotation[0].currentLatitude, newLongtitude: friendsAnnotation[0].currentLongitude)
                        }
                    } catch {
                        print("파이어베이스 에러: \(error)")
                    }
                }
            }
            RunLoop.current.add(timer, forMode: .default)
        }
        .onChange(of: isShowingRoute) {
            if isShowingRoute {
                fetchRoute(startCoordinate: CLLocationCoordinate2D(latitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, longitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0), destinationCoordinate: destinationCoordinate)
            } else {
                route = nil
            }
        }
    }
}

#Preview {
    FriendsMapView()
}

extension FriendsMapView {
    func fetchRoute(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: startCoordinate))
        request.destination = MKMapItem(placemark: .init(coordinate: destinationCoordinate))
        
        Task {
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = MKMapItem(placemark: .init(coordinate: destinationCoordinate))
            
            withAnimation(.snappy) {
                routeDisplaying = true
                
                if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                    region = .rect(rect)
                }
            }
        }
    }
}
