//
//  FeedViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/31/20.
//

import SwiftUI

class FeedViewModel: ObservableObject {
    @Published var posts = [Post]()
    
    init() {
        fetchPostsFromFollowedUsers()
    }
    
    func fetchPosts() {
        COLLECTION_POSTS.order(by: "timestamp", descending: true).getDocuments { snapshot, _ in
            guard let documents = snapshot?.documents else { return }
            self.posts = documents.compactMap({ try? $0.data(as: Post.self) })
        }
    }
    
    func fetchPostsFromFollowedUsers() {
        guard let uid = AuthViewModel.shared.userSession?.uid else { return }
        
        COLLECTION_USERS.document(uid).collection("user-feed").getDocuments { snapshot, _ in
            guard let postIDs = snapshot?.documents.map({ $0.documentID }) else { return }
            
            postIDs.forEach { id in
                COLLECTION_POSTS.document(id).getDocument { snapshot, _ in
                    guard let post = try? snapshot?.data(as: Post.self) else { return }
                    self.posts.append(post)
                }
            }
        }
    }
}
