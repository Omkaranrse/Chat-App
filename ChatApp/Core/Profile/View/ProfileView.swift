//
//  ProfileView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI
import PhotosUI

struct ProfileView: View {
    
    @State private var isLoading = false
    @Environment(\.dismiss) var dismiss

    let user : User
    
    
    var body: some View {
        VStack {
            
            ///HEADER
            VStack {

                CircularProfileImageView(user: user, size: .xLarge)
                
                Text(user.fullName ?? "")
                    .font(.title)
                    .fontWeight(.semibold)
            }

            
            List{
                Section{
                    ForEach(SettingOptionsViewModel.allCases){ option in
                        HStack{
                            Image(systemName: option.imageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 25, height: 25)
                                .foregroundStyle(Color(option.imageBackGroundColor))
                            
                            Text(option.title)
                                .font(.subheadline)
                        }
                    }
                }
                
                Section{
                    Button("Log Out"){
                        AuthService.shared.signOut()
                    }
                    NavigationLink("Edit", destination: EditProfileView(user: user))
                }
                .foregroundStyle(Color.red)
            }
        }        
        .overlay {
            Group {
                if isLoading {
                    // Show circular progress view
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle())
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(Color.black.opacity(0.3))
                        .ignoresSafeArea()
                } else {
                    EmptyView()
                }
            }
        }
    }
}

#Preview {
    ProfileView(user: User.MOCK_USER)
}
