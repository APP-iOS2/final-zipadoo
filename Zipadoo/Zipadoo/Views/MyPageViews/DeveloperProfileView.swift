//
//  DeveloperProfile.swift
//  Zipadoo
//
//  Created by 장여훈 on 10/16/23.
//

import SwiftUI

struct TeamMember {
    let githubUsername: String
    let githubProfilePictureURL: URL?
}

struct DeveloperProfileView: View {
    let teamMembers: [TeamMember] = [
        TeamMember(githubUsername: "9oos", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/133959623?v=4")),
        TeamMember(githubUsername: "skkim125", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/134041539?v=4")),
        TeamMember(githubUsername: "ffv1104", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/134471526?v=4")),
        TeamMember(githubUsername: "nhyeonjeong", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/102401977?v=4")),
        TeamMember(githubUsername: "SunAra25", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/52594310?v=4")),
        TeamMember(githubUsername: "Haesus", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/111691629?v=4")),
        TeamMember(githubUsername: "JASONLEE-hub", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/81094267?v=4")),
        TeamMember(githubUsername: "jangyeohoon", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/76779331?v=4")),
        TeamMember(githubUsername: "B-SSandoo", githubProfilePictureURL: URL(string: "https://avatars.githubusercontent.com/u/136683189?v=4"))
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
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else if profile.error != nil {
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .frame(width: 40, height: 40)
                                    .clipShape(Circle())
                            } else {
                                ProgressView()
                                    .frame(width: 40, height: 40)
                            }
                        }
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
