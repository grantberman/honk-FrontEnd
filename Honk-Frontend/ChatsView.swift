//
//  ChatsView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/5/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct ChatsView: View {
    //@EnvironmentObject var user : User
    //@EnvironmentObject var appState: AppState
    //@State var currentChat: Chat
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: ChatN.entity(), sortDescriptors: []) var chats: FetchedResults<ChatN>// a list of all of your chats
       
       
    @ViewBuilder
    var body: some View {
        
        var currentCommunityName = chats[0].communityName
        NavigationView {
                    
                    VStack{
                    List{
                        ForEach(chats, id: \.name ) { chatItem in
                            VStack{
                                 Group{
                                    // this should hopefully work if coredata is updated
                                    // also this is where we will go to the chat
                                    Text(chatItem.wrappedName)
                                    
                                 }.frame(width: .infinity, height: 100, alignment: .leading)
                                .padding(50)
                            }
                        }
                    }
                    Group{
                        Button(action: {
                            //change this to other function that takes user
                            //to creating community page
                        }){
                            Text("Create new chat")
                            .font(.headline)
                            .foregroundColor(.white)
                            }
                            //.frame(width: 300, height: 50)
                            .fixedSize(horizontal: false, vertical: true)
                            .padding(20)
                            .foregroundColor(.white)
                            .background(Color.blue)
                            .cornerRadius(40)
                        }
                        
                    }
                    
                }//.navigationBarTitle("Your Chats in " + currentCommunityName)
            }
        }



struct ChatsView_Previews: PreviewProvider {
    static var previews: some View {
        ChatsView()
    }
}
