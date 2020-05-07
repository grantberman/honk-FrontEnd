//
//  ChatRow.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


struct ChatRow: View {
    var chatMessage: MessageN
    @EnvironmentObject var user: User
    
    var isMe : Bool  = false
    //        return chatMessage.authorDef.usernameDef == self.user.username
    //
    //    }
    
    
    var body: some View{
        
        let today = Date()
        let dateString = DateFormatter()
        dateString.dateFormat = "HH:mm E, d MMM y"
        
        // I think will have to do a get call somewhere if we don't want the date to display if the same one did on the last text
        
        
        return Group {
            GeometryReader { geometry in
                if self.chatMessage.author?.usernameDef != self.user.username{
                    //            if isMe{
                    VStack{
                        HStack {
                            Group {
                                Text(self.chatMessage.avatar)
                                    .padding(.leading, 5)
                                    .frame(alignment: .leading)
                                Text(self.chatMessage.contentDef)
                                    
                                    .bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                .padding(10)
                                    .foregroundColor(.white)
                                
                                                                            //comment this out to
                                    //                                 .background(chatMessage.color)
                                    .cornerRadius(10)
                                    
                                    
                                    
//                                    .frame(minWidth: 10, maxWidth: 300,  alignment: .leading)
//                                    .padding(10)
                                    .contextMenu{
                                        Button(action: self.reactToMessage){
                                            HStack{
                                                Text("Like")
                                                Image("thumbs-up")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }.frame(alignment: .leading)
                                        
                                        Button(action: self.createSubChat){
                                            
                                            HStack{
                                                Text("Create sub chat")
                                                Image("sub-group")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }
                                }
                                Spacer()
                            }
//                        }.onTapGesture {
//                            print(self.chatMessage.author?.usernameDef)
//                            print(self.user.username)
                        }
                    }
                } else {
                    VStack{
                        
                        HStack {
                            Group {
                                Spacer()
                                Text(self.chatMessage.contentDef)
//                                    .bold()
//                                    .foregroundColor(.white)
//                                    .padding(10)
//                                    .background(Color.green)
//                                    .cornerRadius(10)
                                    
                                .bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                .padding(10)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                .cornerRadius(10)
//                                    .frame(minWidth: 10, maxWidth: 250, alignment: .bottomTrailing)
                                
                                Text(self.chatMessage.avatar)
                                    .padding(.trailing, 5)
                                
                            }
                        }.frame(alignment: .bottomTrailing)
//                            .onTapGesture {
//                            print(self.chatMessage.author?.usernameDef)
//                            print(self.user.username)
//                        }
                    }
                }
            }
            .frame(maxWidth: 500)
//            .padding(50)
        }
    }
    
    func reactToMessage(){
        // in here will be the API call to like
        
    }
    func createSubChat(){
        // in here will be API call to create new subgroup
    }
}
//
//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chatMessage: ChatMessage(message: "This is a long message test Im not sure what will happen with it and we need to see what happens", avatar: "B", color: .blue)).previewDevice("iPhone 8")
//    }
//}
//








