//
//  PromiseDetailMapViewModel.swift
//  Zipadoo
//
//  Created by 이재승 on 2023/10/21.
//

import Foundation

final class PromiseDetailMapViewModel: ObservableObject {
    @Published var progress: [Double] = [ 0, 0, 0 ]
    
    func progressbarAniTrigger() {
        progress = [ 0.3, 0.5, 0.7 ]
    }
}
