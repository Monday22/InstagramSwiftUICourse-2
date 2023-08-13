//
//  CommentCell.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/1/21.
//

import SwiftUI
import Kingfisher

struct CommentCell: View {
    let comment: Comment
    
    var body: some View {
        HStack {
            CircularProfileImageView(user: comment.user, size: .xxSmall)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 2) {
                    Text(comment.user?.username ?? "")
                        .fontWeight(.semibold)
                    
                    Text(comment.timestampString ?? "")
                        .foregroundColor(.gray)
                }
                
                Text(comment.commentText)
            }
            .font(.caption)
        }.padding(.horizontal)
    }
}
