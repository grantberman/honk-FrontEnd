//
//  CreateChatView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/6/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import CoreData

struct ChatResult: Codable{
    var name: String
    var community_uuid: String
    var invite_uuids: [String]?
    var invite_usernames: [String]?
}


struct CreateChatView: View {
    
    @State var initList : [String]?
    @State private var chatName : String = ""
    @State private var userList = [String]()
    @State private var username = ""
    
    var communityUUID : String
    @Binding var isPresented: Bool
    
    
    @EnvironmentObject var user: UserLocal
    @EnvironmentObject var appState: AppState

    
    
    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Chat Info"), footer: Text("Required: Chat Name")){
                    TextField("Chat Name", text: $chatName)
                }
                Section(header: Text("Add Members")){
                    VStack{
                        HStack{
                            TextField("Username", text: $username)
                            Button(action: {
                                if (self.initList != nil) {
                                    self.userList.append(self.username)
                                    self.username = ""
                                }
                                else {
                                    self.initList?.append(self.username)
                                    self.username = ""
                                }

                            }){
                                Text("Add user")
                            }.disabled(username == "")
                        }
                        
                        VStack{
                            
                            List{
                                ForEach(self.initList ?? self.userList, id:\.self){ user in
                                    VStack{
                                        Text(user)
                                    }.padding(10)
                                }
                            }
                        }
                    }
                }
                
            }
            .navigationBarTitle(Text("Create New Chat"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
                self.makeChat(self.chatName, self.communityUUID,  self.userList, self.user.auth.token)
            }) {
                Text("Done").bold()
            }.disabled(!self.informationValid()))
        }
        
   
    }
    
    private func informationValid() -> Bool {
        
        if chatName.isEmpty{
            return false
        }
        if initList?.isEmpty  ?? userList.isEmpty{
            return false
        }
        return true
    }
    
    //API call to make new chat
    private func makeChat(_ name: String, _ community_uuid: String, _ invite_usernames: [String], _ auth: String){

        
        


        guard let url = URL(string: "https://honk-api.herokuapp.com/api/chats")
            else {
                print("Invalid URL")
                return
        }
        
        let body: [String: Any] = ["name": name, "community_uuid": community_uuid, "invite_usernames": invite_usernames]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization") //after
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                return
            }
            
            guard let data = data else {
                print ("no data")
                return
            }
            
            DispatchQueue.main.async {
                do {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let jsonString = String(data: data, encoding: .utf8)

                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let chat = try decoder.decode(Chat.self, from: jsonData!)

                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Community")
                    fetchRequest.predicate = NSPredicate(format: "uuid == %@", community_uuid)
                    
                    let fetchedCommunity = try context.fetch(fetchRequest) as! [Community]
                    let objectUpdate = fetchedCommunity[0]
                    let chats = objectUpdate.chats
                    let updatedChats = chats?.adding(chat)
                    objectUpdate.chats = updatedChats as NSSet?
                    self.appState.selectedChat = chat
                    
                    do {
                        try context.save()
                        print("save")
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
//
//struct CreateChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateChatView(is)
//            .environmentObject(AppState())
//            .environmentObject(UserLocal())
//    }
//}
