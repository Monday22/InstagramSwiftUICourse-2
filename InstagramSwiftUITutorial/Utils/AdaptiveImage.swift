//
//  AdaptiveImage.swift
//  InstagramSwiftUITutorial
//
//  Created by Stephan Dowless on 4/28/23.
//

import SwiftUI

struct AdaptiveImage: View {
    @Environment(\.colorScheme) var colorScheme
    let light: String
    let dark: String

    @ViewBuilder var body: some View {
        if colorScheme == .light {
            Image(light)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 100)
        } else {
            Image(dark)
                .resizable()
                .scaledToFit()
                .frame(width: 220, height: 100)
        }
    }
}
