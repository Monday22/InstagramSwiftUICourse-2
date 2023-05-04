//
//  FeedCell.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI
import Kingfisher

struct FeedCell: View {
    @ObservedObject var viewModel: FeedCellViewModel
    
    var didLike: Bool { return viewModel.post.didLike ?? false }
    
    init(viewModel: FeedCellViewModel) {
        self.viewModel = viewModel
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                if let user = viewModel.post.user {
                    CircularProfileImageView(user: user, size: .xSmall)
                        .shadow(color: Color.theme.systemBackground.opacity(0.25), radius: 4)
                    
                    NavigationLink(value: user) {
                        Text(user.username)
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Color.theme.systemBackground)
                    }
                }
            }
            .padding([.leading, .bottom], 8)
            
            KFImage(URL(string: viewModel.post.imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: UIScreen.main.bounds.width, height: 400)
                .clipped()
                .contentShape(Rectangle())
                      
            HStack(spacing: 16) {
                Button(action: {
                    Task { didLike ? try await viewModel.unlike() : try await viewModel.like() }
                }, label: {
                    Image(systemName: didLike ? "heart.fill" : "heart")
                        .resizable()
                        .scaledToFill()
                        .foregroundColor(didLike ? .red : Color.theme.systemBackground)
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                })
                
                NavigationLink(destination: CommentsView(post: viewModel.post)) {
                    Image(systemName: "bubble.right")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                        .foregroundColor(Color.theme.systemBackground)
                }
                
                Button(action: {}, label: {
                    Image(systemName: "paperplane")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 20, height: 20)
                        .font(.system(size: 20))
                        .padding(4)
                        .foregroundColor(Color.theme.systemBackground)
                })
            }
            .zIndex(1)
            .padding(.leading, 4)
            
            NavigationLink(value: SearchViewModelConfig.likes(viewModel.post.id ?? "")) {
                Text(viewModel.likeString)
                    .font(.system(size: 14, weight: .semibold))
                    .padding(.leading, 8)
                    .padding(.bottom, 0.5)
                    .foregroundColor(Color.theme.systemBackground)
            }
            
            HStack {
                Text(viewModel.post.user?.username ?? "").font(.system(size: 14, weight: .semibold)) +
                    Text(" \(viewModel.post.caption)")
                    .font(.system(size: 14))
            }.padding(.horizontal, 8)
            
            Text(viewModel.timestampString)
                .font(.system(size: 14))
                .foregroundColor(.gray)
                .padding(.leading, 8)
                .padding(.top, -2)
        }
    }
}
