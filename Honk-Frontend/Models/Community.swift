//
//  Community.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/30/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation

struct Community  {
    var id : Int
    var name : String
    var description: String
    var created_at : String
    var chats: [Chat]
    var subscriptions: String?
}
