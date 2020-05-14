//
//  InfoView.swift
//  Honk-Frontend
//
//  Created by Nicholas O'Leary on 5/13/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import Combine


struct ReactsResponse: Codable{
    var daily_activity_delta: Int
    var most_active: String
    var weekly_msg_count: Int
}

struct InfoView: View {
    @Binding var isPresented: Bool
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var user: UserLocal
    
    
    @State var dailyActive : String?
    @State var mostActive : String?
    @State var weeklyCount : String?
    
    var body: some View {
        NavigationView{
            
            VStack{
                Text("Statistics")
                    .bold()
                    .font(.title)
                    .padding(20)
                Group{
                    Text("Daily Activity Delta: \(self.dailyActive ?? "")")
                    Text("Most active member:  \(self.mostActive ?? "")")
                    Text("Weekly message count: \(self.weeklyCount ?? "")")
                }.padding(10)
            }.navigationBarTitle(Text("Info"), displayMode: .inline)
                .navigationBarItems(trailing: Button(action: {
                    self.isPresented = false
                }){
                    Text("Done").onTapGesture {
                        self.isPresented = false
                    }
                })
        }.onAppear(perform: {  self.getStats(self.appState.selectedChat!.uuidDef, self.user.auth.token)
        })
        
    }
    
    
    private func getStats(_ chatUUID: String, _ auth: String){
        
        
        guard let url = URL(string: "https://honk-staging.herokuapp.com/api/chats/\(chatUUID)/analytics")
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
                    
                    let jsonString = String(data: data, encoding: .utf8)
                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    let reactsResponse = try decoder.decode(ReactsResponse.self, from: jsonData!)
                    self.mostActive = reactsResponse.most_active
                    self.weeklyCount = String(reactsResponse.weekly_msg_count)
                    self.dailyActive = String(reactsResponse.weekly_msg_count)
                    
                    
                    
                } catch {
                    print("could not decode" )
                }
                
            }
    
            return
            
            
            
        }.resume()
    }
}

