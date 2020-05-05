//
//  ChatMessage.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI


struct ChatMessage: Hashable{
    var message: String
    var avatar: String
    var color: Color
    var isMe: Bool = false
}

class ChatMessageD : NSObject {
    @NSManaged public var message: String
    @NSManaged public var avatar: String
    @NSManaged public var isMe: Bool
}


struct ChatMessageCodable : Codable {
    var id: String
    var chat : String
    var author : String
    var createdAt : String
    var content : String
    
}
