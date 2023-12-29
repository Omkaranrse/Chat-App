//
//  TextFieldWithIcon.swift
//  ChatApp
//
//  Created by Omkar Anarse on 23/12/23.
//

import Foundation
import SwiftUI

struct TextFieldWithIcon: View {
    let systemName: String
    let placeholder: String
    @Binding var text: String
    let geometry: GeometryProxy

    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(.gray)
            TextField(placeholder, text: $text)
                .autocapitalization(.none)
        }
        .padding()
        .frame(width: geometry.size.width * 0.9)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}

struct PasswordFieldWithIcon: View {
    let systemName: String
    let placeholder: String
    @Binding var text: String
    @State private var isSecure: Bool
    let geometry: GeometryProxy

    init(systemName: String, placeholder: String, text: Binding<String>, isSecure: Bool, geometry: GeometryProxy) {
        self.systemName = systemName
        self.placeholder = placeholder
        self._text = text
        self._isSecure = State(initialValue: isSecure)
        self.geometry = geometry
    }

    var body: some View {
        HStack {
            Image(systemName: systemName)
                .foregroundColor(.gray)
            
            if isSecure {
                SecureField(placeholder, text: $text)
            } else {
                TextField(placeholder, text: $text)
            }
            
            Button(action: {
                isSecure.toggle()
            }) {
                Image(systemName: isSecure ? "eye" : "eye.slash")
                    .foregroundColor(.gray)
            }
        }
        .padding()
        .frame(width: geometry.size.width * 0.9)
        .background(Color.gray.opacity(0.1))
        .clipShape(RoundedRectangle(cornerRadius: 8))
    }
}
