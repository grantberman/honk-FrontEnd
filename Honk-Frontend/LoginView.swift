//
//  LoginView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/18/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
//import KeychainWrapper


struct User : Codable {
      var username: String  //should these details be made private or fileprivate?
     var password: String
      var email: String
}


struct LoginView: View {

    @EnvironmentObject var Auth : Authentication
    @ObservedObject var loginViewController = LoginViewController()
    
    

    
    @ViewBuilder
    var body: some View {
        
        if Auth.isAuthenticated {
            ContentView()
            }
            
        
        else {
            
            VStack {
                Group {
                    Text("Honk Inc")
                        .font(.largeTitle).padding(10)
                        .padding([.top, .bottom], 40)
                        .background(Color.red)
                    TextField("Username", text: $loginViewController.user.username)
                        .padding()
                        .cornerRadius(20)
                        .foregroundColor(.black)
                        .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                    SecureField("password", text:$loginViewController.user.password)
                        .padding()
                        .cornerRadius(20)
                        .foregroundColor(.black)
                        .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                    TextField("email", text: $loginViewController.user.email)
                                      .padding()
                                      .cornerRadius(20)
                                      .foregroundColor(.white)
                                      .border(/*@START_MENU_TOKEN@*/Color.gray/*@END_MENU_TOKEN@*/, width: /*@START_MENU_TOKEN@*/4/*@END_MENU_TOKEN@*/)
                    
                }.padding([.leading, .trailing], 27.5)
                
                HStack {
                    Button(action: signIn) {
                        Text("Sign In")
                            .font(.headline)
                            .foregroundColor(.black)
                            .padding()
                            .frame(width: 100, height: 50)
                            .background(Color.green)
                            .cornerRadius(15.0)
                    }

                
                    Button(action: register) {
                      Text("Create Account")
                        .font(.headline)
                        .foregroundColor(.white)
                        .padding()
                        .frame(width: 100, height: 50)
                        .background(Color.green)
                        .cornerRadius(15.0)
                    }
            }
            }
            
            .padding(.top, 26.0)
            
        }
        
        
        
    }
    
    
    func register() {
        loginViewController.Auth = Auth
        loginViewController.register()
    }
    
    func signIn() {
//        loginViewController.Auth = Auth
//        loginViewController.signIn()
    }
}


struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
