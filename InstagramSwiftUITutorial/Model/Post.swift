//
//  Post.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/31/20.
//

import FirebaseFirestoreSwift
import Firebase

struct Post: Identifiable, Hashable, Decodable {
    @DocumentID var id: String?
    let ownerUid: String
    let caption: String
    var likes: Int
    let imageUrl: String
    let timestamp: Timestamp
    var user: User?
    
    var didLike: Bool? = false
}
