//
//  CommentsView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/1/21.
//

import SwiftUI

struct CommentsView: View {
    @State private var commentText = ""
    @StateObject var viewModel: CommentViewModel
    
    init(post: Post) {
        self._viewModel = StateObject(wrappedValue: CommentViewModel(post: post))
    }
    
    var body: some View {
        VStack {
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 24) {
                    ForEach(viewModel.comments) { comment in
                        CommentCell(comment: comment)
                    }
                }
            }.padding(.top)
            
            CustomInputView(inputText: $commentText, placeholder: "Comment...", action: uploadComment)
        }
        .navigationTitle("Comments")
        .toolbar(.hidden, for: .tabBar)
    }
    
    func uploadComment() {
        Task {
            await viewModel.uploadComment(commentText: commentText)
            commentText = ""
        }
    }
}