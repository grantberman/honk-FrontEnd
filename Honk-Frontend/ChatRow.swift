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
                        .padding(5)
                        }
                    HStack {
                        Group {
                             Text(chatMessage.avatar)
                                 .padding(.leading, 5)
                            .frame(alignment: .leading)
                             Text(chatMessage.message)
                                 .bold()
                                 .foregroundColor(.white)
                                 .padding(10)       //comment this out to 
                                 .background(chatMessage.color)
                                 .cornerRadius(10)
                            
                            
                                 .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: 10, maxWidth: 300,  alignment: .leading)
                            Spacer()
                        }
                        // One thing I don't know about here is why the receiving texts are showing up more central. It doesn't have to do with the frame and I can't find a reason for them to be. It also happens if I send a new text as isme=false. Is it because navigationview has something there we cant see? then why doesn't it adjust when I get rid of navigation view
                    }
                }
            } else {
                VStack{
                    Group{
                        Spacer()
                        Text(dateString.string(from:today))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(5)
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
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: 10, maxWidth: 250, alignment: .bottomTrailing)
                            Text(chatMessage.avatar)
                                .padding(.trailing, 5)
                            
                        }
                    }
                }
            }
        }
    }
}

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chatMessage: ChatMessage(message: "This is a long message test Im not sure what will happen with it and we need to see what happens", avatar: "B", color: .blue)).previewDevice("iPhone 8")
    }
}







