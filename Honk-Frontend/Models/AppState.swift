//
//  AppState.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/30/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation

class AppState: ObservableObject{
    
    @Published var selectedCommunity: Community? = nil
    @Published var selectedChat: Chat? = nil
    
}
