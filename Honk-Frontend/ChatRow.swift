//
//  ChatRow.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI

extension Date {
    func currentTimeMillis() -> Int64 {
        return Int64(self.timeIntervalSince1970 * 1000)
    }
}


struct ChatRow: View {
    var chatMessage: Message
    @EnvironmentObject var user: UserLocal
    
    var isMe : Bool  = false
    //        return chatMessage.authorDef.usernameDef == self.user.username
    //
    //    }
    
    
    var body: some View{
        
        let today = Date()
        let dateString = DateFormatter()
        dateString.dateFormat = "HH:mm E, d MMM y"
        
        // I think will have to do a get call somewhere if we don't want the date to display if the same one did on the last text
        
        
        return Group {
            //GeometryReader { geometry in
                if self.chatMessage.author?.usernameDef != self.user.username{
                    //            if isMe{
                    VStack{
                        HStack {
                            Group {
                                Text(self.chatMessage.avatar)
                                    .padding(.leading, 5)
                                    .frame(alignment: .leading)
                                Text(self.chatMessage.contentDef)
                                    
                                    .bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                    .padding(10)
                                    .foregroundColor(.white)
                                    .background(Color.blue)
                                
                                                                            //comment this out to
                                    //                                 .background(chatMessage.color)
                                    .cornerRadius(10)
                                    
                                    
                                    
                                    .frame(minWidth: 10, maxWidth: 300,  alignment: .leading)
//                                    .padding(10)
                                    .contextMenu{
                                        Button(action: { self.reactToMessage){
                                            HStack{
                                                Text("Like")
                                                Image("thumbs-up")
                                                    .renderingMode(.original)
                                                    .resizable()
                                                    .scaledToFit()
                                            }
                                        }.frame(alignment: .leading)
                                        }
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
//                                if (hasLikes){
//                                    Image("thumbs-up")
//                                }
                                Spacer()
                            }
//                        }.onTapGesture {
//                            print(self.chatMessage.author?.usernameDef)
//                            print(self.user.username)
                        }
                    }
                } else {
                    VStack{
                        
                        HStack {
                            Group {
                                Spacer()
                                Text(self.chatMessage.contentDef)
//                                    .bold()
//                                    .foregroundColor(.white)
//                                    .padding(10)
//                                    .background(Color.green)
//                                    .cornerRadius(10)
                                    
                                .bold()
                                    .fixedSize(horizontal: false, vertical: true)
                                .padding(10)
                                    .foregroundColor(.white)
                                    .background(Color.green)
                                .cornerRadius(10)
//                                    .frame(minWidth: 10, maxWidth: 250, alignment: .bottomTrailing)
                                
                                Text(self.chatMessage.avatar)
                                    .padding(.trailing, 5)
                                
                            }
                        }.frame(alignment: .bottomTrailing)
//                            .onTapGesture {
//                            print(self.chatMessage.author?.usernameDef)
//                            print(self.user.username)
//                        }
                    }
                }
            //}
            //.frame(maxWidth: 500)
//            .padding(50)
        }
    }
    
        public func reactToMessage(_ reaction_type: String,  _ auth: String, _ message_uuid: String){
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
            
            guard let url = URL(string: "https://honk-api.herokuapp.com/api/messages/\(message_uuid)/reactions")
                    else {
                        print("Invalid URL")
                        return
                }
                
                let body: [String: Any] = ["reaction_type": reaction_type]
                
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
                            let reaction = try decoder.decode(Reaction.self, from: jsonData!)
                            print(reaction)
                            //self.reactionUUID = reaction.uuidDef
                            
                            let fetchRequest = FetchRequest<NSFetchRequestResult>(entityName: "MessageN")
                            fetchRequest.predicate = NSPredicate(format: "uuid == %@", message_uuid)
                            
                            let fetchedChat = try context.fetch(fetchRequest) as! [MessageN]
                            let objectUpdate = fetchedChat[0]
                            let reactions = objectUpdate.reactions
                            let updatedReactions = reactions?.adding(reaction)
                            objectUpdate.reactions = updatedReactions as NSSet?
                            
                            
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
    func getReactions(){
        // this is the API call to get the likes to display them
    }
}



//
//struct ChatRow_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRow(chatMessage: ChatMessage(message: "This is a long message test Im not sure what will happen with it and we need to see what happens", avatar: "B", color: .blue)).previewDevice("iPhone 8")
//    }
//}
//








