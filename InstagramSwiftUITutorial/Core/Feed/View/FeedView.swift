//
//  FeedView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct FeedView: View {
    @StateObject var viewModel = FeedViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 32) {
                    ForEach(viewModel.posts) { post in
                        FeedCell(viewModel: FeedCellViewModel(post: post))
                    }
                }
                .padding(.top)
            }
            .navigationTitle("Feed")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem {
                    
                }
            }
        }
    }
}

struct FeedView_Previews: PreviewProvider {
    static var previews: some View {
        FeedView()
    }
}
