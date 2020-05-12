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
    
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @FetchRequest(entity: Community.entity(), sortDescriptors: []) var communities: FetchedResults<Community>
    
    @Binding var menuClose: () -> Void
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            
            List {
                ForEach(communities, id: \.uuid) { community in
                    Section(header: HStack {
                        Text(community.communityName).onTapGesture {
                            self.appState.selectedCommunity = community
//                            print("community selected")

                            do {
//                                print("writing community")
                                let encoder = JSONEncoder()
                                let data = try encoder.encode(community)
                                let string = String(data: data, encoding: .utf8)!
                                let userDefaults = UserDefaults.standard
                                
                                userDefaults.set(community.uuid, forKey: "community")
                                
//                                print("saved to defaults")
                                
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
                        ForEach(community.chatArray, id: \.self) { chat in VStack {
                            Text(chat.wrappedName).onTapGesture {
                                self.appState.selectedChat = chat
                                let userDefaults = UserDefaults.standard
                                userDefaults.set(chat.uuid, forKey: "chat")
//                                print(chat)
//                                do {
//
//                                    let encoder = JSONEncoder()
//                                    let data = try encoder.encode(chat)
//                                    let string = String(data: data, encoding: .utf8)!
//
//                                    let userDefaults = UserDefaults.standard
//                                    userDefaults.set(data, forKey: "chat")
//                                    
//                                    print("saved to defaults")
//                                    
//                                } catch {
//                                    print("could not save defaults")
//                                }
                                self.menuClose()
                            }
                            }.listStyle(GroupedListStyle())
                            
                            
                            
                        }
                        Button (action: {
                            self.makeChatIsPresented.toggle()
                        }) {
                            Text("Create New Chat")
                        }.sheet(isPresented: self.$makeChatIsPresented){
                            return CreateChatView(communityUUID: self.appState.selectedCommunity!.uuidDef, isPresented: self.$makeChatIsPresented).environmentObject(self.user).environmentObject(self.appState)
                    }
                    

                    
                }


                }
            
                        .navigationBarTitle("" , displayMode: .inline)

                        .navigationBarHidden(true)
            }
        
        
        }
    }
}


struct SideMenu: View {
    let width: CGFloat
    let isOpen: Bool
    @State var menuClose: () -> Void
    
    var body: some View {
        ZStack {
            GeometryReader { _ in
                EmptyView()
            }
            .background(Color.gray.opacity(0.3))
            .opacity(self.isOpen ? 1.0 : 0.0)
            .animation(Animation.easeIn.delay(0.25))
            .onTapGesture {
                self.menuClose()
            }
            
            HStack {
                MenuContent(menuClose: $menuClose)
                    .frame(width: self.width)
                    .background(Color.white)
                    .offset(x: self.isOpen ? 0 : -self.width)
                    .animation(.default)
                
                Spacer()
            }
        }
    }
}

//struct SideMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        SideMenu(width: 200, isOpen: true, menuClose: () -> Void)
//
//    }
//}

struct SideMenu_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
