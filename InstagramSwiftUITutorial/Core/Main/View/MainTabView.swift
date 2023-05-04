//
//  MainTabView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct MainTabView: View {
    let user: User
    @Binding var selectedIndex: Int
    
    var body: some View {
            TabView(selection: $selectedIndex) {
                FeedView()
                    .onAppear {
                        selectedIndex = 0
                    }
                    .tabItem {
                        Image(systemName: "house")
                    }.tag(0)
                
                SearchView()
                    .onAppear {
                        selectedIndex = 1
                    }
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                    }.tag(1)
                    
                UploadMediaView(tabIndex: $selectedIndex)
                    .onAppear {
                        selectedIndex = 2
                    }
                    .tabItem {
                        Image(systemName: "plus.square")
                    }.tag(2)
                
                NotificationsView()
                    .onAppear {
                        selectedIndex = 3
                    }
                    .tabItem {
                        Image(systemName: "heart")
                    }.tag(3)
                
                CurrentUserProfileView(user: user)
                    .onAppear {
                        selectedIndex = 4
                    }
                    .tabItem {
                        Image(systemName: "person")
                    }.tag(4)
            }
            .accentColor(Color.theme.systemBackground)
    }
    
    var messageLink: some View {
        NavigationLink(
            destination: ConversationsView(),
            label: {
                Image(systemName: "paperplane")
                    .resizable()
                    .font(.system(size: 20, weight: .light))
                    .scaledToFit()
                    .foregroundColor(.black)
            })
    }
}
