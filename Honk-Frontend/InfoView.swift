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
    
    //var mostLikes = 0

    
    var body: some View {
        NavigationView{
                
            VStack{
                Text("Statistics")
                .bold()
                .font(.title)
                .padding(20)
                Group{
                    Text("Messages in chat: " + String(describing: appState.selectedChat!.chatMessages.count))
                    
                   
                    //Text("Messages per week: " + String(describing: appState.selectedChat?.chatMessages))
                }.padding(10)
            }.navigationBarTitle(Text("Info"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                }){
                    Text("Done")
                })
        }

    }
//
//    public func getMostLikes() -> Message{
//        var mostLikes = 0
//        ForEach(self.appState.selectedChat!.chatMessages, id:\.self ){
//            selectedMessage in
//            Group{
//                if (selectedMessage.reactions.count > mostLikes){
//                    mostLikes
//
//                }
//                else{
//
//                }
//
//            }
//        }
//    }
}

