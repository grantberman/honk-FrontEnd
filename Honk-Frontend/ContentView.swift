//
//  ContentView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/14/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import CoreData

struct ContentView: View {
    
    @State var composedMessage: String = ""
    @State var menuOpen: Bool = false
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CommunityN.entity(), sortDescriptors: []) var communities: FetchedResults<CommunityN>

    @EnvironmentObject var appState : AppState
    @EnvironmentObject var chatController : ChatController
    @EnvironmentObject var user: User
    
    
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
                
                    VStack{
                        NavigationView {
                            ReverseScrollView {
                                
                                VStack{
                                    ForEach (self.appState.selectedChat?.chatMessages ?? [], id: \.self) { msg in
                                        VStack{
                                            ChatRow(chatMessage: msg)
                                        }
                                    }
                                }
                                .navigationBarTitle("\(self.appState.selectedChat?.nameDef ?? "unknown")", displayMode: .inline)
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
                            }.disabled(self.appState.selectedChat == nil)
                        }
                        .padding()
                        .keyBoardAdaptive()
                        
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

        chatController.sendMessage(composedMessage, self.appState.selectedChat!.uuidDef, self.user.auth.token)
        composedMessage = ""
    }
    
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(ChatController()).environmentObject(AppState())
    }
}
