//
//  InfoView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/13/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import Combine

class ReactsObject: ObservableObject {
    var daily_activity_delta: Int = -1
    var most_active: String = ""
    var weekly_msg_count: Int = -1
}

struct ReactsResponse: Codable{
    var daily_activity_delta: Int
    var most_active: String
    var weekly_msg_count: Int
}

struct InfoView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var user: UserLocal
    @ObservedObject var reacts = ReactsObject()
    
    var body: some View {
        NavigationView{
                
            VStack{
                Text("Statistics")
                .bold()
                .font(.title)
                .padding(20)
                Group{
                    Text("Daily Activity Delta: " + String(self.reacts.daily_activity_delta))
                    Text("Most active member:  \(self.reacts.most_active)")
                    Text("Weekly message count: " + String(describing: self.reacts.weekly_msg_count))
                }.padding(10)
            }.navigationBarTitle(Text("Info"), displayMode: .inline)
            .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                }){
                    Text("Done")
                })
        }.onAppear(perform: {  self.getStats(self.appState.selectedChat!.uuidDef, self.user.auth.token)
            })
            
    }
    
    
    private func getStats(_ chatUUID: String, _ auth: String){
        
        
        guard let url = URL(string: "https://honk-api.herokuapp.com/api/chats/\(chatUUID)/analytics")
                   else {
                       print("Invalid URL")
                       return
               }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
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
                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let reactsResponse = try decoder.decode(ReactsResponse.self, from: jsonData!)
                    print(reactsResponse)
                    self.reacts.daily_activity_delta = reactsResponse.daily_activity_delta
                    self.reacts.most_active = reactsResponse.most_active
                    self.reacts.weekly_msg_count = reactsResponse.weekly_msg_count
                    
//                    do {
//                        try context.save()
//                        print("save")
//                    } catch {
//                        print("could not save")
//                    }
                } catch {
                    print("could not decode" )
                }
                
            }
            
           
            
          
            
            
            
//            DispatchQueue.main.async {
//
//                do {
//
////                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
////
////                    let jsonString = String(data: data, encoding: .utf8)
////
////                    let jsonData = jsonString!.data(using: .utf8)
////                    let decoder = JSONDecoder()
////                    decoder.userInfo[CodingUserInfoKey.context!] = context
////                    let community = try decoder.decode(Community.self, from: jsonData!)
////
////
////                    self.appState.selectedCommunity = community
//
//                    do {
//                        //try context.save()
//                        print("save")
//                    } catch {
//                        print("could not save")
//                    }
//                } catch {
//                    print("could not decode" )
//                }
//
//            }
            
            return
            
            
        
        }.resume()
    }
}

