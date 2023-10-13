//
//  AlertView+.swift
//  Zipadoo
//
//  Created by 아라 on 10/13/23.
//

import SwiftUI

extension View {
    /// 약속 장소 도착시 띄워주는 Alert
    func arrivalMessageAlert (isPresented: Binding<Bool>, name: String, profileImgString: String, rank: Int, arrivarDifference: Double, potato: Int) -> some View {
      return modifier(ArrivalMessagingModifier(isPresented: isPresented, name: name, profileImgString: profileImgString, rank: rank, arrivarDifference: arrivarDifference, potato: potato)
        )
    }
}
