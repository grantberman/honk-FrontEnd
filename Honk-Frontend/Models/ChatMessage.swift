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
