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
    @EnvironmentObject var user : User
    @EnvironmentObject var appState: AppState
    
    @Environment(\.managedObjectContext) var moc
    @FetchRequest(entity: CommunityN.entity(), sortDescriptors: []) var communities: FetchedResults<CommunityN>
    
    @Binding var menuClose: () -> Void
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            
            List {
                ForEach(communities, id: \.uuid) { community in
                    Section(header: HStack {
                        Text(community.communityName)
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
                                self.menuClose()
                            }
                            }.listStyle(GroupedListStyle())
                            
                            
                        }
                    }
                    
                }


            }
                        .navigationBarTitle("" , displayMode: .inline)

                        .navigationBarHidden(true)
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
