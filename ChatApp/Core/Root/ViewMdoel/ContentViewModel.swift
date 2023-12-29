//
//  ContentViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 26/12/23.
//

import Foundation
import Firebase
import FirebaseAuth
import Combine

class ContentViewModel : ObservableObject {
    
    @Published var userSession : FirebaseAuth.User?
    private var cancellables = Set<AnyCancellable>()
    
    init(){
        setSubscriber()
    }
    
    func setSubscriber(){
        AuthService.shared.$userSession
            .receive(on: DispatchQueue.main)
            .sink { [weak self] userSessionFromAuthService in
                self?.userSession = userSessionFromAuthService
            }
            .store(in: &cancellables)
    }
}
