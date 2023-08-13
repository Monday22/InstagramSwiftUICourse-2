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
    
//    init(user: User, data: [String: Any]) {
//        self.username = user.username
//        self.profileImageUrl = user.profileImageUrl ?? ""
//        self.postOwnerUid = data["postOwnerUid"] as? String ?? ""
//        self.commentText = data["commentText"] as? String ?? ""
//        self.postId = data["postId"] as? String ?? ""
//        self.timestamp = data["timestamp"] as? Timestamp ?? Timestamp()
//        self.commentOwnerUid = data["commentOwnerUid"] as? String ?? ""
//    }
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: timestamp.dateValue(), to: Date()) ?? ""
    }
}
