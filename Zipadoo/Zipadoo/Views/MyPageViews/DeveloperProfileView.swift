//
//  DeveloperProfile.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/16/23.
//

import SwiftUI

struct Developer {
    let githubUsername: String
    let githubProfilePictureURL: URL?
}

struct DeveloperProfileView: View {
    let teamMembers: [Developer] = [
        Developer(githubUsername: "9oos", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/133959623?v=4")),
        Developer(githubUsername: "skkim125", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/134041539?v=4")),
        Developer(githubUsername: "ffv1104", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/134471526?v=4")),
        Developer(githubUsername: "nhyeonjeong", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/102401977?v=4")),
        Developer(githubUsername: "SunAra25", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/52594310?v=4")),
        Developer(githubUsername: "Haesus", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/111691629?v=4")),
        Developer(githubUsername: "JASONLEE-hub", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/81094267?v=4")),
        Developer(githubUsername: "jangyeohoon", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/76779331?v=4")),
        Developer(githubUsername: "B-SSandoo", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/136683189?v=4"))
    ]
    
    var body: some View {
        List {
            ForEach(teamMembers, id: \.githubUsername) { member in
                HStack {
                    if let imageURL = member.githubProfilePictureURL {
                        AsyncImage(url: imageURL) { profile in
                            if let image = profile.image {
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .clipShape(Circle())
                            } else if profile.error != nil {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .clipShape(Circle())
                            } else {
                                ProgressView()
                            }
                        }
                        .frame(width: 40, height: 40)
                    } else {
                        Image(systemName: "person.fill")
                            .resizable()
                            .frame(width: 40, height: 40)
                            .clipShape(Circle())
                    }
                    VStack(alignment: .leading) {
                        Text(member.githubUsername)
                            .font(.subheadline)
                    }
                }
            }
        }
        .listStyle(.plain)
        .navigationTitle("Team Zipadoo")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    DeveloperProfileView()
}
