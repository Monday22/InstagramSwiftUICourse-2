//
//  ChatViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/9/21.
//

import SwiftUI
import Firebase

class ChatViewModel: ObservableObject {
    let user: User
    @Published var messages = [Message]()
    
    init(user: User) {
        self.user = user
        fetchMessages()
    }
    
    func fetchMessages() {
        guard let currentUid = AuthViewModel.shared.userSession?.uid else { return }
        guard let uid = user.id else { return }
        
        let query = COLLECTION_MESSAGES.document(currentUid).collection(uid)
        
        query.addSnapshotListener { snapshot, error in
            guard let changes = snapshot?.documentChanges.filter({ $0.type == .added }) else { return }            
            self.messages.append(contentsOf: changes.compactMap({ try? $0.document.data(as: Message.self) })) 
        }
    }
    
    func sendMessage(_ messageText: String) {
        guard let currentUser = AuthViewModel.shared.currentUser else { return }
        guard let currentUid = currentUser.id else { return }
        guard let uid = user.id else { return }
        
        let currentUserRef = COLLECTION_MESSAGES.document(currentUid).collection(uid).document()
        let receivingUserRef = COLLECTION_MESSAGES.document(uid).collection(currentUid)
        let receivingRecentRef = COLLECTION_MESSAGES.document(uid).collection("recent-messages")
        let currentRecentRef =  COLLECTION_MESSAGES.document(currentUid).collection("recent-messages")
        
        let messageID = currentUserRef.documentID
        
        let data: [String: Any] = ["text": messageText,
                                   "id": messageID,
                                   "fromId": currentUid,
                                   "toId": uid,
                                   "username": user.username,
                                   "profileImageUrl": user.profileImageUrl,
                                   "fullname": user.fullname,
                                   "timestamp": Timestamp(date: Date())]
        
        let recipientData: [String: Any] = ["text": messageText,
                                            "id": messageID,
                                            "fromId": currentUid,
                                            "toId": uid,
                                            "username": currentUser.username,
                                            "profileImageUrl": currentUser.profileImageUrl,
                                            "fullname": currentUser.fullname,
                                            "timestamp": Timestamp(date: Date())]
        
        currentUserRef.setData(data)
        currentRecentRef.document(uid).setData(data)

        receivingUserRef.document(messageID).setData(recipientData)
        receivingRecentRef.document(currentUid).setData(recipientData)
    }
}
