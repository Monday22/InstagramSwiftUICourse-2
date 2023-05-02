//
//  UserListView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct UserListView: View {
    @StateObject var viewModel: SearchViewModel
    private let config: SearchViewModelConfig
    @Binding var searchText: String
    
    init(config: SearchViewModelConfig, searchText: Binding<String>) {
        self.config = config
        self._viewModel = StateObject(wrappedValue: SearchViewModel(config: config))
        self._searchText = searchText
    }
    
    var users: [User] {
        return searchText.isEmpty ? viewModel.users : viewModel.filteredUsers(searchText)
    }
    
    var body: some View {
        ScrollView {
            LazyVStack {
                ForEach(users) { user in
                    NavigationLink(
                        destination: LazyView(ProfileView(user: user)),
                        label: {
                            UserCell(user: user)
                                .padding(.leading)
                                .onAppear {
                                    if user.id == users.last?.id ?? "" {
//                                        viewModel.fetchUsers(forConfig: config)
                                    }
                                }
                        })
                }
                
            }
            .navigationTitle(config.navigationTitle)
            .padding(.top)
        }
        .searchable(text: $searchText, placement: .navigationBarDrawer)
    }
}
