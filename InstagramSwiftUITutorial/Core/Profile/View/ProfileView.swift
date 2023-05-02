//
//  ProfileView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct ProfileView: View {
    let user: User
    @StateObject var viewModel: ProfileViewModel
    @State private var showSettingsSheet = false
    @State private var selectedSettingsOption: SettingsItemModel?
    @State private var showDetail = false
    
    init(user: User) {
        self.user = user
        self._viewModel = StateObject(wrappedValue: ProfileViewModel(user: user))
    }
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    ProfileHeaderView(viewModel: viewModel)
                    
                    PostGridView(config: .profile(user))
                }
                .padding(.top)
            }
            .toolbar(content: {
                if user.isCurrentUser {
                    ToolbarItem(placement: .navigationBarTrailing) {
                        Button {
                            showSettingsSheet.toggle()
                        } label: {
                            Image(systemName: "line.3.horizontal")
                        }
                    }
                }
            })
            .navigationDestination(isPresented: $showDetail, destination: {
                Text(selectedSettingsOption?.title ?? "")
            })
            .navigationTitle(user.isCurrentUser ? "Profile" : user.username)
            .navigationBarTitleDisplayMode(.inline)
            .sheet(isPresented: $showSettingsSheet) {
                SettingsView(selectedOption: $selectedSettingsOption)
                    .presentationDetents([.height(CGFloat(SettingsItemModel.allCases.count * 56))])
            }
        }
        .onChange(of: selectedSettingsOption) { newValue in
            if newValue != .logout {
                self.showDetail.toggle()
            } else {
                AuthService.shared.signout()
            }
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView(user: dev.user)
    }
}
