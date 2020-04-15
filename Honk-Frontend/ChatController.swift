//
//  ChatController.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/15/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Combine
import SwiftUI

class ChatController : ObservableObject {
    
    var willChange = PassthroughSubject<Void, Never>()
    
    @Published var messages = [
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue)
    ]
    
    func sendMessage(_ chatMessage: ChatMessage) {
        messages.append(chatMessage)
        willChange.send()
    }
}
