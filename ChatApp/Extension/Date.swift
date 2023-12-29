//
//  Date.swift
//  ChatApp
//
//  Created by Omkar Anarse on 29/12/23.
//

import Foundation

extension Date {
    
    private var timeFormater : DateFormatter {
        let formater = DateFormatter()
        formater.timeStyle = .short
        formater.dateFormat = "HH:mm"
        return formater
    }

    private var dayFormater : DateFormatter {
        let formater = DateFormatter()
        formater.timeStyle = .medium
        formater.dateFormat = "MM/dd/yy"
        return formater
    }
    
    private func timeString() -> String {
        return timeFormater.string(from: self)
    }
    
    private func dayString() -> String {
        return dayFormater.string(from: self)
    }
    
    func timestampString() -> String {
        if Calendar.current.isDateInToday(self){
            return timeString()
        } else if Calendar.current.isDateInYesterday(self) {
            return "Yesterday"
        } else {
            return dayString()
        }
    }
}
