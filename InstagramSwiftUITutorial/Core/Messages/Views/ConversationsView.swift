//
//  ConversationsView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/9/21.
//

import SwiftUI

struct ConversationsView: View {
    @State var isShowingNewMessageView = false
    @State var showChat = false
    @State var user: User?
    @ObservedObject var viewModel = ConversationsViewModel()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            ScrollView {
                VStack {
                    ForEach(viewModel.recentMessages) { message in
                        NavigationLink(
                            destination: Text("Messages")/* */,
                            label: {
                                ConversationCell(message: message)
                            })
                    }
                }.padding()
            }
            
            HStack {
                Spacer()
                
                Button(action: { self.isShowingNewMessageView.toggle() }, label: {
                    Image(systemName: "envelope")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 28, height: 28)
                        .padding()
                })
                .background(Color(.systemBlue))
                .foregroundColor(.white)
                .clipShape(Circle())
                .padding()
                .sheet(isPresented: $isShowingNewMessageView, content: {
                    NewMessageView(show: $isShowingNewMessageView, startChat: $showChat, user: $user)
                })
            }
            .navigationTitle("Messages")
            .navigationBarTitleDisplayMode(.inline)
        }
        .onAppear {
            viewModel.fetchRecentMessages()
        }
        .navigationDestination(isPresented: $showChat) {
            if let user = user {
                ChatView(user: user)
            }
        }
    }
}

struct ConversationsView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationsView()
    }
}
