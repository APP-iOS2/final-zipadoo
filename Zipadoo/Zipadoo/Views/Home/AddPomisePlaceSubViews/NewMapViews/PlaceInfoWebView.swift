//
//  PlaceInfoWebView.swift
//  Zipadoo
//
//  Created by 김상규 on 10/3/23.
//

import SwiftUI
import SafariServices

// MARK: - 장소에 대한 웹뷰
/// 검색 이후 나타난 리스트에서 ( i ) 버튼을 누르면 자세한 정보가 담긴 웹을 시트로 띄우기 위한 웹뷰
struct PlaceInfoWebView: UIViewControllerRepresentable {
    var urlString: String
    
    func makeUIViewController(context: Context) -> some UIViewController {
        
        let safariViewController = SFSafariViewController(url: URL(string: urlString)!)
        
        return safariViewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}

#Preview {
    PlaceInfoWebView(urlString: "https://naver.com")
}
