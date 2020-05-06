//
//  CreateChatView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/6/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct ChatResult: Codable{
    var name: String
    var community_uuid: String
    var invite_uuids: [String]?
    var invite_usernames: [String]?
}


struct CreateChatView: View {
    
    @State private var chatName : String = ""
    @State private var userList = [String]()
    @State private var username = ""
    @Binding  var communityUUID : String
    @Binding var isPresented: Bool
    
    
    @EnvironmentObject var user: User
    @EnvironmentObject var appState: AppState
    //    @Environment(\.managedObjectContext) var moc
    //    @FetchRequest(entity: CommunityN.entity(), sortDescriptors: []) var communities: FetchedResults<CommunityN>
    
    
    
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
                                self.userList.append(self.username)
                                self.username = ""
                            }){
                                Text("Add user")
                            }.disabled(username == "")
                        }
                        
                        VStack{
                            
                            List{
                                ForEach(self.userList, id:\.self){ user in
                                    VStack{
                                        Text(user)
                                    }.padding(10)
                                }
                            }
                        }
                    }
                }
                Section {
                    if self.informationValid(){
                        
                        Button(action: {
                            // API call to create new community
                            self.isPresented = false
//                            self.makeCommunity(self.CommunityName, self.CommunityDesription, self.UserList, self.user.auth.token)
                   print("click")
                            
                        }) {
                            Text("Create new Chat!")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Create New Chat"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
                self.makeChat(self.chatName, self.communityUUID,  self.userList, self.user.auth.token)
            }) {
                Text("Next").bold()
            }.disabled(!self.informationValid()))
        }
//
    }
    // makes sure that required stuff is in it
    private func informationValid() -> Bool {
        
        if chatName.isEmpty{
            return false
        }
        if userList.isEmpty{
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
            
            if let data = data {
                if (try? JSONDecoder().decode(CommunityResult.self, from: data)) != nil {
                    do{
                        let chatResponse = try JSONDecoder().decode(ChatResult.self, from: data)
                        print(chatResponse)
                    }catch{
                        print("could not decode chatResponse")
                    }
                    
                    return
                }
                
            }
            //                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
    
}
//
//struct CreateChatView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateChatView(is)
//            .environmentObject(AppState())
//            .environmentObject(User())
//    }
//}
