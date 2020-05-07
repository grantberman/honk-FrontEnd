//
//  MotherView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/6/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct MotherView: View {
    
    
    @ObservedObject var viewRouter: ViewRouter

    var body: some View {

      Text("hello")


    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter())
    }
}
