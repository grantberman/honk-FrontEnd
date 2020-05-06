//
//  LoginView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/18/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
//import KeychainWrapper


struct LoginResult: Codable {
    var email: String
    var id : Int
    var username:  String
}



struct LoginView: View {
    
    @EnvironmentObject var user: User
    @EnvironmentObject var auth: Authentication
    @ObservedObject var viewRouter: ViewRouter

    
    @State var isValidUser : Bool  = false {
        willSet{
            writeKeychain()
            print(user.username + " " + user.password)
            auth.getAuth(user.username, user.password)
        }
    }
    
    
    
    @ViewBuilder
    var body: some View {
        
        
        if auth.isAuthenticated{
            ContentView(viewRouter: viewRouter)
        }
        else {
            ZStack{
                //            Color.white.edgesIgnoringSafeArea(.all)
                // so we can change background color if we want
                
                VStack {
                    Group{
                        Image("Honk-Icon")
                            .resizable()
                            .renderingMode(.original)
                            .scaledToFit()
                        Text("Honk Inc")
                            .bold()
                            .font(.largeTitle)
                        TextField("Username", text: $user.username)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.black)
                            .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                        
                        SecureField("password", text: $user.password)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.black)
                            .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                        
                        TextField("email", text: $user.email)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.white)
                            .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                    }.padding([.leading, .trailing], 27.5)
                    
                    
                    
                    HStack {
                        Button(action: signIn) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 175, height: 50)
                                .background(Color.blue)
                                .cornerRadius(15.0)
                        }
                        
                        
                        Button(action: register) {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 175, height: 50)
                                .fixedSize(horizontal: true, vertical: false)
                                .background(Color.blue)
                                .cornerRadius(15.0)
                        }
                    }
                }.onAppear{
                    print("auth" + String(self.user.auth.isAuthenticated))
                }
                .padding(.top, 26.0)
            }
        }
        
    }
    
    
    
    func register() {
        
        guard let url = URL(string: "http://honk-api.herokuapp.com/api/users") else {
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
                
                //                let httpResponse = response as! HTTPURLResponse
                //                print(httpResponse.statusCode)
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
            
        }.resume()}
    
    func signIn() {
        self.viewRouter.currentPage = "page2"
        self.user.auth.getAuth(user.username, user.password)
    }
    
    
    func writeKeychain() {
        let username = user.username
        let password = user.password
        
        KeychainWrapper.standard.set(username, forKey: "username")
        KeychainWrapper.standard.set(password, forKey: "password")
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView(viewRouter: ViewRouter(), isValidUser: false)
            .environmentObject(Authentication())// these are for testing
            .environmentObject(User())
    }
}


