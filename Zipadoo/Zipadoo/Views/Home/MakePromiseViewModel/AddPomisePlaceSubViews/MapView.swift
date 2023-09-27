//
//  MapView.swift
//  Zipadoo
//
//  Created by 김상규 on 2023/09/25.
//

import SwiftUI
import MapKit
import CoreLocation

struct MapView: View {
    @Namespace var mapScope
    @Environment(\.dismiss) private var dismiss
    
    var addLocationStore: AddLocationStore = AddLocationStore()
    
    @State private var region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780),
        span: MKCoordinateSpan(latitudeDelta: 0.009, longitudeDelta: 0.009))
    @State private var addLocation = AddLocation(coordinate: CLLocationCoordinate2D(latitude: 37.5665, longitude: 126.9780))
    @State var address = ""
    @State private var selectedPlace: Bool = false
    
    @Binding var mapViewSheet: Bool
    @Binding var promiseLocation: PromiseLocation
    
    let locationManager = CLLocationManager()
    
    var body: some View {
        NavigationStack {
            ZStack {
                Map(coordinateRegion: $region, showsUserLocation: true, annotationItems: [addLocation]) { location in
                    MapAnnotation(coordinate: location.coordinate) {
                        PlaceMarkerCell()
                    }
                }
                
                VStack {
                    HStack {
                        Spacer()
                        
                        VStack {
                            Button {
                                if let userLocation = locationManager.location?.coordinate {
                                    withAnimation {
                                        region.center = userLocation
                                        makingKorAddress()
                                    }
                                }
                            } label: {
                                Image(systemName: "location.fill")
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .bold()
                                    .padding()
                                    .background(Color.white)
                                    .clipShape(Circle())
                                    .shadow(color: .black, radius: 3)
                            }
                            Spacer()
                        }
                        .safeAreaPadding(.top, 50)
                        .padding()
                    }
                    
                    Spacer()
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 10)
                            .foregroundStyle(.white)
                            .frame(width: 340, height: /*@START_MENU_TOKEN@*/100/*@END_MENU_TOKEN@*/)
                            .shadow(radius: 15)
                            .overlay {
                                VStack {
                                    Spacer()
                                    
                                    if selectedPlace == true {
                                        Text(address)
                                            .font(.title3)
                                    } else {
                                        Text("약속 장소를 선택해 주세요")
                                            .font(.title3)
                                            .foregroundStyle(.gray)
                                    }
                                    
                                    Spacer()
                                    
                                    Button {
                                        //                                        mapViewSheet.toggle()
                                        promiseLocation = addLocationStore.setLocation(
                                            latitude: addLocation.coordinate.latitude,
                                            longitude: addLocation.coordinate.longitude,
                                            address: address)
                                        dismiss()
                                    } label: {
                                        Text("장소 선택하기")
                                            .frame(width: 290, height: 20)
                                    }
                                    .buttonStyle(.borderedProminent)
                                    .buttonBorderShape(.roundedRectangle(radius: 5))
                                    .padding(.bottom, 10)
                                }
                            }
                    }
                }
                .padding(.bottom, 70)
            }
            .ignoresSafeArea(edges: .all)
            //            .mapControls {
            //                VStack {
            //                    MapPitchToggle(scope: mapScope)
            //                        .mapControlVisibility(.visible)
            //                    MapCompass(scope: mapScope)
            //                        .mapControlVisibility(.visible)
            //                }
            //                .padding(.trailing, 10)
            //                .buttonBorderShape(.circle)
            //            }
            .onAppear {
                locationManager.requestWhenInUseAuthorization()
            }
            .onTapGesture {
                makingKorAddress()
                selectedPlace = true
            }
        }
    }
    
    func makingKorAddress() {
        let touchPoint = region.center
        addLocation = AddLocation(coordinate: touchPoint)
        let geocoder = CLGeocoder()
        geocoder.reverseGeocodeLocation(CLLocation(
            latitude: touchPoint.latitude,
            longitude: touchPoint.longitude),
                                        preferredLocale: Locale(identifier: "ko_KR")) { placemarks, error in
            if let placemark = placemarks?.first {
                address = [ placemark.locality,
                            placemark.thoroughfare,
                            placemark.subThoroughfare].compactMap { $0 }.joined(separator: " ")
            }
        }
    }
}

#Preview {
    MapView(mapViewSheet: .constant(true), promiseLocation: .constant(PromiseLocation(latitude: 37.5665, longitude: 126.9780, address: "서울시청")))
}
