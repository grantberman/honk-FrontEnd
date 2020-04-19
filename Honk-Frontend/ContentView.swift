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
        
        // I think will have to do a get call somewhere if we don't want the date to display if the same one did on the last text
        
        
        return Group {
            if !chatMessage.isMe{
               
                VStack{
                    Group{ // originally had this in the Vstack although it didn't orient correctly, moved back we'll see
                        Text(dateString.string(from:today))
                            .frame(maxWidth: .infinity, alignment: .center)
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
                VStack{
                    Group{
                        Spacer()
                        Text(dateString.string(from:today))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(10)
                    }
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
}


struct ContentView: View {
    
    @State var composedMessage: String = ""
    @EnvironmentObject var chatController : ChatController
    
    
    var body: some View {
        VStack{
            NavigationView {
                ReverseScrollView {

                    VStack{
                        ForEach (self.chatController.messages, id: \.self) { msg in
                            VStack(spacing: 0){
                                ChatRow(chatMessage: msg)
                            }
                        
                        }.onAppear {
                            UITableView.appearance().separatorStyle = .none     //gets rid of lines between messages
                            }
                    }
                    .navigationBarTitle("Chat Title", displayMode: .inline)
                }
            }
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
