//
//  ChatController.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/15/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Combine
import SwiftUI

struct MessageResponse: Codable {
    var uuid : String
    var author : [UserN]
    var content : String
    var created_at : String
    var deliveries : [MessageDelivery]
    var reactions : [ReactionN]
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
            
            if let data = data {
                
                
                //                DispatchQueue.main.async { // Correct
                //                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                //                do {
                //                    let dataJSON = try JSONSerialization.jsonObject(with: data, options: [])
                let jsonString = String(data: data, encoding: .utf8)
                print(jsonString)
                //                    let jsonData = jsonString!.data(using: .utf8)
                //                    let decoder = JSONDecoder()
                //                    //                        decoder.userInfo[CodingUserInfoKey.context!] = context
                //                    let message = try decoder.decode(MessageN.self, from: jsonData!)
                //                    print(message)
                //                } catch {
                //                    print("unable to break down")
                //                }
                
                //                }
                
                
                
                if ( try? JSONDecoder().decode(MessageResponse.self, from: data)) != nil {
                    
                    print("here")
                    do {
                        let message  = try JSONDecoder().decode(MessageResponse.self, from: data) as! MessageResponse
                        print(message)
                    } catch {
                        print("no decode")
                    }
                    
                    
                    
                    
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
                    return
                }
                
            }
            print("bottom")
            //            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
    }
}

struct ChatController_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
