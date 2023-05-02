//
//  ProfileHeaderView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI
import Kingfisher

struct ProfileHeaderView: View {
    @ObservedObject var viewModel: ProfileViewModel
    
    var body: some View {
        VStack {
            HStack {
                CircularProfileImageView(user: viewModel.user, size: .large)
                    .padding(.leading)
                
                Spacer()
                
                HStack(spacing: 16) {
                    UserStatView(value: viewModel.user.stats?.posts, title: "Posts")
                    
                    NavigationLink(destination: UserListView(config: .followers(viewModel.user.id), searchText: .constant(""))) {
                        UserStatView(value: viewModel.user.stats?.followers, title: "Followers")
                    }
                    
                    NavigationLink(destination: UserListView(config: .following(viewModel.user.id), searchText: .constant("")))  {
                        UserStatView(value: viewModel.user.stats?.following, title: "Following")
                    }
                }
                .padding(.trailing)
            }
            
            VStack(alignment: .leading, spacing: 4) {
                if let fullname = viewModel.user.fullname {
                    Text(fullname)
                        .font(.footnote)
                        .fontWeight(.semibold)
                        .padding(.leading)
                }
                
                if let bio = viewModel.user.bio {
                    Text(bio)
                        .font(.footnote)
                        .padding(.leading)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            
            ProfileActionButtonView(viewModel: viewModel)
                .padding(.top)
        }
    }
}

struct ProfileHeaderView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderView(viewModel: ProfileViewModel(user: dev.user))
    }
}
