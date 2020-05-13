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
    
    init() {
        let username = KeychainWrapper.standard.string(forKey: "username") ?? ""
        let password = KeychainWrapper.standard.string(forKey: "password") ?? ""
      
        if username != "" && password != "" {
            //if there are saved credentials
            print("user and pass exist!")
            self.username = username
            self.password = password
            
            self.auth.getAuth( username, password )
        }
    }
}

struct UserCodable: Codable {
    var id: String
    var username : String
    var email : String
    var apns : String
}
