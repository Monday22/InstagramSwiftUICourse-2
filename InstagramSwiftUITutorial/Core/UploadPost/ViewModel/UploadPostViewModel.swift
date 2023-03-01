//
//  UploadPostViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/31/20.
//

import SwiftUI
import Firebase

class UploadPostViewModel: ObservableObject {
    @Published var didUploadPost = false
    @Published var error: Error?
    
    func uploadPost(caption: String, image: UIImage) async throws {
        guard let user = AuthViewModel.shared.currentUser else { return }
        
        do {
            guard let imageUrl = try await ImageUploader.uploadImage(image: image, type: .post) else { return }
            let data: [String: Any] = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageUrl": imageUrl,
                "ownerUid": user.id ?? "",
                "ownerImageUrl": user.profileImageUrl,
                "ownerUsername": user.username
            ]
            
            let _ = try await COLLECTION_POSTS.addDocument(data: data)
            self.didUploadPost = true
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            self.error = error
        }
    }
}
