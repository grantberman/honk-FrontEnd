//
//  Authentication.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation
import Combine
import SwiftUI

struct AuthenticationResult: Codable {
    var token: String
}

class Authentication: ObservableObject{
    
    var token: String = ""
    @Published var isAuthenticated: Bool = false
    
    func getAuth(_ username: String, _ password: String) {   //after the username and password have been validated as correct, this call gets the users auth token
        //        print(username + " " + password)
        guard let url = URL(string: "http://honk-api.herokuapp.com/api/tokens") else {
            print("Invalid URL")
            return
        }
        print(username + password)
        let loginString = username + ":" + password
        let loginData = loginString.data(using: String.Encoding.utf8)!
        let base64loginString = loginData.base64EncodedString()
        
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("Basic \(base64loginString)", forHTTPHeaderField: "Authorization")
        
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                return
            }
            
            if let data = data {
                if (try? JSONDecoder().decode(AuthenticationResult.self, from: data)) != nil {
                    
                    //                    let group = DispatchGroup()
                    do {
                        let response = try JSONDecoder().decode(AuthenticationResult.self, from: data) as! AuthenticationResult
                        self.token = response.token
                        DispatchQueue.main.async {
                            self.isAuthenticated = true
                            self.writeKeychain(username, password)
                        }
                        
                        
                    } catch {
                        print( "could not get response" )
                    }
                    
                    //                    group.enter()
                    //                    DispatchQueue.main.async {
                    //                        self.isAuthenticated = true
                    ////                        print("true")
                    //                        group.leave()
                    
                    
                    //                    }
                    return
                }
                
            }
            //                    print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            
        }.resume()
        
    }
    
    
    func register(_ username: String, _ password: String, _ email: String) {
        
        
        guard let url = URL(string: "http://honk-api.herokuapp.com/api/users") else {
            print("Invalid URL")
            return
        }
        let body: [String: String] = ["username" : username, "password": password, "email": email]
        
        
        
        let finalBody = try! JSONSerialization.data(withJSONObject: body)  //make proper check later
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = finalBody
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                //                let httpResponse = response as! HTTPURLResponse
                //                print(httpResponse.statusCode)
                return
            }
            
            guard let data = data else {
                print("no data")
                return
            }
            DispatchQueue.main.async{
                
                do {
                    
                    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
                    
                    let jsonString = String(data: data, encoding: .utf8)
                    
                    let jsonData = jsonString!.data(using: .utf8)
                    let decoder = JSONDecoder()
                    decoder.userInfo[CodingUserInfoKey.context!] = context
                    let user = try decoder.decode(User.self, from: jsonData!)
                    print(user)
                    
                    self.isAuthenticated = true
                    self.writeKeychain(username, password)
                    
                    do {
                        try context.save()
                        self.getAuth(username, password)
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
    
    func writeKeychain(_ username : String, _ password: String) {
        
        KeychainWrapper.standard.set(username, forKey: "username")
        KeychainWrapper.standard.set(password, forKey: "password")
    }
}

