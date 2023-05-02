//
//  PreviewProvider.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephan Dowless on 4/17/23.
//

import SwiftUI

extension PreviewProvider {
    static var dev: DeveloperPreview {
        return DeveloperPreview.shared
    }
}

class DeveloperPreview {
    static let shared = DeveloperPreview()
    
    var user = User(uid: NSUUID().uuidString, username: "batman", email: "batman@gmail.com", profileImageUrl: nil, fullname: "Bruce Wayne")
}
