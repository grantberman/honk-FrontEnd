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

        VStack {
            if viewRouter.currentPage == "page1" {
                LoginView(viewRouter: viewRouter)
            } else if viewRouter.currentPage == "page2" {
                ContentView(viewRouter: viewRouter)
            } else if viewRouter.currentPage == "page3" {
                CreateCommunityView(viewRouter: viewRouter)
            }
        }


    }
}

struct MotherView_Previews: PreviewProvider {
    static var previews: some View {
        MotherView(viewRouter: ViewRouter())
    }
}
