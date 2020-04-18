//
//  ContentView.swift
//  Honk-Frontend-Scrolling-learning
//
//  Created by Nicholas O'Leary on 4/18/20.
//  Copyright © 2020 Honk. All rights reserved.
//

import SwiftUI

struct ConversationView: View {
    
    var conversation : Conversation
    
    var body: some View {
        NavigationView{
            ReverseScrollView{
                VStack(spacing: 8){
                    ForEach(self.conversation.messages){
                        message in
                        return BubbleView(message: message.body)
                    }
                }
            }.navigationBarTitle(Text("Chat Title"))
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ConversationView(conversation: demoConversation)
    }
}
