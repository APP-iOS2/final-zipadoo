//
//  ReceivingLocationTestView.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/10.
//

import SwiftUI
import CoreLocation

struct ReceivingLocationTestView: View {
    @StateObject var gpsStore = GPSStore()
    
    var body: some View {
        switch gpsStore.authorizationStatus {
        case .notDetermined:
            AnyView(RequestLocationView(gpsStore: gpsStore))
        case .restricted:
            ErrorView(errorText: "Location use is restricted.")
        case .denied:
            ErrorView(errorText: "The app does not have location permissions. Please enable them in settings.")
        case .authorizedAlways, .authorizedWhenInUse:
            TrackingView(gpsStore: gpsStore)
        default:
            Text("Unexpected status")
        }
    }
}

#Preview {
    ReceivingLocationTestView()
}

struct RequestLocationView: View {
    @ObservedObject var gpsStore: GPSStore
    
    var body: some View {
        VStack {
            Image(systemName: "location.circle")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
                .foregroundColor(.blue)
            Button {
                gpsStore.requestPermission()
            } label: {
                Label("Allow tracking", systemImage: "location")
            }
            .padding(10)
            .foregroundColor(.white)
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            Text("앱 사용을 위해 위치정보를 받아옵니다.")
                .foregroundStyle(.gray)
                .font(.caption)
            
        }
    }
}

struct ErrorView: View {
    var errorText: String
    
    var body: some View {
        VStack {
            Image(systemName: "xmark.octagon")
                .resizable()
                .frame(width: 100, height: 100, alignment: .center)
            Text(errorText)
        }
        .padding()
        .foregroundColor(.white)
        .background(.red)
    }
}

struct TrackingView: View {
    @ObservedObject var gpsStore: GPSStore
    
    var body: some View {
        VStack {
            HStack {
                Text("Latitude: ")
                Text(String(coordinate?.latitude ?? 0))
            }
            
            HStack {
                Text("Longitude: ")
                Text(String(coordinate?.longitude ?? 0))
            }
            
            HStack {
                Text("Altitude: ")
                Text(String(gpsStore.lastSeenLocation?.altitude ?? 0))
            }
            
            HStack {
                Text("Speed: ")
                Text(String(gpsStore.lastSeenLocation?.speed ?? 0))
            }
            
            HStack {
                Text("Country: ")
                Text(gpsStore.currentPlacemark?.country ?? "")
            }
            
            HStack {
                Text("City: ")
                Text(gpsStore.currentPlacemark?.administrativeArea ?? "")
            }
        }
        .padding()
    }
    
    var coordinate: CLLocationCoordinate2D? {
        gpsStore.lastSeenLocation?.coordinate
    }
}
