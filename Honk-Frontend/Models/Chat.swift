//
//  Chat.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/30/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation


struct Chat: Hashable {
    
    var id: Int
    var communityId: Int
    var name: String
    var created_at: String
    var messages: [ChatMessage] 
    
    
}
