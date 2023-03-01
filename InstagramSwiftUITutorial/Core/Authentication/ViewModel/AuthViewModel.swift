//
//  AuthViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI
import Firebase
import FirebaseAuth

class AuthViewModel: ObservableObject {
    @Published var userSession: FirebaseAuth.User?
    @Published var currentUser: User?
    @Published var didSendResetPasswordLink = false
    
    static let shared = AuthViewModel()
    
    init() {
        userSession = Auth.auth().currentUser
        
        Task {
            await fetchUser()
        }
    }
    
    @MainActor
    func login(withEmail email: String, password: String) async throws {
        do {
            let result = try await Auth.auth().signIn(withEmail: email, password: password)
            self.userSession = result.user
            await fetchUser()
        } catch {
            print("DEBUG: Login failed \(error.localizedDescription)")
        }
    }
    
    @MainActor
    func register(
        withEmail email: String,
        password: String,
        image: UIImage?,
        fullname: String,
        username: String
    ) async throws {
        guard let image = image else { return }
        
        do {
            let imageUrl = try await ImageUploader.uploadImage(image: image, type: .profile)
            let result = try await Auth.auth().createUser(withEmail: email, password: password)
            self.userSession = result.user
            
            let data: [String: Any] = [
                "email": email,
                "username": username,
                "fullname": fullname,
                "profileImageUrl": imageUrl ?? "",
                "uid": result.user.uid
            ]
            
            try await COLLECTION_USERS.document(result.user.uid).setData(data)
            await fetchUser()
        } catch {
            print("DEBUG: Failed to create user with error: \(error.localizedDescription)")
        }
    }
    
    func signout() {
        self.userSession = nil
        self.currentUser = nil
        try? Auth.auth().signOut()
    }
    
    func resetPassword(withEmail email: String) {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Failed to send link with error \(error.localizedDescription)")
                return
            }
            
            self.didSendResetPasswordLink = true
        }
    }
    
    @MainActor
    func fetchUser() async {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let snapshot = try? await COLLECTION_USERS.document(uid).getDocument()
        guard let user = try? snapshot?.data(as: User.self) else { return }
        self.currentUser = user
    }
}
