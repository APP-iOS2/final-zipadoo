//
//  FirebaseUtil.swift
//  Zipadoo
//
//  Created by 임병구 on 2023/09/25.
//

import Foundation
import Firebase
import FirebaseStorage // 스토리지 개시( 프로필 사진)

class FirebaseUtil: NSObject {
    let auth: Auth
    let storage: Storage // 스토리지 객체 생성
    let firestore: Firestore // 파이어스토어 데이터베이스 사용하기 위해 파이어스토어 인스턴스 멤버 선언
    
    // 스스로 객체생성 - 인스턴스(싱글톤)
    static let shared = FirebaseUtil()
    
    // 객체생성시 자동호출됨
    override init() {
        /*FirebaseApp.configure()*/ // google Plist 파일이 여기로 보내짐. // ZipadooApp.swift 여기에 중복된 코드여서 주석처리 함
        
        self.auth = Auth.auth() // auth 객체를 생성하여 사용 준비됨.
        self.storage = Storage.storage()
        self.firestore = Firestore.firestore()
        
        super.init()
    }
    
}
