//
//  SettingOptionsViewModel.swift
//  ChatApp
//
//  Created by Omkar Anarse on 24/12/23.
//

import Foundation
import SwiftUI

enum SettingOptionsViewModel : Int, CaseIterable , Identifiable {
    var id: Int { return self.rawValue }
    
    case darkMode
    case activeStatus
    case accessibility
    case privacy
    case notifications
    
    var title : String {
        switch self {
        case .darkMode: return "Dark Mode"
        case .activeStatus: return "Active Status"
        case .accessibility: return "Accessibility"
        case .privacy: return "Privacy & Security"
        case .notifications: return "Notification"
        }
    }
    
    var imageName : String {
        switch self {
        case .darkMode: return "moon.circle.fill"
        case .activeStatus: return "message.badge.circle.fill"
        case .accessibility: return "person.circle.fill"
        case .privacy: return "lock.circle.fill"
        case .notifications: return "bell.circle.fill"
        }
    }
    
    var imageBackGroundColor : Color {
        switch self {
        case .darkMode: return Color(.black)
        case .activeStatus: return Color(uiColor: .systemGreen)
        case .accessibility: return Color(.black)
        case .privacy: return Color(uiColor: .systemBlue)
        case .notifications: return Color(uiColor: .systemPurple)
        }
    }
}
