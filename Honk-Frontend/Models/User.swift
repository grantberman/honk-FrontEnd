//
//  User.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/30/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation

class User : ObservableObject {
    var username: String  = ""//should these details be made private or fileprivate?
    var password: String  = ""
    var email: String = ""
    var communities: [Community] = [] 
}
