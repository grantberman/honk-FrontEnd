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
    let moc = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    @FetchRequest(entity: Community.entity(), sortDescriptors: []) var communities: FetchedResults<Community>
    
    @EnvironmentObject var appState : AppState
    @EnvironmentObject var user: UserLocal
    @State var makeCommunityViewIsPresented = false
    //@State var updateMessages = false
    
    
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
                    Button (action: {
                        self.makeCommunityViewIsPresented.toggle()
                    }) {
                        Text("Create New Community")
                    }.sheet(isPresented: self.$makeCommunityViewIsPresented){
                        return CreateCommunityView(isPresented: self.$makeCommunityViewIsPresented, sideMenuOpen: self.$menuOpen).environmentObject(self.user).environmentObject(self.appState)
                    }
                }
                else  {
                    
                    VStack{
                        NavigationView {
                            
                            ReverseScrollView {
                                
                                VStack{
                                    if (self.appState.selectedChat != nil) {
                                        ForEach (self.appState.selectedChat?.chatMessages ?? [], id: \.self) { msg in
                                            
                                            VStack{
                                                self.generateChatRow(message: msg)
//                                                ChatRow(chatMessage: msg)
                                            }
                                        }
                                    }

                                }
                                
                            }
                                
                            .navigationBarTitle("\(self.appState.selectedChat?.nameDef ?? "unknown")", displayMode: .inline)
                            .navigationBarItems(leading:
                                Button(action: {
                                    print(self.appState.selectedChat)
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
                            Button(action: {
                                //self.updateMessages.toggle()
                                self.sendMessage()
                                self.composedMessage = ""
                            }) {
                                Text("Send")
                            }.disabled(self.appState.selectedChat == nil)
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
    func generateChatRow(message : Message) -> ChatRow {
        return ChatRow (chatMessage: message)


        
        
        
    }
    
    
    func openMenu() {
        self.menuOpen.toggle()
    }
    

    
    func sendMessage() {
        
        
        let chatUUID = self.appState.selectedChat!.uuidDef
        let authToken = self.user.auth.token
        
        guard let url = URL(string: "http://honk-api.herokuapp.com/api/messages") else {
            print("Invalid URL")
            return
        }
        let body: [String: Any] = ["content" : self.composedMessage, "chat_uuid": chatUUID]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)  //make proper check later
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(self.user.auth.token)", forHTTPHeaderField: "Authorization") //after
        

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            

            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error

                let possibleResponse = response as? HTTPURLResponse
                print(possibleResponse?.statusCode)
                return
            }
            
            guard let data = data  else {
                print(" no data" )
                return
            }
            
            DispatchQueue.main.async{
                
                do {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let jsonString = String(data: data, encoding: .utf8)

                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let message = try decoder.decode(Message.self, from: jsonData!)

                    
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
                    fetchRequest.predicate = NSPredicate(format: "uuid == %@", chatUUID)
                    
                    let fetchedChat = try context.fetch(fetchRequest) as! [Chat]
                    let objectUpdate = fetchedChat[0]
                    let messages = objectUpdate.messages
                    let updatedMessages = messages?.adding(message)
                    objectUpdate.messages = updatedMessages as NSSet?
                    
                    do {
                        try context.save()

                    } catch {
                        print("could not save")
                    }
                } catch {
                    print("could not decode" )
                }
                
            }
            
            return
            
        }.resume()
        
        
    }
    
    
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//            .environmentObject(AppState())
//    }
//}
