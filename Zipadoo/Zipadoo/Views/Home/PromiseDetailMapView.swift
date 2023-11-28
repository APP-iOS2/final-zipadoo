//
//  PromiseDetailMapView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/21.
//

import SwiftUI
import MapKit
import CoreLocation

// MARK: - 친구와 자신의 현황을 표시하는 맵 뷰
struct PromiseDetailMapView: View {
    // 위치 및 GPS 정보 저장용 객체
    @StateObject private var locationStore = LocationStore()
    @StateObject private var gpsStore = GPSStore()
    @EnvironmentObject var alertStore: AlertStore    /// 맵뷰 카메라 세팅
    @State private var region: MapCameraPosition = .userLocation(fallback: .automatic)
    
    /// 현황 뷰 띄우기
    @State private var isShowingFriendSheet: Bool = false
    
    /// 길 안내 토글
    @State private var isShowingRoute: Bool = false
    
    /// 사용자 선택 지점
    @State private var mapSelection: MKMapItem?
    
    /// 길 안내 관련 프로퍼티
    @State private var routeDisplaying = false
    @State private var route: MKRoute?
    @State private var routeDestination: MKMapItem?
    
    /// 약속 정보
    var promise: Promise
    
    /// 파이어베이스 갱신 시간
    let timer = Timer.publish(every: 5, on: .main, in: .common).autoconnect()
    
    /// 도착 여부를 나타내는 불린 값
    @State private var isArrived: Bool = false
    
    /// 도착 위치로 이동하는 버튼 상태
    @State private var moveDestination: Bool = false
    
    /// 도착 위치를 확인할 반경
    let arrivalCheckRadius: Double = 150
    
    /// 프레젠테이션 디텐트 설정
    @State private var detents: PresentationDetent = .medium
    
    var body: some View {
        NavigationStack {
            VStack {
                Map(position: $region, selection: $mapSelection) {
                    
                    // 자신의 현재 위치 표시
                    UserAnnotation(anchor: .center)
                    
                    // 도착지 위치 표시
                    Annotation("약속 위치", coordinate: promise.coordinate, anchor: .bottom) {
                        // 누르면 다시 가운데으로 세팅
                        Button(action: {
                            region = .region(MKCoordinateRegion(center: promise.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                        }, label: {
                            Image(systemName: "mappin")
                                .font(.title)
                                .foregroundColor(.blue)
                        })
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
                            // 누르면 다시 가운데으로 세팅
                            Button {
                                region = .region(MKCoordinateRegion(center: annotation.location.currentCoordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                            } label: {
                                Image(annotation.moleImageString)
                                    .resizable()
                                    .frame(width: 25, height: 25) // 크기 조절
                                    .aspectRatio(contentMode: .fill)
                                    .overlay(
                                        Circle().stroke(Color.white, lineWidth: 2))
                                    .shadow(radius: 10)
                            }
                        }
                    }
                    
                    // 경로 그리기
                    if let route {
                        MapPolyline(route.polyline)
                            .stroke(Color(.blue), lineWidth: 6)
                    }
                }
                .mapControls {
                    /// 맵뷰 컨트롤
                    MapCompass()
                    MapPitchToggle()
                    MapUserLocationButton()
                }
                // 맵뷰 좌측상단 도착지,Route버튼
                .overlay(alignment: .topLeading) {
                    VStack(alignment: .leading) {
                        // 약속 도착지로 이동하는 버튼
                        Button {
                            withAnimation(.easeIn(duration: 1)) {
                                region = .region(MKCoordinateRegion(center: promise.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000))
                            }
                            moveDestination = true
                            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 1) {
                                moveDestination = false
                            }
                        } label: {
                            // 이동 중인 경우와 아닌 경우에 따른 버튼 모양 변경
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
                        
                        // 길 안내 토글 버튼
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
                    }
                }
                // 하단 '친구 현황 보기' 버튼
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
                // 친구 현황 서브뷰 표시
                PromiseDetailMapSubView(locationStore: locationStore, region: $region, destinationCoordinate: promise.coordinate, promise: promise, isShowingFriendSheet: $isShowingFriendSheet, detents: $detents)
                    .presentationDetents([.medium, .large], selection: $detents)
                    .animation(.linear, value: 10)
            }
        }
        .task {
            // 현재 위치 정보 갱신
            locationStore.myLocation.currentLatitude = gpsStore.lastSeenLocation?.coordinate.latitude ?? 0
            locationStore.myLocation.currentLongitude = gpsStore.lastSeenLocation?.coordinate.longitude ?? 0
            
            do {
                // 파이어베이스 데이터 갱신
                try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                print("파베 패치 완료")
                print("나의 위치데이터는 : \(locationStore.myLocation)")
            } catch {
                print("파이어베이스 에러")
            }
        }
        .onAppear {
            // 5초마다 반복, onAppear가 있어야 전역에서 사라지지 않고 실행됨
            let timer = Timer.scheduledTimer(withTimeInterval: 5, repeats: true) { _ in
                print("나는 맵에서 만들어짐! ! 5초 지남")
                if locationStore.myLocation.arriveTime == 0 { // 아직 도착하지 않았으면
                    // 한번만 실행되고 그 뒤에는 실행되면 안됨, 그런데 5초 루프문에 넣어야지 백그라운드에서 실행가능
                    isArrived = didYouArrive(currentCoordinate:
                                                CLLocation( latitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0,
                                                            longitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0),
                                             arrivalCoordinate: CLLocation(latitude: promise.latitude, longitude: promise.longitude), effectiveDistance: arrivalCheckRadius)
                    
                    if isArrived == true {
                        locationStore.myLocation.arriveTime = Date().timeIntervalSince1970
                        let rank = locationStore.calculateRank()
                        locationStore.updateArriveTime(locationId: locationStore.myLocation.id, arriveTime: locationStore.myLocation.arriveTime, rank: rank)
                        // 도착 알림 실행
                        alertStore.arrivalMsgAlert = ArrivalMsgModel(name: AuthStore.shared.currentUser?.nickName ?? "이름없음", profileImgString: AuthStore.shared.currentUser?.profileImageString ?? "doo1", rank: rank, arrivarDifference: promise.promiseDate - locationStore.myLocation.arriveTime, potato: 0)
                        alertStore.isPresentedArrival.toggle()
                    } else {
                        // 위치 업데이트
                        locationStore.updateCurrentLocation(locationId: locationStore.myLocation.id, newLatitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0, newLongtitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0)
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
        .onReceive(timer, perform: { _ in
            print("5초 지남")
            // 유저들 위치 패치
            Task {
                do {
                    try await locationStore.fetchData(locationIdArray: promise.locationIdArray)
                } catch {
                    print("파이어베이스 에러")
                }
            }
        })
        .onChange(of: isShowingRoute) {
            // 길 안내 토글 상태 변화 감지
            if isShowingRoute {
                // 길 안내 시작 시 경로 정보 가져오기
                fetchRoute(
                    startCoordinate: CLLocationCoordinate2D(
                        latitude: gpsStore.lastSeenLocation?.coordinate.latitude ?? 0,
                        longitude: gpsStore.lastSeenLocation?.coordinate.longitude ?? 0
                    ),
                    destinationCoordinate: promise.coordinate
                )
                print("루트 실행 후 gpsStore값은 : \(String(describing: gpsStore.lastSeenLocation?.coordinate))")
            } else {
                // 길 안내 종료 시 경로 초기화
                route = nil
            }
        }
    }
    
    /// 도착 여부를 확인하는 메서드
    /// - Parameters:
    ///   - currentCoordinate: 현재 좌표
    ///   - arrivalCoordinate: 도착 좌표
    ///   - effectiveDistance: 허용 가능한 도착 반경
    /// - Returns: 도착 여부를 나타내는 Bool 값
    func didYouArrive(currentCoordinate: CLLocation, arrivalCoordinate: CLLocation, effectiveDistance: Double) -> Bool {
        return currentCoordinate.distance(from: arrivalCoordinate) < effectiveDistance
    }
    
    /// 경로 정보를 가져오는 메서드
    /// - Parameters:
    ///   - startCoordinate: 출발 좌표
    ///   - destinationCoordinate: 도착 좌표
    func fetchRoute(startCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D) {
        // 경로 요청 객체 생성
        let request = MKDirections.Request()
        request.source = MKMapItem(placemark: .init(coordinate: startCoordinate))
        request.destination = MKMapItem(placemark: .init(coordinate: destinationCoordinate))
        
        Task {
            // 경로 계산
            let result = try? await MKDirections(request: request).calculate()
            route = result?.routes.first
            routeDestination = MKMapItem(placemark: .init(coordinate: destinationCoordinate))
            
            // 애니메이션과 함께 경로 표시 활성화
            withAnimation(.snappy) {
                routeDisplaying = true
                
                // 경로가 있고 표시 중일 경우 지도 영역을 경로에 맞춤
                if let rect = route?.polyline.boundingMapRect, routeDisplaying {
                    region = .rect(rect)
                }
            }
        }
    }
}

#Preview {
    PromiseDetailMapView(promise: Promise(id: "", makingUserID: "", promiseTitle: "사당역 모여라", promiseDate: 1697694660, destination: "", address: "", latitude: 37.47694972793077, longitude: 126.98195644152227, participantIdArray: [], checkDoublePromise: false, locationIdArray: [], penalty: 10))
        .environmentObject(AlertStore())
}
