//
//  ProfileActionButtonView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI

struct ProfileActionButtonView: View {
    @ObservedObject var viewModel: ProfileViewModel
    var isFollowed: Bool { return viewModel.user.isFollowed ?? false }
    @State var showEditProfile = false
    
    var body: some View {
        VStack {
            if viewModel.user.isCurrentUser {
                Button(action: { showEditProfile.toggle() }, label: {
                    Text("Edit Profile")
                        .font(.system(size: 14, weight: .semibold))
                        .frame(width: 360, height: 32)
                        .foregroundColor(Color.theme.systemBackground)
                        .overlay(
                            RoundedRectangle(cornerRadius: 6)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                }).fullScreenCover(isPresented: $showEditProfile) {
                    EditProfileView(user: $viewModel.user)
                }
            } else {
                VStack {
                    HStack {
                        Button(action: { isFollowed ? viewModel.unfollow() : viewModel.follow() }, label: {
                            Text(isFollowed ? "Following" : "Follow")
                                .font(.system(size: 14, weight: .semibold))
                                .frame(width: 360, height: 32)
                                .foregroundColor(isFollowed ? .black : .white)
                                .background(isFollowed ? Color.white : Color.blue)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 6)
                                        .stroke(Color.gray, lineWidth: isFollowed ? 1 : 0)
                                )
                        }).cornerRadius(6)
                        
//                        NavigationLink(value: viewModel.user) {
//                            Text("Message")
//                                .font(.system(size: 14, weight: .semibold))
//                                .frame(width: 172, height: 32)
//                                .foregroundColor(Color.theme.systemBackground)
//                                .overlay(
//                                    RoundedRectangle(cornerRadius: 6)
//                                        .stroke(Color.gray, lineWidth: 1)
//                                )
//                        }
                    }
                }
            }
            
            Divider()
                .padding(.top, 4)
        }
    }
}

struct ProfileActionButtonView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileActionButtonView(viewModel: ProfileViewModel(user: dev.user))
    }
}
