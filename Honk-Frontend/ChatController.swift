//
//  ChatController.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/15/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Combine
import SwiftUI
import CoreData

struct MessageResponse: Codable {
    var uuid : String
    var author : UserResponse
    var content : String
    var created_at : String
    var deliveries : [MessageDeliveryResponse]
    var reactions : [ReactionResponse]
}


struct MessageDeliveryResponse : Codable {
    var is_delivered : Bool?
    var uuid: String?
    var recipient : UserResponse?
}

struct ReactionResponse : Codable {
    var reaction_type: String?
    var uuid: String?
    var deliveries: [ReactionDeliveryResponse]?
    var reactor: UserN?
}

struct ReactionDeliveryResponse : Codable {
    var is_delivered : Bool?
    var uuid: String?
    var reaction: ReactionN?
    var recipient : UserN?
}
struct UserResponse : Codable {
    var biography: String?
    var created_at: String?
    var display_name : String?
    var username: String?
    var uuid: String?
}

struct Result: Codable {
    var id : Int
    var chat : String
    var author:  String
    var created_at : String
    var content : String
    
}

class ChatController : ObservableObject {
    @Environment(\.managedObjectContext) var moc
    
    @EnvironmentObject var user: User
    
    @Published var messages = [
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue),
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue),
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue),
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue),
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue),
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue)
        
        
    ]
    
    func sendMessage(_ content: String, _ chatUUID : String, _ auth: String) {
        //        messages.append(chatMessage)
        //        willChange.send()
        
        
        guard let url = URL(string: "http://honk-api.herokuapp.com/api/messages") else {
            print("Invalid URL")
            return
        }
        let body: [String: Any] = ["content" : content, "chat_uuid": chatUUID]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)  //make proper check later
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer \(auth)", forHTTPHeaderField: "Authorization") //after
        
        //        print(request.allHTTPHeaderFields)
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            //             guard let data = data else { return }
            //            if let finalData = try? JSONDecoder().decode(Result.self, from:data) {
            //                print(finalData)
            //            }
            //            //            print(finalData ?? error?.localizedDescription ?? "Unknown error")
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                //                print("Server error! ")
                //                print(response ?? HTTPURLResponse())
                let suck = response as? HTTPURLResponse
                print(suck?.statusCode)
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
                    print(jsonString)
                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let message = try decoder.decode(MessageN.self, from: jsonData!)
                    print(message)
                    
                    let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatN")
                    fetchRequest.predicate = NSPredicate(format: "uuid == %@", chatUUID)
                    
                    let fetchedChat = try context.fetch(fetchRequest) as! [ChatN]
                    let objectUpdate = fetchedChat[0]
                    let messages = objectUpdate.messages
                    let updatedMessages = messages?.adding(message)
                    objectUpdate.messages = updatedMessages as NSSet?
                    
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



//                do {
//                    print("here")
//
//                    let message  = try JSONDecoder().decode([MessageN].self, from: jsonData!)
//                    print(message)
//                } catch {
//                    print("no decode")
//                }
//


//                if let data = data {
//
//
//                    let chat  = try decoder.decode(MessageN.self, from: jsonData!)
//                    print(chat)
//                    try context.save()



//                DispatchQueue.main.async {
//
//                }
//                //                DispatchQueue.main.async { // Correct
//                //                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//                //                do {
//                //                    let dataJSON = try JSONSerialization.jsonObject(with: data, options: [])
//                let jsonString = String(data: data, encoding: .utf8)
//                print(jsonString)
//                    let jsonData = jsonString!.data(using: .utf8)
//                    let decoder = JSONDecoder()
//                    //                        decoder.userInfo[CodingUserInfoKey.context!] = context
//                    let message = try decoder.decode(MessageN.self, from: jsonData!)
//                    print(message)
//                } catch {
//                    print("unable to break down")
//                }

//                }






//                    DispatchQueue.main.async {
//                        //update UI here
//                        do {
//                            let decoder = JSONDecoder()
//                            let message  = try decoder.decode(MessageN.self, from: data)
//                            print("here")
//
//                        } catch {
//                            print("unable to parse message response object")
//                        }
//
//                        print(decodedResponse)
//                        print("success!")
//self.results = decodedResponse.results
//                        self.messages.append(chatMessage)
//                        self.willChange.send()
//                        self.willChange.send(self)
//                    }


struct ChatController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
