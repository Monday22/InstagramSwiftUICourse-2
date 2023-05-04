//
//  SearchView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct SearchView: View {
    @State var searchText = ""
    @State var inSearchMode = false
    
    var body: some View {
        NavigationStack {
            UserListView(config: .search)
                .navigationTitle("Explore")
                .navigationBarTitleDisplayMode(.inline)
                .navigationDestination(for: User.self) { user in
                    ProfileView(user: user)
                }
        }
    }
}

struct SearchView_Previews: PreviewProvider {
    static var previews: some View {
        SearchView()
    }
}
