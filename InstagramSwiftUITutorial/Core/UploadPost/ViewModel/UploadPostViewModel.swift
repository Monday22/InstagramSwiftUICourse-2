//
//  UploadPostViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/31/20.
//

import SwiftUI
import Firebase
import PhotosUI

@MainActor
class UploadPostViewModel: ObservableObject {
    @Published var didUploadPost = false
    @Published var error: Error?
    @Published var selectedImage: PhotosPickerItem? {
        didSet { Task { await loadImage(fromItem: selectedImage) } }
    }
    @Published var profileImage: Image?
    private var uiImage: UIImage?
    
    func uploadPost(caption: String) async throws {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        guard let image = uiImage else { return }
        
        do {
            guard let imageUrl = try await ImageUploader.uploadImage(image: image, type: .post) else { return }
            let data: [String: Any] = [
                "caption": caption,
                "timestamp": Timestamp(date: Date()),
                "likes": 0,
                "imageUrl": imageUrl,
                "ownerUid": uid,
            ]
            
            let _ = try await COLLECTION_POSTS.addDocument(data: data)
            self.didUploadPost = true
        } catch {
            print("DEBUG: Failed to upload image with error \(error.localizedDescription)")
            self.error = error
        }
    }
    
    func loadImage(fromItem item: PhotosPickerItem?) async {
        guard let item = item else { return }
        
        guard let data = try? await item.loadTransferable(type: Data.self) else { return }
        guard let uiImage = UIImage(data: data) else { return }
        self.uiImage = uiImage
        self.profileImage = Image(uiImage: uiImage)

    }
}
