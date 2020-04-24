//
//  ChatController.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/15/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Combine
import SwiftUI


struct LoginResult: Codable {
    var email: String
    var id : Int
    var username:  String
}

class LoginViewController : ObservableObject {
    
    var user: User
    var willChange = PassthroughSubject<Void, Never>()
    
    var isValidUser = false {
        willSet{
            getAuthorization()
        }
    }
    var isAuthenticated = false {
        willSet {
            objectWillChange.send()
        }
    }
    
    
    init() {
        self.user = User(username: "", password: "", email: "")
    }
    

    
    func register() {       //this function is called when a user is trying to regsiter a new account

        guard let url = URL(string: "http://localhost:5000/api/users") else {
            print("Invalid URL")
            return
        }
        let body: [String: String] = ["username" : user.username, "password": user.password, "email": user.email]
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)  //make proper check later
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")

        
        URLSession.shared.dataTask(with: request) { data, response, error in
            

            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                return
            }
            
            if let data = data {
                print(data)
                if (try? JSONDecoder().decode(LoginResult.self, from: data)) != nil {      //if successful response
                    DispatchQueue.main.async {

                
                        self.isValidUser = true

                    }
                    return
                }
                
            }
//            print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
            }.resume()
    }
    
    func getAuthorization()  {      //after the username and password have been validated as correct, this call gets the users auth token
        
                guard let url = URL(string: "http://localhost:5000/api/tokens") else {
                    print("Invalid URL")
                    return
                }
                
                var request = URLRequest(url: url)
                request.httpMethod = "POST"
                request.setValue(user.username + ":" + user.password, forHTTPHeaderField: "Authorization")
        
                
                
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")

                
                URLSession.shared.dataTask(with: request) { data, response, error in
                    

                    
                    guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                        
                        let httpResponse = response as! HTTPURLResponse
                        print(httpResponse.statusCode)
                        return
                    }
                    
                    if let data = data {
                        if (try? JSONDecoder().decode(Authentication.self, from: data)) != nil {
                            DispatchQueue.main.async {

                                self.isAuthenticated = true


                            }
                            return
                        }
                        
                    }
//                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
                    
                    }.resume()
        
    }
}
