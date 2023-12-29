//
//  CircularProfileImageView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI
import Kingfisher
import Firebase
import FirebaseStorage

enum profileImageSize {
    case xxSmall
    case xSmall
    case small
    case medium
    case large
    case xLarge
    
    var dimenssion : CGFloat {
        switch self {
        case .xxSmall: return 28
        case .xSmall: return 32
        case .small: return 40
        case .medium: return 56
        case .large: return 64
        case .xLarge: return 100
        }
    }
}


struct CircularProfileImageView: View {
    
    let user : User?
    let size : profileImageSize
    
    var body: some View {
        if let imageUrl = user?.profileImageUrl {
            KFImage(URL(string: imageUrl))
                .resizable()
                .scaledToFill()
                .frame(width: size.dimenssion, height: size.dimenssion)
                .clipShape(Circle())
        } else {
            Image(systemName: "person.circle.fill")
                .resizable()
                .frame(width: size.dimenssion, height: size.dimenssion)
                .clipShape(Circle())
                .foregroundStyle(Color(.systemGray4))
        }
    }
}

//#Preview {
//    CircularProfileImageView(user: <#User?#>, size: <#profileImageSize#>)
//}


