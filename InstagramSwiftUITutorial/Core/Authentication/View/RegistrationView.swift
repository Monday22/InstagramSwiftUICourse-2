//
//  RegistrationView.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephen Dowless on 12/27/20.
//

import SwiftUI

struct RegistrationView: View {
    @State private var email = ""
    @State private var fullname = ""
    @State private var username = ""
    @State private var password = ""
    @State private var selectedImage: UIImage?
    @State private var image: Image?
    @State var imagePickerPresented = false
    @Environment(\.presentationMode) var mode
    @EnvironmentObject var viewModel: AuthViewModel
    
    var body: some View {
        VStack {
            Button(action: {
                
            }, label: {
                Text("Sign Up")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(width: 360, height: 44)
                    .background(Color(.systemBlue))
                    .cornerRadius(8)
                    .padding()
            })
            
            Spacer()
            
            Button(action: { mode.wrappedValue.dismiss() }, label: {
                HStack {
                    Text("Already have an account?")
                        .font(.system(size: 14))
                    
                    Text("Sign In")
                        .font(.system(size: 14, weight: .semibold))
                }.foregroundColor(.white)
            })
        }
    }
}

extension RegistrationView {
    func loadImage() {
        guard let selectedImage = selectedImage else { return }
        image = Image(uiImage: selectedImage)
    }
}

struct RegistrationView_Previews: PreviewProvider {
    static var previews: some View {
        RegistrationView()
    }
}
