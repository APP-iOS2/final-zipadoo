//
//  LottieView.swift
//  Zipadoo
//
//  Created by 남현정 on 2023/10/20.
//

import SwiftUI
import Lottie
import UIKit

struct LottieView: UIViewRepresentable {
//    var filename: String
    var url: URL
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let animationView = LottieAnimationView()
//        animationView.animation = LottieAnimation.named(filename)
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
//        animationView.play() // 애니메이션 재생
        
//        LottieAnimation.loadedFrom(url: url, closure: { animation in
//            animationView.animation = animation
//            animationView.play()
//        }, animationCache: DefaultAnimationCache.sharedCache)
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            animationView.heightAnchor.constraint(equalTo: view.heightAnchor),
            animationView.widthAnchor.constraint(equalTo: view.widthAnchor)
        ])
        
        return view
    }
    func updateUIView(_ uiView: UIViewType, context: Context) {
        // no code
    }
}
