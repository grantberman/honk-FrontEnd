//
//  ChatRow.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct ChatRow: View {
        var chatMessage: ChatMessage
    
    var body: some View{
        Group {
            if !chatMessage.isMe{
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

struct ChatRow_Previews: PreviewProvider {
    static var previews: some View {
        ChatRow(chatMessage: ChatMessage(message: "Hi", avatar: "B", color: .blue))
    }
}







