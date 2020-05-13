//
//  AppDelegate.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 4/14/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications
import SwiftUI



@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate{
    
    var user = UserLocal()
    var appState = AppState()
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        readAppState()
        registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
        
        let notificationOption = launchOptions?[.remoteNotification]
        
        
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
        if appState.selectedCommunity != nil{
            
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
        }
        
        
        
        
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation o f the store to fail.
         */
        let container = NSPersistentContainer(name: "Honk_Frontend")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            container.viewContext.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        
        return container
    }()
    
    
      func readAppState() {
          print("reading")
          if let data = UserDefaults.standard.data(forKey: "community"){
              
              do {
                  let decoder = JSONDecoder()
                  
                  let community = try decoder.decode(Community.self, from: data)
                  print(community)
              
     
                  
                  
              } catch {
                  print("did not decode")
              }
              
          }
          
          
          
      }
      
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    
    
    func application(
        _ application: UIApplication,
        didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
    ) {
        let tokenParts = deviceToken.map { data in String(format: "%02.2hhx", data) }
        let token = tokenParts.joined()
        user.apns = token
        print("Device Token: \(token)")
    }
    
    func application(
        _ application: UIApplication,
        didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Failed to register: \(error)")
    }
    
    
    func registerForPushNotifications() {
        UNUserNotificationCenter.current()
            .requestAuthorization(options: [.alert, .sound, .badge]) {
                [weak self] granted, error in
                
                print("Permission granted: \(granted)")
                guard granted else { return }
                self?.getNotificationSettings()
        }
    }
    
    func getNotificationSettings() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            print("Notification settings: \(settings)")
            guard settings.authorizationStatus == .authorized else { return }
            DispatchQueue.main.async {
                UIApplication.shared.registerForRemoteNotifications()
            }
            
        }
    }
    
    /*
     * didReceiveRemoteNotification
     * Handles background data fetches from server triggered by remote notifications
     */
    func application(_ application: UIApplication,
                     didReceiveRemoteNotification userInfo: [AnyHashable : Any]) {
        
        // Create a decoder object and get the category of the notification
        let decoder = JSONDecoder()
        let aps = userInfo["aps"] as! NSDictionary
        let category = aps["category"] as! NSString
        
        // Register a background test so the cases can be run and data updated accordingly
        let taskID = UIApplication.shared.beginBackgroundTask(expirationHandler: {
            NSLog("Background task expired handler called")
        })
        
        // Declare context so saves to CoreData can be made
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        switch category {
        
            /*
             * In the case of new message notifications, we will request all unread messages from the unread endpoint
             */
            case "new_message":
                
                // Get the URL for the request
                guard let url = URL(string: "https://honk-staging.herokuapp.com/api/messages/unread")
                  else {
                      print("Invalid URL")
                      return
                  }
                
                // Create the request object and set its parameters
                var request = URLRequest(url: url)
                request.httpMethod = "GET"
                request.setValue("Bearer \(user.auth.token)", forHTTPHeaderField: "Authorization")
                request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                
                //  Issue the URL Request
                URLSession.shared.dataTask(with: request) { data, response, error in
                    guard let httpResponse = response as? HTTPURLResponse,
                      (200...299).contains(httpResponse.statusCode) else {
                          let httpResponse = response as! HTTPURLResponse
                          print(httpResponse.statusCode)
                          return
                    }

                    guard let data = data else {
                      print("no data")
                      return
                    }
                    
                    // Parse the URL Request response and save new messages to core data
                    DispatchQueue.main.async {
                        do {
                           
                            do {
                                // Serialize the String response as json
                                let jsonResponse = try JSONSerialization.jsonObject(with: data, options: [])
                              
                                // Convert the json to a jsonarray
                                guard let jsonArray = jsonResponse as? [[String: Any]] else {
                                    print("conversion to jsonarray failed")
                                    return
                              }
                              
                              // Iterate through the json array and attach messages to proper chat UUIDs
                              for element in jsonArray {
                                  
                                  // Get the chat UUID for the message
                                  guard let chatUUID = element["chat_uuid"] as? String else {
                                      print("No chat_uuid provided by unread messages endpoint")
                                      return
                                  }
                                  
                                  // Fetch the chat from CoreData
                                  let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Chat")
                                  fetchRequest.predicate = NSPredicate(format: "uuid == %@", chatUUID)
                                  let fetchedChat = try context.fetch(fetchRequest) as! [Chat]
                                  let objectUpdate = fetchedChat[0]
                                  let messages = objectUpdate.messages
                                  
                                  guard let messageVal = element["message"] else {
                                      print("No message element provided in unread messages endpoint response")
                                      return
                                  }
                                  
                                  // Convert message to proper data type for decoding
                                  let messageDict = messageVal as! NSDictionary
                                  guard let messageUUIDRaw = messageDict["uuid"] else {return}
                                  let messageUUID = messageUUIDRaw as! String
                                  
                                  do {
                                        let messageJSON = try JSONSerialization.data(withJSONObject: messageDict, options: [])
                                        let messageString = String(data: messageJSON, encoding: .utf8)
                                        let decodableMessage = messageString!.data(using: .utf8)
                                        decoder.userInfo[CodingUserInfoKey.context!] = context
                                        let message = try decoder.decode(Message.self, from: decodableMessage!)
                                      
                                        let updatedMessages = messages?.adding(message)
                                        objectUpdate.messages = updatedMessages as NSSet?
                                      
                                        do {
                                            try context.save()
                                          
                                            // Construct a PUT request to mark the message as read on the server
                                            guard let url = URL(string: "https://honk-staging.herokuapp.com/api/messages/\(messageUUID)") else { return }
                                            var request = URLRequest(url: url)
                                            request.httpMethod = "PUT"
                                            request.setValue("Bearer \(self.user.auth.token)", forHTTPHeaderField: "Authorization")
                                            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                                            let bodyDict: [String: String] = ["is_delivered": "True"]
                                            let body = try! JSONSerialization.data(withJSONObject: bodyDict)
                                            request.httpBody = body
                                            
                                            // Issue the PUT request
                                            URLSession.shared.dataTask(with: request) {data, response, error in
                                                guard let httpResponse = response as? HTTPURLResponse, (200...299).contains(httpResponse.statusCode) else {
                                                    print("could not make delivery PUT request")
                                                    return
                                                }
                                            }.resume()
                                        
                                        } catch {
                                            print("could not save new message")
                                      }
                                      
                                  }
                                  catch {
                                      print("message decoding failure")
                                  }
                              }
                             UIApplication.shared.endBackgroundTask(taskID)
                          }
                          catch {
                              print("Request decoding failed")
                          }
                      }
                  }
                }.resume()
            
            // Default case for a not listed category type
            default:
                break
            
            
        }
       
    }
    

    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        //        guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
        //            return
        //        }
        
        print("did receive" )
        
        
        //        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        //        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        //
        //
        //        let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
        //
        //
        //
        //        let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
        //        sceneDelegate?.window = window
        //        window?.makeKeyAndVisible()
        //
        //
        
        
        // tell the app that we have finished processing the user’s action / response
        
        completionHandler()
    }
    
    
    
    // tell the app that we have finished processing the user’s action / response
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        
        
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to read managed object context.")
        }
        
        print("will present")
        
        let decoder = JSONDecoder()
        
        switch notification.request.content.categoryIdentifier {
   
            
            
            
        case "new_chat":
            
            
            let messageJSON = notification.request.content.userInfo["chat"] as! NSDictionary
            //1. create message object
            do {
                let data = try JSONSerialization.data(withJSONObject: messageJSON, options: [])
                let jsonString = String(data: data, encoding: .utf8)
                let jsonData = jsonString!.data(using: .utf8)
                
                
                decoder.userInfo[CodingUserInfoKey.context!] = context
                let chat  = try decoder.decode(Chat.self, from: jsonData!)
                
                
                let communityUUID = notification.request.content.userInfo["community_uuid"] as! String
                let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Community")
                fetchRequest.predicate = NSPredicate(format: "uuid == %@", communityUUID)
                
                
                let fetchedCommunity = try context.fetch(fetchRequest) as! [Community]
                print(fetchedCommunity)
                
                let objectUpdate = fetchedCommunity[0]
                let chats = objectUpdate.chats
                let updatedChats = chats?.adding(chat)
                objectUpdate.chats = updatedChats as NSSet?
                try context.save()
                print("saved")
                
            } catch {
                print("could not add new chat to community" )
            }
            
            
            
            
        case "new_community":
            print(notification.request.content.userInfo["community"])
            let messageJSON = notification.request.content.userInfo["community"] as! NSDictionary
            //1. create message object
            do {
                let data = try JSONSerialization.data(withJSONObject: messageJSON, options: [])
                let jsonString = String(data: data, encoding: .utf8)
                //                print(jsonString)
                let jsonData = jsonString!.data(using: .utf8)
                
                
                decoder.userInfo[CodingUserInfoKey.context!] = context
                let community  = try decoder.decode(Community.self, from: jsonData!)
                print(community)
                try context.save()
                
            } catch {
                print("could not add new chat to community" )
            }
            
            
            
        default:
            break
        }
        //        print(notification.request.content.categoryIdentifier)
        //        let notifInfo = notification.request.content.userInfo
        //
        //        if let notifBody = notifInfo["aps"] as? [String:AnyObject] {
        //            print(notifBody)
        //        }
        //        print("here")
        completionHandler([.alert, .badge, .sound])
    }
    
    
}

