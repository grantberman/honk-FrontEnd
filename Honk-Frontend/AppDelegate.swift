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
    

    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        

        registerForPushNotifications()
        UNUserNotificationCenter.current().delegate = self
//        print("set")
        
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
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
      print("notif")
      guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
          return
      }


      let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy
        
      let notificationView = NotificationTestView().environment(\.managedObjectContext, context)

      let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
      window?.rootViewController = UIHostingController(rootView: notificationView)


      let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
      sceneDelegate?.window = window
      window?.makeKeyAndVisible()




      // tell the app that we have finished processing the user’s action / response

        completionHandler()
    }

      
        
      // tell the app that we have finished processing the user’s action / response
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions)
        -> Void) {
        
        
        
        guard let context = (UIApplication.shared.delegate as? AppDelegate)?.persistentContainer.viewContext else {
            fatalError("Unable to read managed object context.")
        }
        
        let decoder = JSONDecoder()
        
        switch notification.request.content.categoryIdentifier {
        case "NEW_MESSAGE":
            print("received new message")
            
        case "NEW_COMMUNITY":
//            print(notification.request.content.userInfo["body"] )
            let payload = notification.request.content.userInfo["name"]
            
            let json = """

[
    {
        "chats": [
            {
                "created_at": "Mon, 04 May 2020 00:22:36 GMT",
                "members": [
                    {
                        "biography": "I like to code",
                        "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                        "display_name": "Ben",
                        "username": "bvandyyyyy",
                        "uuid": "be80b327704d47719129831ebbc8ffe7"
                    },
                    {
                        "biography": null,
                        "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                        "display_name": null,
                        "username": "grant",
                        "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                    }
                ],
                "messages": [
                    {
                        "author": {
                            "biography": "I like to code",
                            "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                            "display_name": "Ben",
                            "username": "bvandyyyyy",
                            "uuid": "be80b327704d47719129831ebbc8ffe7"
                        },
                        "content": "hi grant",
                        "created_at": "Mon, 04 May 2020 00:23:07 GMT",
                        "deliveries": [
                            {
                                "is_delivered": true,
                                "recipient": {
                                    "biography": "I like to code",
                                    "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                                    "display_name": "Ben",
                                    "username": "bvandyyyyy",
                                    "uuid": "be80b327704d47719129831ebbc8ffe7"
                                },
                                "uuid": "8ca8ce04870f40f1bf4ed66206c93105"
                            },
                            {
                                "is_delivered": true,
                                "recipient": {
                                    "biography": null,
                                    "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                                    "display_name": null,
                                    "username": "grant",
                                    "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                                },
                                "uuid": "e0b49616bc06497c94362db748f38b7a"
                            }
                        ],
                        "reactions": [
                            {
                                "deliveries": [
                                    {
                                        "is_delivered": false,
                                        "recipient": {
                                            "biography": "I like to code",
                                            "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                                            "display_name": "Ben",
                                            "username": "bvandyyyyy",
                                            "uuid": "be80b327704d47719129831ebbc8ffe7"
                                        },
                                        "uuid": "1a4337fd4ad94de9beb867b7cd2f05ae"
                                    },
                                    {
                                        "is_delivered": true,
                                        "recipient": {
                                            "biography": null,
                                            "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                                            "display_name": null,
                                            "username": "grant",
                                            "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                                        },
                                        "uuid": "0c46b7c5373f4db8a4b23033e2174b89"
                                    }
                                ],
                                "reaction_type": "like",
                                "reactor": {
                                    "biography": null,
                                    "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                                    "display_name": null,
                                    "username": "grant",
                                    "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                                },
                                "uuid": "4412070f0d3d47ce8f7f02030146b0a0"
                            }
                        ],
                        "uuid": "47c6bf138c534f7faa1aa2a85021810f"
                    }
                ],
                "name": "Honk Incorporated",
                "uuid": "b283f6ed4eee45a8bc9bfe329e875ce7"
            }
        ],
        "created_at": "Mon, 04 May 2020 00:11:52 GMT",
        "about": "a place to drink",
        "name": "Tavern",
        "subscribers": [
            {
                "biography": "I like to code",
                "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                "display_name": "Ben",
                "username": "bvandyyyyy",
                "uuid": "be80b327704d47719129831ebbc8ffe7"
            },
            {
                "biography": null,
                "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                "display_name": null,
                "username": "grant",
                "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
            }
        ],
        "uuid": "b0fa3fba01c540509477858f5cf659c1"
    }
]

"""
            
            let user = """
[{
               "biography": "boi",
               "created_at": "Mon, 04 May 2020 00:12:02 GMT",
               "display_name": "fartface69",
               "username": "grant",
               "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
           }]


"""
            
            let chat = """
[
           {
               "created_at": "Mon, 04 May 2020 00:22:36 GMT",
               "members": [
                   {
                       "biography": "I like to code",
                       "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                       "display_name": "Ben",
                       "username": "bvandyyyyy",
                       "uuid": "be80b327704d47719129831ebbc8ffe7"
                   },
                   {
                       "biography": null,
                       "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                       "display_name": null,
                       "username": "grant",
                       "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                   }
               ],
               "messages": [
                   {
                       "author": {
                           "biography": "I like to code",
                           "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                           "display_name": "Ben",
                           "username": "bvandyyyyy",
                           "uuid": "be80b327704d47719129831ebbc8ffe7"
                       },
                       "content": "hi grant",
                       "created_at": "Mon, 04 May 2020 00:23:07 GMT",
                       "deliveries": [
                           {
                               "is_delivered": true,
                               "recipient": {
                                   "biography": "I like to code",
                                   "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                                   "display_name": "Ben",
                                   "username": "bvandyyyyy",
                                   "uuid": "be80b327704d47719129831ebbc8ffe7"
                               },
                               "uuid": "8ca8ce04870f40f1bf4ed66206c93105"
                           },
                           {
                               "is_delivered": true,
                               "recipient": {
                                   "biography": null,
                                   "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                                   "display_name": null,
                                   "username": "grant",
                                   "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                               },
                               "uuid": "e0b49616bc06497c94362db748f38b7a"
                           }
                       ],
                       "reactions": [
                           {
                               "deliveries": [
                                   {
                                       "is_delivered": false,
                                       "recipient": {
                                           "biography": "I like to code",
                                           "created_at": "Sun, 03 May 2020 21:31:49 GMT",
                                           "display_name": "Ben",
                                           "username": "bvandyyyyy",
                                           "uuid": "be80b327704d47719129831ebbc8ffe7"
                                       },
                                       "uuid": "1a4337fd4ad94de9beb867b7cd2f05ae"
                                   },
                                   {
                                       "is_delivered": true,
                                       "recipient": {
                                           "biography": null,
                                           "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                                           "display_name": null,
                                           "username": "grant",
                                           "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                                       },
                                       "uuid": "0c46b7c5373f4db8a4b23033e2174b89"
                                   }
                               ],
                               "reaction_type": "like",
                               "reactor": {
                                   "biography": null,
                                   "created_at": "Mon, 04 May 2020 00:12:02 GMT",
                                   "display_name": null,
                                   "username": "grant",
                                   "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
                               },
                               "uuid": "4412070f0d3d47ce8f7f02030146b0a0"
                           }
                       ],
                       "uuid": "47c6bf138c534f7faa1aa2a85021810f"
                   }
               ],
               "name": "Honk Incorporated",
               "uuid": "b283f6ed4eee45a8bc9bfe329e875ce7"
           }
       ]
"""
            
            
            let jsonData = Data(json.utf8)
            let decoder = JSONDecoder()
            decoder.userInfo[CodingUserInfoKey.context!] = context
            do {
                let subjects = try decoder.decode([CommunityN].self, from: jsonData)
                print(subjects)
                do {
                    try context.save()
                } catch {
                    print("error")
                }
            } catch {
                print("different error")
            }
            


            
            break
            
            
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

