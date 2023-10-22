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
    var size: CGFloat
    
    func makeUIView(context: UIViewRepresentableContext<LottieView>) -> UIView {
        let view = UIView()
        let animationView = LottieAnimationView()
        animationView.contentMode = .scaleAspectFit
        animationView.loopMode = .loop
        
        LottieAnimation.loadedFrom(url: url, closure: { animation in
            animationView.animation = animation
            animationView.play()
        }, animationCache: DefaultAnimationCache.sharedCache)
        
        view.addSubview(animationView)
        animationView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            // 받아온 사이즈 적용
            animationView.widthAnchor.constraint(equalToConstant: size),
            animationView.heightAnchor.constraint(equalToConstant: size),
            animationView.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        return view
    }
    
//    func updateUIView(_ uiView: UIViewType, context: Context) {
//        // no code
//        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
//
//            animationView.removeFromSuperview()
//
//        })
//
//    }
    func updateUIView(_ uiView: UIView, context: Context) {
        //
    }
}
