//
//  MenuView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/30/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//
import SwiftUI

struct MenuContent: View {
    @EnvironmentObject var user : UserLocal
    @EnvironmentObject var appState: AppState
    
    @State var makeChatIsPresented = false
    @State var makeCommunityIsPresented = false
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @FetchRequest(entity: Community.entity(), sortDescriptors: []) var communities: FetchedResults<Community>
    
    @Binding var menuClose: () -> Void
    @Binding var sideMenuIsOpen : Bool
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            
            List {
                ForEach(communities, id: \.uuid) { community in
                    Section(header: HStack {
                        Text(community.communityName).onTapGesture {
                            self.appState.selectedCommunity = community
                            
                            
                            do {
                                
                                let encoder = JSONEncoder()
                                let data = try encoder.encode(community)
                                let string = String(data: data, encoding: .utf8)!
                                let userDefaults = UserDefaults.standard
                                
                                userDefaults.set(community.uuid, forKey: "community")
                                
                                
                            } catch {
                                print("could not save defaults")
                            }
                        }
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        
                        Spacer()
                    }
                    .background(Color.blue)
                    .listRowInsets(EdgeInsets(
                        top: 0,
                        leading: 0,
                        bottom: 0,
                        trailing: 0))
                    ) {
                        ForEach(community.chatArray, id: \.self) { chat in
                            HStack {
                                Button(action: {
                                    self.appState.selectedCommunity = chat.inCommunity
                                    self.appState.selectedChat = chat
                                    let userDefaults = UserDefaults.standard
                                    userDefaults.set(chat.uuid, forKey: "chat")
                                    
                                    self.menuClose()
                                }) {
                                    Text(chat.wrappedName)
                                }
                            }

                            
                        }.listStyle(GroupedListStyle())
                        Button (action: {
                            self.makeChatIsPresented.toggle()
                        }) {
                            Text("Create New Chat")
         
    
                        }.sheet(isPresented: self.$makeChatIsPresented){
                            return CreateChatView(communityUUID: community.uuid!, isPresented: self.$makeChatIsPresented).environmentObject(self.user).environmentObject(self.appState)
                            
                        }
                        
                        
                        
                    }
                    
                    
                }.navigationBarTitle("" , displayMode: .inline)
                    .navigationBarHidden(true)
                
                Button (action: {
                    self.makeChatIsPresented.toggle()
                    print(self.makeChatIsPresented)
                }) {
                    Text("Create New Community")
                    .bold()
                        .foregroundColor(.blue)
                }
            }

            
            
        }.sheet(isPresented: self.$makeChatIsPresented){
            return CreateCommunityView(isPresented: self.$makeChatIsPresented).environmentObject(self.user).environmentObject(self.appState)
            
        }
        //        }
    }
}


struct SideMenu: View {
    let width: CGFloat
    @Binding var sideMenuIsOpen: Bool
    @State var menuClose: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(self.sideMenuIsOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.menuClose()
            }
            
            HStack {
                MenuContent(menuClose: $menuClose, sideMenuIsOpen: self.$sideMenuIsOpen)
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.sideMenuIsOpen ? 0 : -self.width)
                    .animation(.default)
                
                Spacer()
            }
        }
    }
}


struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
