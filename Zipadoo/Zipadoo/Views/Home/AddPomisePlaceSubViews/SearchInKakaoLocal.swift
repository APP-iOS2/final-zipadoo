//
//  SearchInKakaoLocal.swift
//  Zipadoo
//
//  Created by 김상규 on 10/1/23.
//

import SwiftUI
import MapKit
import Alamofire

struct MetaInfo: Codable {
    let total_count: Int
    let pageable_count: Int
    let is_end: Bool
    let same_name: SameNameInfo
}

struct SameNameInfo: Codable {
    let region: [String]
    let keyword: String
    let selected_region: String
}

struct KakaoLocalData: Identifiable, Codable {
    var id = UUID().uuidString
    let place_name: String
    let address_name: String
    let road_address_name: String
    let x: String
    let y: String
    let phone: String
    let category_name: String
    let category_group_name: String
    let place_url: String
}

class SearchOfKakaoLocal: ObservableObject {
    static let sharedInstance = SearchOfKakaoLocal()
    @Published var metaInfo: MetaInfo?
    @Published var searchKakaoLocalDatas: [KakaoLocalData] = []
    
    private init() {}
    
    func searchKLPlace(keyword: String) {
        
        let headers: HTTPHeaders = [
            "Authorization": "KakaoAK 191dedb3f0609fe5aab6a6dae502cee1"
        ]
        
        let parameters: Parameters = [
            "query": keyword
        ]
        
        func fetchData() {
            searchKakaoLocalDatas = []
            AF.request("https://dapi.kakao.com/v2/local/search/keyword.json", method: .get, parameters: parameters, headers: headers)
                .validate()
                .responseJSON(completionHandler: { response in
                    switch response.result {
                    case .success(let value):
                        if let json = value as? [String:Any],
                           let documents = json["documents"] as? [[String : Any]],
                           let meta = json["meta"] as? [String : Any],
                           let metaInfoData = try? JSONSerialization.data(withJSONObject: meta),
                           let metaInfo = try? JSONDecoder().decode(MetaInfo.self, from: metaInfoData) {
                            self.metaInfo = metaInfo
                            
                            for item in documents {
                                if let id = item["id"] as? String,
                                   let placeName = item["place_name"] as? String,
                                   let addressName = item["address_name"] as? String,
                                   let roadAdressName = item["road_address_name"] as? String,
                                   let phone = item["phone"] as? String,
                                   let x = item["x"] as? String,
                                   let y = item["y"] as? String,
                                   let categoryName = item["category_name"] as? String,
                                   let categoryGroupName = item["category_group_name"] as? String,
                                   let placeUrl = item["place_url"] as? String {
                                    self.searchKakaoLocalDatas.append(KakaoLocalData(id: id, place_name: placeName, address_name: addressName, road_address_name: roadAdressName, x: x, y: y, phone: phone, category_name: categoryName, category_group_name: categoryGroupName, place_url: placeUrl))
                                }
                            }
                        } else {
                            print("불러오기 실패")
                        }
                        print("")
                        print("불러오기 완료")
                        
                    case .failure(let error):
                        print("Error: \(error)")
                    }
                    
                })
        }
        fetchData()
    }
}

