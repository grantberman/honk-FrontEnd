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
    @State var menuOpen: Bool = false
    @Environment(\.managedObjectContext) var moc

    @EnvironmentObject var appState : AppState
    @EnvironmentObject var chatController : ChatController
    @EnvironmentObject var user: User
    @FetchRequest(entity: CommunityN.entity(), sortDescriptors: []) var communities: FetchedResults<CommunityN>// a list of all of your communities
    
    
    var body: some View {
        
        
            let drag = DragGesture()
                .onEnded{
                    if $0.translation.width < -100 {
                        withAnimation {
                            self.menuOpen = false
                        }
                    }
            }
            
            return GeometryReader { geometry in
                
                ZStack {
                    
                    if (self.communities.isEmpty){
                        VStack{
                            Group{
                                Text("You have no communities")
                                Button(action: self.createNewCommunity){
                                    Text("Create new Community")
                                    }
                                }
                            }
                          }
                    else{
                    
                    VStack{
                        NavigationView {
                            ReverseScrollView {
                                
                                VStack{
                                    ForEach (self.appState.selectedChat?.messages ?? [], id: \.self) { msg in
                                        VStack{
                                            ChatRow(chatMessage: msg)
                                        }
                                    }
                                }
                                .navigationBarTitle("Chat Title", displayMode: .inline)
                            }
                            .navigationBarItems(leading:
                                Button(action: {
                                    self.openMenu()
                                    do {
                                        try self.moc.save()
                                    } catch {
                                        print("no save")
                                    }
                                    print("Edit button pressed...")
                                }) {
                                    Text("Edit")
                                }
                            )
                        }.padding()
                        
                        
                        HStack{
                            TextField("Message...", text: self.$composedMessage).frame(minHeight: CGFloat(30))
                            Button(action: self.sendMessage) {
                                Text("Send")
                            }
                        }
                        .padding()
                        .keyBoardAdaptive()
                        
                    }
                    }
                    SideMenu(width: 270,
                             isOpen: self.menuOpen,
                             menuClose: self.openMenu)
                }.gesture(drag)
                
            }
    }
    
        func openMenu() {
            self.menuOpen.toggle()
        }
        
        
        func sendMessage() {
            chatController.sendMessage(ChatMessage(message: composedMessage, avatar: "C", color: .green, isMe: true))
            composedMessage = ""
        }
    
    func createNewCommunity(){
        // go to new community page
    }
        
    

}
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ChatController()).environmentObject(AppState())
        .environmentObject(User())
    }
}
