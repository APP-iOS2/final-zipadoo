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
    @EnvironmentObject var alertStore: AlertStore
    // 프로필 이미지 (유저 프로필 이미지가 없을 때)
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
    // 받아야할 값들
    var promise: Promise
    // 파베 갱신 시간
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    // 토스트 bool값
    @State private var isArrived: Bool = false
    // 도착 위치 버튼 bool값
    @State private var moveDestination: Bool = false
    // 도착 위치 반경
    let arrivalCheckRadius: Double = 150
    
    // Marker는 시각적, Anntation은 정보 포함
    var body: some View {
        NavigationStack {
            VStack {
                Map(position: $region, selection: $mapSelection) {
                    // 현재 위치 표시
                    UserAnnotation(anchor: .center)
                    // 도착 위치 표시
                    Annotation("약속 위치", coordinate: promise.coordinate, anchor: .bottom) {
                        Image(systemName: "mappin")
                            .font(.title)
                            .foregroundColor(.blue)
                    }
                    // 도착 반경 표시
                    MapCircle(center: promise.coordinate, radius: arrivalCheckRadius)
                        .foregroundStyle(.blue.opacity(0.3))
                        .stroke(.blue, lineWidth: 2)
                    // 친구 위치 표시
                    ForEach(locationStore.locationParticipantDatas.filter {
                        $0.location.participantId != AuthStore.shared.currentUser?.id ?? ""
                    }) { annotation in
                        Annotation(annotation.nickname, coordinate: annotation.location.currentCoordinate, anchor: .center) {
                            /*AsyncImage(url: URL(string: annotation.imageString), content: { image in
                             image
                             .resizable()
                             .frame(width: 25, height: 25) // 크기 조절
                             .aspectRatio(contentMode: .fill)
                             }) {
                             Image(.dothez)
                             .resizable()
                             .frame(width: 25, height: 25) // 크기 조절
                             .aspectRatio(contentMode: .fill)
                             }*/
                            Image(annotation.moleImageString)
                                .resizable()
                                .frame(width: 25, height: 25) // 크기 조절
                                .aspectRatio(contentMode: .fill)
                                .overlay(
                                    Circle().stroke(Color.white, lineWidth: 2))
                                .shadow(radius: 10)
                        }
                    }
                    // 경로 그리기
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(Color(.blue), lineWidth: 6)
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
                        /* Menu {
                            Button {
                                withAnimation(.easeIn(duration: 1)) {
                                    region = .region(MKCoordinateRegion(center: promise.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
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
                        } */
                        Button {
                            withAnimation(.easeIn(duration: 1)) {
                                region = .region(MKCoordinateRegion(center: promise.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                            }
                            moveDestination = true
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                moveDestination = false
                            }
                            // 맵 화면을 약속 위치로 움직여주는 버튼 기능
                        } label: {
                            if moveDestination {
                                Image(systemName: "flag.fill")
                                    .foregroundColor(.blue)
                                    .frame(width: 45, height: 45)
                                    .background(.white)
                                    .clipShape(RoundedRectangle(cornerRadius: 9))
                                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                    .shadow(color: .gray.opacity(0.3), radius: 5)
                            } else {
                                withAnimation(.linear(duration: 1)) {
                                    Image(systemName: "flag")
                                        .foregroundColor(.blue)
                                        .frame(width: 45, height: 45)
                                        .background(.white)
                                        .clipShape(RoundedRectangle(cornerRadius: 9))
                                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 5))
                                        .shadow(color: .gray.opacity(0.3), radius: 5)
                                }
                            }
                        }
                        Button {
                            isShowingRoute.toggle()
                        } label: {
                            Text("Route")
                                .font(.caption)
                                .bold()
                                .foregroundColor(isShowingRoute ? .white : .blue)
                                .frame(width: 45, height: 45)
                                .background(isShowingRoute ? .blue.opacity(0.8) : .white)
                                .clipShape(RoundedRectangle(cornerRadius: 9))
                                .padding(EdgeInsets(top: 1, leading: 5, bottom: 0, trailing: 5))
                                .shadow(color: .gray.opacity(0.3), radius: 5)
                        }
                        // 토글 버튼 ON/OFF 간단 버튼으로 변경할까? 원에 글 색만 바뀌게
                    }
                }
                .overlay(alignment: .bottom) {
                    Button {
                        isShowingFriendSheet = true
                    } label: {
                        Text("친구 현황 보기")
                            .font(.headline)
                            .bold()
                            .foregroundStyle(.white)
                            .padding(EdgeInsets(top: 9, leading: 20, bottom: 9, trailing: 20))
                            .background(Capsule().fill(.blue).stroke(Color.white, lineWidth: 2))
                            .padding()
                            .shadow(color: .gray.opacity(0.3), radius: 5)
                    }
                }
            }
            .sheet(isPresented: $isShowingFriendSheet) {
                FriendsMapSubView(locationStore: locationStore, isShowingFriendSheet: $isShowingFriendSheet, region: $region, destinationCoordinate: promise.coordinate, promise: promise)
                    .presentationDetents([.medium, .large])
                    .presentationCompactAdaptation(.none)
            }
        }
        .onAppear {
            // 5초마다 반복, 전역에서 사라지지 않고 실행됨
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                print("나는 맵에서 만들어짐! ! 5초 지남")
                // 위치 도착 위치 비교
                if !isArrived {
                    // 도착 체크 함수
                    isArrived = didYouArrive(currentCoordinate:
                                                CLLocation( latitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0,
                                                    longitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0),
                                             arrivalCoordinate: CLLocation(latitude: promise.latitude, longitude: promise.longitude), effetiveDistance: arrivalCheckRadius)
                    // 위치 업데이트
                    locationStore.updateCurrentLocation(locationId: locationStore.myLocation.id, newLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, newLongtitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
                } else { // 도착했을때
                    // 한번만 실행되고 그 뒤에는 실행되면 안됨, 그런데 5초 루프문에 넣어야지 백그라운드에서 실행가능
                    if locationStore.myLocation.arriveTime == 0 {
                        // 도착시간 저장
                        var rank = locationStore.calculateRank()
                        locationStore.myLocation.arriveTime = Date().timeIntervalSince1970
                        locationStore.updateArriveTime(locationId: locationStore.myLocation.id, arriveTime: locationStore.myLocation.arriveTime, rank: rank)
                        // 도착 알림 실행
                        alertStore.arrivalMsgAlert = ArrivalMsgModel(name: AuthStore.shared.currentUser?.nickName ?? "이름없음", profileImgString: AuthStore.shared.currentUser?.profileImageString ?? "doo1", rank: rank, arrivarDifference: promise.promiseDate - locationStore.myLocation.arriveTime, potato: 0)
                        alertStore.isPresentedArrival.toggle()
                    }
                }
                // 유저들 위치 패치
                Task {
                    do {
                        try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                    } catch {
                        print("파이어베이스 에러")
                    }
                }
            }
            RunLoop.current.add(timer, forMode: .default)
                
            print("promise 데이터 확인 : \(promise)")
            locationStore.updateCurrentLocation(locationId: locationStore.myLocation.id, newLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, newLongtitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
            Task {
                do {
                    try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                } catch {
                    print("파이어베이스 에러")
                }
            }
        }
        .task { // 초기화 코드
            // myLocation 초기화
            locationStore.myLocation = Location(participantId: AuthStore.shared.currentUser?.id ?? "", departureLatitude: 0, departureLongitude: 0, currentLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, currentLongitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
            // 패치해주는 코드
            do {
                try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                print("파베 패치 완료")
                print("나의 위치데이터는 : \(locationStore.myLocation)")
            } catch {
                print("파이어베이스 에러")
            }
        }
        /* .onReceive(timer, perform: { _ in
            print("5초 지남")
            // 위치 도착 위치 비교
            if !isArrived {
                isArrived = didYouArrive(currentCoordinate:
                                            CLLocation( latitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0,
                                                longitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0),
                                         arrivalCoordinate: CLLocation(latitude: promise.latitude, longitude: promise.longitude), effetiveDistance: arrivalCheckRadius)
                // 위치 업데이트
                locationStore.updateCurrentLocation(locationId: locationStore.myLocation.id, newLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, newLongtitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
            }
            // 유저들 위치 패치
            Task {
                do {
                    try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                } catch {
                    print("파이어베이스 에러")
                }
            }
        }) */
        .onChange(of: isShowingRoute) {
            if isShowingRoute {
                fetchRoute(startCoordinate: CLLocationCoordinate2D(latitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, longitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0), destinationCoordinate: promise.coordinate)
                print("루트 실행 후 gpsStore값은 : \(String(describing: gpsStore.lastSeenLocation?.coordinate))")
            } else {
                route = nil
            }
        }
        // 도착할때 실행
        /*.onChange(of: isArrived) {
            // 도착시간 저장
            locationStore.myLocation.arriveTime = Date().timeIntervalSince1970
            locationStore.updateArriveTime(locationId: locationStore.myLocation.id, newValue: locationStore.myLocation.arriveTime)
            // 도착 알림 실행
            alertStore.arrivalMsgAlert = ArrivalMsgModel(name: AuthStore.shared.currentUser?.nickName ?? "이름없음", profileImgString: AuthStore.shared.currentUser?.profileImageString ?? "doo1", rank: locationStore.calculateRank(), arrivarDifference: promise.promiseDate - locationStore.myLocation.arriveTime, potato: 0)
            alertStore.isPresentedArrival.toggle()
        } */
    }
}

#Preview {
    FriendsMapView(promise: Promise(id: "", makingUserID: "", promiseTitle: "", promiseDate: 0, destination: "", address: "", latitude: 37.2325443502025, longitude: 127.21076196328842, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10))
        .environmentObject(AlertStore())
}

extension FriendsMapView {
    // 나의 위치 거리를 받아서, 도착지점 원과 비교하여 Bool값으로 출력
    // 도착 Bool값이 true일때, 흐음... 도착시간 저장 -> 토스트 띄움
    func didYouArrive(currentCoordinate: CLLocation, arrivalCoordinate: CLLocation, effetiveDistance: Double) -> Bool {
        return currentCoordinate.distance(from: arrivalCoordinate) < effetiveDistance
    }
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
