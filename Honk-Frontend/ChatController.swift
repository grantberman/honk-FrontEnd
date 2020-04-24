//
//  ChatController.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/15/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Combine
import SwiftUI

struct Response: Codable {
    var results: [Result]
}

struct Result: Codable {
    var id : Int
    var chat : String
    var author:  String
    var created_at : String
    var content : String
  
}

class ChatController : ObservableObject {
    
    var willChange = PassthroughSubject<Void, Never>()
    
    
    @State private var results = [Result]()
    
    @Published var messages = [
        ChatMessage(message: "Hey honk team, I am a text message that does not go too far over to the right side of the screen. This is very exciting.", avatar: "A", color: .red),
        ChatMessage(message: "Hi", avatar: "B", color: .blue)
        

    ]
    
    func sendMessage(_ chatMessage: ChatMessage) {
//        messages.append(chatMessage)
//        willChange.send()
        

        guard let url = URL(string: "http://localhost:5000/api/messages") else {
            print("Invalid URL")
            return
        }
        let body: [String: Any] = ["content" : chatMessage.message, "chat_id": 1]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)  //make proper check later
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.setValue("Bearer sqfOEOYpMfYMSTYxOOqAwQky4XOSr8r8", forHTTPHeaderField: "Authorization") //after
        
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
                if let decodedResponse = try? JSONDecoder().decode(Result.self, from: data) {
                    DispatchQueue.main.async {
                        //update UI here
                        print(decodedResponse)
                        print("success!")
                        //self.results = decodedResponse.results
                        self.messages.append(chatMessage)
                        self.willChange.send()
//                        self.willChange.send(self)
                    }
                    return
                }
                
            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            }.resume()
    }
}
