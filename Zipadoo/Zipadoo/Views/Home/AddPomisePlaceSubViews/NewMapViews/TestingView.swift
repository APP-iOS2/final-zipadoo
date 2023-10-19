//
//  TestingView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/9/23.
//

//MARK: - 테스트 완료 , 사용하지 않음
//import SwiftUI
//import Alamofire
//
//struct TestingView: View {
//    @State private var xCoordinate = ""
//    @State private var yCoordinate = ""
//    @State private var buildingName = ""
//    @State private var addressName = ""
//
//    var body: some View {
//        VStack {
//            TextField("X 좌표", text: $xCoordinate)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            TextField("Y 좌표", text: $yCoordinate)
//                .textFieldStyle(RoundedBorderTextFieldStyle())
//                .padding()
//            
//            Button("주소 조회") {
//                getAddressInfo()
//            }
//            .padding()
//            
//            Text("주소: \(addressName)")
//                .padding()
//            
//            Text("건물 이름: \(buildingName)")
//                .padding()
//        }
//    }
//
//    func getAddressInfo() {
//        let headers: HTTPHeaders = [
//            "Authorization": "KakaoAK 191dedb3f0609fe5aab6a6dae502cee1"
//        ]
//
//        AF.request("https://dapi.kakao.com/v2/local/geo/coord2address.json?x=\(xCoordinate)&y=\(yCoordinate)", method: .get, headers: headers).validate().responseJSON { response in
//            switch response.result {
//            case .success(let value):
//                if let json = value as? [String: Any],
//                   let documents = json["documents"] as? [[String: Any]],
//                   let firstDocument = documents.first,
//                   let addressInfo = firstDocument["address"] as? [String: Any],
//                   let roadAddressInfo = firstDocument["road_address"] as? [String: Any],
//                   let addressName = addressInfo["address_name"] as? String,
//                   let buildingName = roadAddressInfo["building_name"] as? String {
//                    print("Building Name: \(buildingName)")
//                    print("Address Name: \(addressName)")
//                    self.buildingName = buildingName
//                    self.addressName = addressName
//                } else {
//                    print("JSON 파일에 정보가 없습니다.")
//                    self.addressName = "주소를 찾을 수 없습니다."
//                    self.buildingName = "건물 이름을 찾을 수 없습니다."
//                }
//
//            case .failure(let error):
//                print(error)
//                self.addressName = "주소를 찾을 수 없습니다."
//                self.buildingName = "건물 이름을 찾을 수 없습니다."
//            }
//        }
//    }
//}
//
//#Preview {
//    TestingView()
//}
