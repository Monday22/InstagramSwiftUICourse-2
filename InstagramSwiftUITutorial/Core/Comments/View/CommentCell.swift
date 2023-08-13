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
            CircularProfileImageView(user: comment.user, size: .xSmall)
            
            Text(comment.user?.username ?? "").font(.system(size: 14, weight: .semibold)) +
                Text(" \(comment.commentText)").font(.system(size: 14))
            
            Spacer()
            
            Text(" \(comment.timestampString ?? "")")
                .foregroundColor(.gray)
                .font(.system(size: 12))
        }.padding(.horizontal)
    }
}
