//
//  ViewRouter.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/6/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

class ViewRouter: ObservableObject {
    
    let objectWillChange = PassthroughSubject<ViewRouter,Never>()

    var currentPage: String = "page1" {
        didSet {
            objectWillChange.send(self)
        }
    }
}
