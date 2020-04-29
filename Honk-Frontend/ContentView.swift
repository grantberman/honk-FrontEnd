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
        VStack{
            NavigationView {
                ReverseScrollView {

                    VStack{
                        ForEach (self.chatController.messages, id: \.self) { msg in
                            VStack{
                                ChatRow(chatMessage: msg)
                            }
                        }
                    }
                    .navigationBarTitle("Chat Title", displayMode: .inline)
                }
            }.padding()
            
        
            HStack{
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
                Button(action: sendMessage) {
                    Text("Send")
                    }
                }
                .padding()
                .keyBoardAdaptive()
            
        }
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler:
       @escaping (UNNotificationPresentationOptions) -> Void) {
        
        Text("Incoming Message")
        
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
