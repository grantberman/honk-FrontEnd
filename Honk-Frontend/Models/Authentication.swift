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
                        self.isAuthenticated = true
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
}

