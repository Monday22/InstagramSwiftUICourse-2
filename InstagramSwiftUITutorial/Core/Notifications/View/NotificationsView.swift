//
//  NotificationsView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/26/20.
//

import SwiftUI

struct NotificationsView: View {
    @StateObject var viewModel = NotificationsViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                LazyVStack(spacing: 20) {
                    ForEach($viewModel.notifications) { notification in
                        NotificationCell(notification: notification)
                            .padding(.top)
                            .onAppear {
                                if notification.id == viewModel.notifications.last?.id ?? "" {
                                    print("DEBUG: paginate here..")
                                }
                            }
                    }
                }
                .navigationTitle("Notifications")
                .navigationBarTitleDisplayMode(.inline)
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
        }
    }
}

struct NotificationsView_Previews: PreviewProvider {
    static var previews: some View {
        NotificationsView()
    }
}
