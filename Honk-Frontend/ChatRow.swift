//
//  ChatRow.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

struct reactResult: Codable {
    var reaction_type: String
    var reactor: String
    var reactor_uuid: String
}

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}

struct ChatRow: View {
    var chatMessage: MessageN
    @EnvironmentObject var user: User
   
    
    var body: some View{
        
        let today = Date()
        let dateString = DateFormatter()
        dateString.dateFormat = "HH:mm E, d MMM y"
        
        // I think will have to do a get call somewhere if we don't want the date to display if the same one did on the last text
        
        
        return Group {
            if chatMessage.authorDef.usernameDef != user.username{
               
                VStack{
                    Group{ // originally had this in the Vstack although it didn't orient correctly, moved back we'll see
                        Text(dateString.string(from:today))
                            .frame(maxWidth: .infinity, alignment: .center)
                        .padding(5)
                        }
                    HStack {
                        Group {
                             Text(chatMessage.avatar)
                                .padding(.leading, 5)
                                .frame(alignment: .leading)
                             Text(chatMessage.contentDef)
                                 .bold()
                                 .foregroundColor(.white)
                                 .padding(10)       //comment this out to 
//                                 .background(chatMessage.color)
                                 .cornerRadius(10)
                            
                            
                                 .fixedSize(horizontal: false, vertical: true)
                                 .frame(minWidth: 10, maxWidth: 300,  alignment: .leading)
                                 .contextMenu{
                                    Button(action: self.reactToMessage("Like", self.user.name, self.user.uuid, self.user.auth.token)){
                                        HStack{
                                            Text("Like")
                                            Image("thumbs-up")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                        }
                                    }.frame(alignment: .leading)
                                    
                                    Button(action: self.createSubChat){
                                        
                                        HStack{
                                            Text("Create sub chat")
                                            Image("sub-group")
                                            .renderingMode(.original)
                                            .resizable()
                                            .scaledToFit()
                                        }
                                    }
                             }
                            Spacer()
                        }
                        
                    }
                }
            } else {
                VStack{
                    Group{
                        Spacer()
                        Text(dateString.string(from:today))
                            .frame(maxWidth: .infinity, alignment: .center)
                            .padding(5)
                    }
                    HStack {
                        Group {
                            Spacer()
                            Text(chatMessage.contentDef)
                                .bold()
                                .foregroundColor(.white)
                                .padding(10)
//                                .background(chatMessage.color)
                                .cornerRadius(10)
                                .fixedSize(horizontal: false, vertical: true)
                                .frame(minWidth: 10, maxWidth: 250, alignment: .bottomTrailing)
                            Text(chatMessage.avatar)
                                .padding(.trailing, 5)
                            
                        }
                    }
                }
            }
        }
    }
    private func reactToMessage(_ reaction_type: String, _ reactor: String, reactor_uuid: String, _ auth: String){
        // in here will be the API call to like
        
        //JSON example
//        "reactions": [
//            {
//                "deliveries": [
//                    {
//                        "is_delivered": false,
//                        "uuid": "1a4337fd4ad94de9beb867b7cd2f05ae"
//                    },
//                    {
//                        "is_delivered": true,
//                        "uuid": "0c46b7c5373f4db8a4b23033e2174b89"
//                    }
//                ],
//                "reaction_type": "like",
//                "reactor": "grant",
//                "reactor_uuid": "1baaf9d0caa547cea4d3bfddbd4e208f",
//                "uuid": "4412070f0d3d47ce8f7f02030146b0a0"
//            }
//        ],
        
        guard let url = URL(string: "https://honk-api.herokuapp.com/api/reactions")
                else {
                    print("Invalid URL")
                    return
            }
            
            let body: [String: Any] = ["reaction_type": reaction_type, "reactor": reactor, "reactor_uuid": reactor_uuid]
            
            let finalBody = try! JSONSerialization.data(withJSONObject: body)
            
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
                        let reaction = try decoder.decode(ReactionN.self, from: jsonData!)
                        print(reaction)
                        //self.reactionUUID = reaction.uuidDef
                        
                        
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

        
    
    func createSubChat(){
        // in here will be API call to create new subgroup
    }
}
//
//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
////        ChatRow(chatMessage: ChatMessage(message: "This is a long message test Im not sure what will happen with it and we need to see what happens", avatar: "B", color: .blue)).previewDevice("iPhone 8")
//        //ChatRow(chatMessage: )
//    }
//}









