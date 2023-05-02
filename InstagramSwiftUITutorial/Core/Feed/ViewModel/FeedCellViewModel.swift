//
//  FeedCellViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/31/20.
//

import SwiftUI
import Firebase

@MainActor
class FeedCellViewModel: ObservableObject {
    @Published var post: Post
    
    var likeString: String {
        let label = post.likes == 1 ? "like" : "likes"
        return "\(post.likes) \(label)"
    }
    
    var timestampString: String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: post.timestamp.dateValue(), to: Date()) ?? ""
    }
    
    init(post: Post) {
        self.post = post
        
        Task { try await checkIfUserLikedPost() }
    }
    
    func like() async throws {
        self.post.didLike = true
        self.post.likes += 1
        Task { try await PostService.likePost(post) }
    }
    
    func unlike() async throws {
        self.post.didLike = false
        self.post.likes -= 1
        Task { try await PostService.unlikePost(post) }
    }
    
    func checkIfUserLikedPost() async throws {
        self.post.didLike = try await PostService.checkIfUserLikedPost(post)
    }
}
