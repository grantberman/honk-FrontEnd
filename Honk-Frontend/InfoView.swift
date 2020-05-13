//
//  InfoView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/13/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct InfoView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState

    
    var body: some View {
        NavigationView{
                
            VStack{
                Text("Statistics")
                .bold()
                .font(.title)
                .padding(20)
                Group{
                    Text("Top messenger: ")
                    Text("Messages per week: ")
                }.padding(10)
            }.navigationBarTitle(Text("Info"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                }){
                    Text("Done")
                })
        }

    }
}

