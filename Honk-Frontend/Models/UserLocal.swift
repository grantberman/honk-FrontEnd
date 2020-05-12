//
//  User.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/30/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation

class UserLocal   : ObservableObject {
    var username: String  = ""//should these details be made private or fileprivate?
    var password: String  = ""
    var email: String = ""
    var display_name = ""
    var apns = ""
    var biography = ""
    var test = false
    
    var auth = Authentication()
}

struct UserCodable: Codable {
    var id: String
    var username : String
    var email : String
    var apns : String
}
