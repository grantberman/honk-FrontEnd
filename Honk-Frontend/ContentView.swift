//
//  ContentView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/14/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI



struct ChatMessage : Hashable {
    var message: String
    var avatar: String
    var color: Color
    var isMe: Bool = false
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

struct ChatRow: View {
    var chatMessage: ChatMessage
   
    
    var body: some View{
        
        let today = Date()
        let dateString = DateFormatter()
        dateString.dateFormat = "HH:mm E, d MMM y"
        
        
        return Group {
            if !chatMessage.isMe{
                VStack{
                    HStack{
                        Group{
                                       
                            Text(dateString.string(from:today))
                            }
                        }
                    HStack {
                        Group {
                             Text(chatMessage.avatar)
                             Text(chatMessage.message)
                                 .bold()
                                 .foregroundColor(.white)
                                 .padding(10)
                                 .background(chatMessage.color)
                                 .cornerRadius(10)
                                .frame(minWidth: 10, maxWidth: 250,  alignment: .leading)
                        }
                    }
                   
                }
                
            } else {
                HStack {
                    Group {
                        Spacer()
                        Text(chatMessage.message)
                            .bold()
                            .foregroundColor(.white)
                            .padding(10)
                            .background(chatMessage.color)
                            .cornerRadius(10)
                        Text(chatMessage.avatar)
                        
                    }
                }
                
            }

        }
    }
    
}


struct ContentView: View {
    
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController : ChatController
    
    
    var body: some View {
        VStack {
            List {
                ForEach (chatController.messages, id: \.self) { msg in
                    ChatRow(chatMessage: msg)
                }
            }
            HStack{
                TextField("Message...", text: $composedMessage).frame(minHeight: CGFloat(30))
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
