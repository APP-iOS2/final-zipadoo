//
//  ContentViewModel.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/09/27.
//

import Combine // Set<AnyCancellable>()에 필요
import Firebase
import Foundation

final class ContentViewModel: ObservableObject {
    
    private let auth = AuthStore.shared
    private var cancellables = Set<AnyCancellable>()
    
    /// 파베에 저장된 토큰
    @Published var userSession: FirebaseAuth.User?
    
    /// 현재 사용자
    @Published var currentUser: User?
    
    init() {
        setupSubscribers()
    }
    
    func setupSubscribers() {
        auth.$userSession.sink { [weak self] userSession in
            self?.userSession = userSession
        }
        .store(in: &cancellables)
        
        auth.$currentUser.sink { [weak self] currentUser in
            self?.currentUser = currentUser
        }
        .store(in: &cancellables)
    }
}
