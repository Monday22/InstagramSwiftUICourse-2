//
//  ProfileViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/30/20.
//

import SwiftUI

@MainActor
class ProfileViewModel: ObservableObject {
    @Published var user: User
    
    init(user: User) {
        self.user = user
        loadUserData()
    }
    
    func follow() {
        UserService.follow(uid: user.id) { _ in
            NotificationsViewModel.uploadNotification(toUid: self.user.id, type: .follow)
            self.user.isFollowed = true
        }
    }
    
    func unfollow() {
        UserService.unfollow(uid: user.id) { _ in
            self.user.isFollowed = false
            NotificationsViewModel.deleteNotification(toUid: self.user.id, type: .follow)
        }
    }
    
    func checkIfUserIsFollowed() async -> Bool {
        guard !user.isCurrentUser else { return false }
        return await UserService.checkIfUserIsFollowed(uid: user.id)
    }
    
    func fetchUserStats() async throws -> UserStats{
        let uid = user.id
        
        async let followingSnapshot = try await FirestoreConstants.FollowingCollection.document(uid).collection("user-following").getDocuments()
        let following = try await followingSnapshot.count
        
        async let followerSnapshot = try await FirestoreConstants.FollowersCollection.document(uid).collection("user-followers").getDocuments()
        let followers = try await followerSnapshot.count
        
        async let postSnapshot = try await FirestoreConstants.PostsCollection.whereField("ownerUid", isEqualTo: uid).getDocuments()
        let posts = try await postSnapshot.count
        
        return .init(following: following, posts: posts, followers: followers)
    }
    
    func loadUserData() {
        Task {
            async let stats = try await fetchUserStats()
            self.user.stats = try await stats
            
            async let isFollowed = await checkIfUserIsFollowed()
            self.user.isFollowed = await isFollowed
        }
    }
}
