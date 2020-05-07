//
//  SceneDelegate.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/14/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import UIKit
import SwiftUI


class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?

    
    var user = (UIApplication.shared.delegate as! AppDelegate).user
    var appState = (UIApplication.shared.delegate as! AppDelegate).appState
    
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Get the managed object context from the shared persistent container.
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
//        readAppState()
//        checkAuth()
        
        
        let validUser = user.auth.isAuthenticated ? true : false     //if authenticated is true then it is a valid user, otherwise, it is not.
        
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        //        let contentView = ContentView().environment(\.managedObjectContext, context)
                let loginView = LoginView(isValidUser: validUser).environment(\.managedObjectContext, context)
        //        let rootView = RootView().environment(\.managedObjectContext, context)

        
        
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            
            window.rootViewController = UIHostingController(rootView: loginView.environmentObject(user).environmentObject(user.auth).environmentObject(appState))
            
            
            //            if validUser {
            //                window.rootViewController = UIHostingController(rootView: contentView.environmentObject(chatController).environmentObject(user).environmentObject(user.auth
            //                ).environmentObject(appState))
            //            }
            //            else {
            //                window.rootViewController = UIHostingController(rootView: loginView.environmentObject(chatController).environmentObject(user).environmentObject(user.auth
            //                ).environmentObject(appState))
            //            }
            
            //            window.rootViewController = UIHostingController(rootView: rootView.environmentObject(user).environmentObject(user.auth))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
        
        //        if appState.selectedChat != nil {
        //            let chat = appState.selectedChat as! ChatN
        //            print(chat.nameDef)
        //            let chatData : Data = try  NSKeyedArchiver.archivedData(withRootObject: appState.selectedChat ?? nil , requiringSecureCoding: false)
        //
        //            UserDefaults.standard.set(chatData, forKey: "chat")
        //        }
        //        print("write to defaults")
        do {
            print("writinG")
            let encoder = JSONEncoder()
            let data = try encoder.encode(appState.selectedCommunity)
                        let userDefaults = UserDefaults.standard

            userDefaults.set(data, forKey: "community")

            print("saved to defaults")
            
        } catch {
            print("could not save defaults")
        }
        //
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        
        
        
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    func checkAuth() {
        
        
        
        let username = KeychainWrapper.standard.string(forKey: "username") ?? ""
        let password = KeychainWrapper.standard.string(forKey: "password") ?? ""
        print(username)
        print(password)
        if username != "" && password != "" {
            //if there are saved credentials
            print("user and pass exist!")
            user.username = username
            user.password = password
            print(username + password)
            print("function call below")
            user.auth.getAuth( username, password )
        }
    }
    
  
    
    
    
}


struct SceneDelegate_Previews: PreviewProvider {
    static var previews: some View {
        /*@START_MENU_TOKEN@*/Text("Hello, World!")/*@END_MENU_TOKEN@*/
    }
}
