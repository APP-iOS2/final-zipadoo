//
//  ParticipantInfoView.swift
//  Zipadoo
//
//  Created by 김상규 on 11/15/23.
//

import SwiftUI

struct ParticipantInfoView: View {
    let user: User
    var body: some View {
        VStack {
            Image(user.moleImageString)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 65)
            
            Text(user.nickName)
                .fontWeight(.medium)
        }
        .padding()
    }
}

#Preview {
    ParticipantInfoView(user: User(id: "", name: "hello", nickName: "helloing", phoneNumber: "", profileImageString: "", friendsIdArray: [], friendsIdRequestArray: [], moleImageString: "doo1"))
}
