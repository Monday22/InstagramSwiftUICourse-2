//
//  LoginViewModel.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephan Dowless on 4/29/23.
//

import Foundation

class LoginViewModel: ObservableObject {
    func login(withEmail email: String, password: String) async throws {
        try await AuthService.shared.login(withEmail: email, password: password)
    }
}
