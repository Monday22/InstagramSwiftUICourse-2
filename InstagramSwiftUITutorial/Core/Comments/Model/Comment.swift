//
//  Comment.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/1/21.
//

import FirebaseFirestoreSwift
import Firebase

struct Comment: Identifiable, Codable {
    @DocumentID var commentId: String?
    let postOwnerUid: String
    let commentText: String
    let postId: String
    let timestamp: Timestamp
    let commentOwnerUid: String
    
    var id: String {
        return commentId ?? NSUUID().uuidString
    }
    
    var user: User?
}
