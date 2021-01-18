//
//  ChatModels.swift
//  ChatApp
//
//  Created by Monish Chaudhari on 18/01/21.
//  Copyright © 2021 Monish Chaudhari. All rights reserved.
//

import Foundation

class ConversationUser: NSObject {
    var firstName:String?
    var lastName:String?
    var Messages = [Message]()
    var lastSeen:Date?
    
    init(firstName:String, lastName:String) {
        self.firstName = firstName
        self.lastName = lastName
    }
    
}

class Message: NSObject {
    var text:String?
    var timestamp:Date?
    
    init(text:String, timestamp:Date = Date()) {
        self.text = text
        self.timestamp = timestamp
    }
}
