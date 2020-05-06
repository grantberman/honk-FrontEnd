//
//  NotificationCenter.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//

import Foundation
import UserNotifications
import UIKit
import CoreData

class NotificationHub : NSObject, UNUserNotificationCenterDelegate {


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
           guard var rootViewController = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window?.rootViewController else {
               return
           }


           let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
           context.mergePolicy = NSMergeByPropertyObjectTrumpMergePolicy

//           let notificationView = NotificationTestView().environment(\.managedObjectContext, context)

//           let window = (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.window
//           window?.rootViewController = UIHostingController(rootView: notificationView)
//
//
//           let sceneDelegate = UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate
//           sceneDelegate?.window = window
//           window?.makeKeyAndVisible()
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



           let decoder = JSONDecoder()

           switch notification.request.content.categoryIdentifier {
           case "new_message":


               let messageJSON = notification.request.content.userInfo["messages"] as! NSDictionary
               //1. create message object
               do {
                   let data = try JSONSerialization.data(withJSONObject: messageJSON, options: [])
                   let jsonString = String(data: data, encoding: .utf8)
                   let jsonData = jsonString!.data(using: .utf8)


                   decoder.userInfo[CodingUserInfoKey.context!] = context
                   let message  = try decoder.decode(MessageN.self, from: jsonData!)


                   let chatUUID = notification.request.content.userInfo["chat_uuid"] as! String
                   let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ChatN")
                   fetchRequest.predicate = NSPredicate(format: "uuid == %@", chatUUID)


                   let fetchedChat = try context.fetch(fetchRequest) as! [ChatN]
                   let objectUpdate = fetchedChat[0]
                   let messages = objectUpdate.messages
                   let updatedMessages = messages?.adding(message)
                   objectUpdate.messages = updatedMessages as NSSet?
                   try context.save()
                   print("saved")

               } catch {
                   print("could not add new message to chat" )
               }




           case "new_chat":


           let messageJSON = notification.request.content.userInfo["chats"] as! NSDictionary
           //1. create message object
           do {
               let data = try JSONSerialization.data(withJSONObject: messageJSON, options: [])
               let jsonString = String(data: data, encoding: .utf8)
               let jsonData = jsonString!.data(using: .utf8)


               decoder.userInfo[CodingUserInfoKey.context!] = context
               let chat  = try decoder.decode(ChatN.self, from: jsonData!)


               let communityUUID = notification.request.content.userInfo["community_uuid"] as! String
               let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "CommunityN")
               fetchRequest.predicate = NSPredicate(format: "uuid == %@", communityUUID)


               let fetchedCommunity = try context.fetch(fetchRequest) as! [CommunityN]
               let objectUpdate = fetchedCommunity[0]
               let chats = objectUpdate.chats
               let updatedChats = chats?.adding(chat)
               objectUpdate.chats = updatedChats as NSSet?
               try context.save()
               print("SaveD")

           } catch {
               print("could not add new chat to community" )
               }




               //3. append message to the chat
               //4. save new chat object












               //        case "NEW_COMMUNITY":
               ////            print(notification.request.content.userInfo["body"] )
               //            let payload = notification.request.content.userInfo["name"]
               //
               //            let json = """
               //
               //[
               //    {
               //        "chats": [
               //            {
               //                "created_at": "Mon, 04 May 2020 00:22:36 GMT",
               //                "members": [
               //                    {
               //                        "biography": "I like to code",
               //                        "created_at": "Sun, 03 May 2020 21:31:49 GMT",
               //                        "display_name": "Ben",
               //                        "username": "bvandyyyyy",
               //                        "uuid": "be80b327704d47719129831ebbc8ffe7"
               //                    },
               //                    {
               //                        "biography": null,
               //                        "created_at": "Mon, 04 May 2020 00:12:02 GMT",
               //                        "display_name": null,
               //                        "username": "grant",
               //                        "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
               //                    }
               //                ],
               //                "messages": [
               //                    {
               //                        "author": {
               //                            "biography": "I like to code",
               //                            "created_at": "Sun, 03 May 2020 21:31:49 GMT",
               //                            "display_name": "Ben",
               //                            "username": "bvandyyyyy",
               //                            "uuid": "be80b327704d47719129831ebbc8ffe7"
               //                        },
               //                        "content": "hi grant",
               //                        "created_at": "Mon, 04 May 2020 00:23:07 GMT",
               //                        "deliveries": [
               //                            {
               //                                "is_delivered": true,
               //                                "recipient": {
               //                                    "biography": "I like to code",
               //                                    "created_at": "Sun, 03 May 2020 21:31:49 GMT",
               //                                    "display_name": "Ben",
               //                                    "username": "bvandyyyyy",
               //                                    "uuid": "be80b327704d47719129831ebbc8ffe7"
               //                                },
               //                                "uuid": "8ca8ce04870f40f1bf4ed66206c93105"
               //                            },
               //                            {
               //                                "is_delivered": true,
               //                                "recipient": {
               //                                    "biography": null,
               //                                    "created_at": "Mon, 04 May 2020 00:12:02 GMT",
               //                                    "display_name": null,
               //                                    "username": "grant",
               //                                    "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
               //                                },
               //                                "uuid": "e0b49616bc06497c94362db748f38b7a"
               //                            }
               //                        ],
               //                        "reactions": [
               //                            {
               //                                "deliveries": [
               //                                    {
               //                                        "is_delivered": false,
               //                                        "recipient": {
               //                                            "biography": "I like to code",
               //                                            "created_at": "Sun, 03 May 2020 21:31:49 GMT",
               //                                            "display_name": "Ben",
               //                                            "username": "bvandyyyyy",
               //                                            "uuid": "be80b327704d47719129831ebbc8ffe7"
               //                                        },
               //                                        "uuid": "1a4337fd4ad94de9beb867b7cd2f05ae"
               //                                    },
               //                                    {
               //                                        "is_delivered": true,
               //                                        "recipient": {
               //                                            "biography": null,
               //                                            "created_at": "Mon, 04 May 2020 00:12:02 GMT",
               //                                            "display_name": null,
               //                                            "username": "grant",
               //                                            "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
               //                                        },
               //                                        "uuid": "0c46b7c5373f4db8a4b23033e2174b89"
               //                                    }
               //                                ],
               //                                "reaction_type": "like",
               //                                "reactor": {
               //                                    "biography": null,
               //                                    "created_at": "Mon, 04 May 2020 00:12:02 GMT",
               //                                    "display_name": null,
               //                                    "username": "grant",
               //                                    "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
               //                                },
               //                                "uuid": "4412070f0d3d47ce8f7f02030146b0a0"
               //                            }
               //                        ],
               //                        "uuid": "47c6bf138c534f7faa1aa2a85021810f"
               //                    }
               //                ],
               //                "name": "Honk Incorporated",
               //                "uuid": "b283f6ed4eee45a8bc9bfe329e875ce7"
               //            }
               //        ],
               //        "created_at": "Mon, 04 May 2020 00:11:52 GMT",
               //        "about": "a place to drink",
               //        "name": "Tavern",
               //        "subscribers": [
               //            {
               //                "biography": "I like to code",
               //                "created_at": "Sun, 03 May 2020 21:31:49 GMT",
               //                "display_name": "Ben",
               //                "username": "bvandyyyyy",
               //                "uuid": "be80b327704d47719129831ebbc8ffe7"
               //            },
               //            {
               //                "biography": null,
               //                "created_at": "Mon, 04 May 2020 00:12:02 GMT",
               //                "display_name": null,
               //                "username": "grant",
               //                "uuid": "1baaf9d0caa547cea4d3bfddbd4e208f"
               //            }
               //        ],
               //        "uuid": "b0fa3fba01c540509477858f5cf659c1"
               //    }
               //]
               //
               //"""
               //
               //
               //            let jsonData = Data(json.utf8)
               //            let decoder = JSONDecoder()
               //            decoder.userInfo[CodingUserInfoKey.context!] = context
               //            do {
               //                let subjects = try decoder.decode([CommunityN].self, from: jsonData)
               //                print(subjects)
               //                do {
               //                    try context.save()
               //                } catch {
               //                    print("error")
               //                }
               //            } catch {
               //                print("different error")
               //            }
               //
               //
               //
               //
               //            break
               //

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
