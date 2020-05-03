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
    @FetchRequest(entity: CommunityD.entity(), sortDescriptors: []) var communities: FetchedResults<CommunityD>
    
    @Binding var menuClose: () -> Void
    
    @ViewBuilder
    var body: some View {
        NavigationView {
            
            List {
                ForEach(communities, id: \.id) { community in
                    Text(community.name ?? "unknown")
                    
                }
//                if appState.selectedCommunity != nil {
//
//                    Section(header: Text(self.appState.selectedCommunity!.name)){
//                        ForEach (self.user.communities[0].chats, id: \.self) {
//                            chat in VStack{
//                                Text(chat.name).onTapGesture {
//                                    self.appState.selectedChat = chat
//                                    self.menuClose()
//
//                                }
//                            }
//
//                        }
//                    }
//
//                }
//                else {
//
//                    Button(action: {
//                        print("create community")
//                    }) {
//                        Text("create community")
//                    }
//
//                }

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
