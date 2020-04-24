//
//  ContentView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/14/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI


struct ContentView: View {
    
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController : ChatController
    
    
    var body: some View {
        
        
        VStack {
            NavigationView {
            List {
                ForEach (chatController.messages, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }.onAppear {
                UITableView.appearance().separatorStyle = .none     //gets rid of lines between messages
                
            }
            
        }
            HStack{
                TextField("Message...", text:$composedMessage).frame(minHeight: CGFloat(30))
                Button(action: sendMessage) {
                    Text("Send")
                }
                }.frame(minHeight:CGFloat(50)).padding()
        }
        
    }
    func sendMessage() {
        chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "C", color: .green, isMe: true))
        composedMessage = ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
        .environmentObject(ChatController())
    }
}
