//
//  CreateNewCommunity.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import CoreData


struct CommunityResult: Codable {
    var name: String
    var description: String
    var invite_uuids: [String]?
    var invite_usernames: [String]?
}

struct CreateCommunityView: View {
    @State private var CommunityName = ""
    @State private var CommunityDesription = ""
    @State private var UserList = [String]()
    @State private var Username = ""
    @EnvironmentObject var appState : AppState
    
    //    @ObservedObject var viewRouter: ViewRouter
    @EnvironmentObject var user: UserLocal
    @Binding var isPresented: Bool
    @Binding var sideMenuOpen : Bool
    
    
    var body: some View {
        NavigationView{
            Form {
                Section(header: Text("Community Info"), footer: Text("Required: Community Name and Description")){
                    TextField("Community Name", text: $CommunityName)
                    TextField("Description", text: $CommunityDesription)
                }
                Section(header: Text("Add Members")){
                    VStack{
                        HStack{
                            TextField("Username", text: $Username)
                            Button(action: {
                                self.UserList.append(self.Username)
                                self.Username = ""
                            }){
                                Text("Add user")
                            }.disabled(Username == "")
                        }
                        
                        VStack{
                            
                            List{
                                ForEach(self.UserList, id:\.self){ user in
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
                            self.makeCommunity(self.CommunityName, self.CommunityDesription, self.UserList, self.user.auth.token)
                            
                            
                        }) {
                            Text("Create new Community!")
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Create New Community"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                self.isPresented = false
                self.makeCommunity(self.CommunityName, self.CommunityDesription, self.UserList, self.user.auth.token)
                self.sideMenuOpen = true
            }) {
                Text("Done").bold()
            }.disabled(!self.informationValid()))
        }
    }
    
    
    
    
    
    
    // makes sure that required stuff is in it
    private func informationValid() -> Bool {
        
        if CommunityName.isEmpty{
            return false
        }
        if CommunityDesription.isEmpty{
            return false
        }
        return true
    }
    
    
    //API call to make new community
    private func makeCommunity(_ name: String, _ description: String, _ invite_usernames: [String], _ auth: String){
        
        
        guard let url = URL(string: "https://honk-api.herokuapp.com/api/communities")
            else {
                print("Invalid URL")
                return
        }
        
        let body: [String: Any] = ["name": name, "description": description, "invite_usernames": invite_usernames]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)
        //        Body: {
        //        "name": "Tavern2",
        //        "description": "a place to drink”,
        //        "invite_uuids": [], - optional
        //        "invite_usernames": [] - optional
        //        }
        
        
        //somehow need to create automatic chat with every user in it
        
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
                print ("no data returned")
                return
            }
            
            DispatchQueue.main.async {
                
                do {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let jsonString = String(data: data, encoding: .utf8)
                    print(jsonString)
                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let community = try decoder.decode(Community.self, from: jsonData!)
                    
                    print(community.chatArray[0].inCommunity?.name)
                    self.appState.selectedCommunity = community
                    
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

//struct CreateNewCommunity_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateCommunityView(isPresented: true)
//    }
//}
