//
//  ActiveNoewView.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import SwiftUI

struct ActiveNowView: View {
    
    @StateObject var viewModel = ActiveViewModel()
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 15) {
                ForEach(viewModel.users) { user in
                    NavigationLink(value: Route.chatView(user)) {
                        VStack {
                            ZStack (alignment: .bottomTrailing){
                                CircularProfileImageView(user: user, size: .large)
                                
                                ZStack{
                                    Circle()
                                        .fill(.white)
                                        .frame(width: 18, height: 18)
                                    
                                    Circle()
                                        .fill(Color(uiColor: .systemGreen))
                                        .frame(width: 12, height: 12)

                                }
                            }
                            
                            Text(user.firstName)
                                .font(.footnote)
                                .foregroundStyle(.gray)
                        }

                    }
                }
            }
            .padding()
        }
        .frame(height: 106)
//        .background(Color.yellow)
    }
}

#Preview {
    ActiveNowView()
}
