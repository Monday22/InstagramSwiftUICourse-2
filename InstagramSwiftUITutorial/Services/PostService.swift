//
//  PostService.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephan Dowless on 4/20/23.
//

import Foundation
import Firebase

struct PostService {
    
    static func fetchPost(withId id: String) async throws -> Post {
        let postSnapshot = try await COLLECTION_POSTS.document(id).getDocument()
        let post = try postSnapshot.data(as: Post.self)
        return post
    }
    
    static func fetchUserPosts(user: User) async throws -> [Post] {
        let snapshot = try await COLLECTION_POSTS.whereField("ownerUid", isEqualTo: user.id).getDocuments()
        var posts = snapshot.documents.compactMap({try? $0.data(as: Post.self )})
        
        for i in 0 ..< posts.count {
            posts[i].user = user
        }
        
        return posts
    }
}

// MARK: - Likes

extension PostService {
    static func likePost(_ post: Post) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }
        
        async let _ = try await COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).setData([:])
        async let _ = try await COLLECTION_POSTS.document(postId).updateData(["likes": post.likes + 1])
        async let _ = try await COLLECTION_USERS.document(uid).collection("user-likes").document(postId).setData([:])
        
        async let _ = NotificationsViewModel.uploadNotification(toUid: post.ownerUid, type: .like, post: post)
    }
    
    static func unlikePost(_ post: Post) async throws {
        guard post.likes > 0 else { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let postId = post.id else { return }
        
        async let _ = try await COLLECTION_POSTS.document(postId).collection("post-likes").document(uid).delete()
        async let _ = try await COLLECTION_USERS.document(uid).collection("user-likes").document(postId).delete()
        async let _ = try await COLLECTION_POSTS.document(postId).updateData(["likes": post.likes - 1])
        
        async let _ = NotificationsViewModel.deleteNotification(toUid: uid, type: .like, postId: postId)
    }
    
    static func checkIfUserLikedPost(_ post: Post) async throws -> Bool {
        guard let uid = Auth.auth().currentUser?.uid else { return false }
        guard let postId = post.id else { return false }
        
        let snapshot = try await COLLECTION_USERS.document(uid).collection("user-likes").document(postId).getDocument()
        return snapshot.exists
    }
}
