//
//  Authentication.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/23/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation
import Combine

struct AuthenticationResult: Codable {
    var token: String
}

class Authentication: ObservableObject{
    
    @Published var token: String = ""
    @Published var isAuthenticated: Bool = false{
        willSet{
            objectWillChange.send()
        }
    }
    
    func getAuth(_ username: String, _ password: String) {   //after the username and password have been validated as correct, this call gets the users auth token
        
        guard let url = URL(string: "http://localhost:5000/api/tokens") else {
            print("Invalid URL")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue(username + ":" + password, forHTTPHeaderField: "Authorization")
        
        
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            
            
            
            guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {     //read possible server error
                
                let httpResponse = response as! HTTPURLResponse
                print(httpResponse.statusCode)
                return
            }
            
            if let data = data {
                if (try? JSONDecoder().decode(AuthenticationResult.self, from: data)) != nil {
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

