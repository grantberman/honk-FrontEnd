//
//  LoginView.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/18/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import SwiftUI
import CoreData


struct LoginResult: Codable {
    var email: String
    var id : Int
    var username:  String
}



struct LoginView: View {
    

    @EnvironmentObject var user: UserLocal
    @EnvironmentObject var auth: Authentication

    
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
            ContentView()
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
                            .border(Color.gray)
                        SecureField("password", text: $user.password)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.black)
                            .border(Color.gray)
                        TextField("email", text: $user.email)
                            .padding()
                            .cornerRadius(20)
                            .foregroundColor(.black)
                            .border(Color.gray)
                    }.padding([.leading, .trailing], 27.5)



                    HStack {
                        Button(action: signIn) {
                            Text("Sign In")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 175, height: 50)
                                .background(Color.blue)
                                .cornerRadius(5.0)
                        }


                        Button(action: register) {
                            Text("Create Account")
                                .font(.headline)
                                .foregroundColor(.white)
                                .padding()
                                .frame(width: 175, height: 50)
                                .fixedSize(horizontal: true, vertical: false)
                                .background(Color.blue)
                                .cornerRadius(5.0)
                        }//.disabled(isEmailValid())
                    }
                }.onAppear{
                    print("auth" + String(self.user.auth.isAuthenticated))
                }
                .padding(.top, 26.0)
            }
        }
        
    }
    
    func isEmailValid() -> Bool {
        if self.user.email.isEmpty{
            return true
        }
        return false
        
    }
    
    func register() {
        
        self.user.auth.register(user.username, user.password, user.email, user.apns)
        
    }
    
    
    
    func signIn() {
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
        LoginView(isValidUser: false)
            .environmentObject(Authentication())// these are for testing
            .environmentObject(UserLocal())
    }
}


