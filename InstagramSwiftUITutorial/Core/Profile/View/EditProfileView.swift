//
//  EditProfileView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 1/9/21.
//

import SwiftUI
import Kingfisher
import PhotosUI

struct EditProfileView: View {
    @State private var bio = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var selectedImage: PhotosPickerItem?
    @State private var profileImage: Image?

    @StateObject private var viewModel: EditProfileViewModel
    @Binding var user: User
    @Environment(\.dismiss) var dismiss
    
    init(user: Binding<User>) {
        self._user = user
        self._viewModel = StateObject(wrappedValue: EditProfileViewModel(user: user.wrappedValue))
        self._username = State(initialValue: _user.wrappedValue.username)
        
        if let bio = _user.wrappedValue.bio {
            self._bio = State(initialValue: bio)
        }
        
        if let fullname = _user.wrappedValue.fullname {
            self._fullname = State(initialValue: fullname)
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Button("Cancel") {
                    dismiss()
                }
                
                Spacer()
                
                Text("Edit Profile")
                    .font(.subheadline)
                    .fontWeight(.semibold)
                
                Spacer()
                
                Button {
                    Task {
                        try await viewModel.updateUserData()
                        dismiss()
                    }
                } label: {
                    Text("Done")
                        .bold()
                }
            }
            .padding(.horizontal, 8)
            
            VStack(spacing: 8) {
                Divider()
                
                PhotosPicker(selection: $viewModel.selectedImage) {
                        VStack {
                            if let image = viewModel.profileImage {
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 72, height: 72)
                                    .clipShape(Circle())
                                    .foregroundColor(Color(.systemGray4))
                            } else {
                                CircularProfileImageView(user: user, size: .large)
                            }
                            Text("Edit profile picture")
                                .font(.footnote)
                                .fontWeight(.semibold)
                        }
                    }
                    .padding(.vertical, 8)
                
                Divider()
            }
            .padding(.bottom, 4)
            
            VStack {
                EditProfileRowView(title: "Name", placeholder: "Enter your name..", text: $viewModel.fullname)
                
                EditProfileRowView(title: "Bio", placeholder: "Enter your bio..", text: $viewModel.bio)
            }
            
            Spacer()
        }
        .onReceive(viewModel.$user, perform: { user in
            self.user = user
        })
        .navigationTitle("Edit Profile")
        .navigationBarTitleDisplayMode(.inline)
    }
}

struct EditProfileRowView: View {
    let title: String
    let placeholder: String
    @Binding var text: String
    
    var body: some View {
        
        HStack {
            Text(title)
                .padding(.leading, 8)
                .frame(width: 100, alignment: .leading)
                            
            VStack {
                TextField(placeholder, text: $text)
                
                Divider()
            }
        }
        .font(.subheadline)
        .frame(height: 36)
    }
}

struct EditProfileView_Previews: PreviewProvider {
    static var previews: some View {
        EditProfileView(user: .constant(dev.user))
    }
}
