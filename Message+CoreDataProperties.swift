//
//  MessageN+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData
import UIKit


extension Message {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Message> {
        return NSFetchRequest<Message>(entityName: "Message")
    }
    
    //Message Object
    @NSManaged public var created_at: String?
    @NSManaged public var content: String?
    @NSManaged public var uuid: String?
    @NSManaged public var deliveries: NSSet?
    @NSManaged public var author: User?
    @NSManaged public var reactions: NSSet?
    @NSManaged public var inChat: Chat?
 
    public var isMe : Bool {
        let user = (UIApplication.shared.delegate as! AppDelegate).user
        return (self.author?.usernameDef == user.username)
        
    }
    
    public var contentDef : String {
        content ?? ""
    }
    
    public var uuidDef : String {
        uuid ?? "unknown";
    }

    
    public var avatar : String {
        return "T"      //change this be based off of the display name
    }
    
    
//    public var created_atDef : String {
//        print(created_at)
//        let dateFormatter = DateFormatter()
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.Z"
//        dateFormatter.timeZone = TimeZone(abbreviation: "UTC")
//        let dt = dateFormatter.date(from: created_at!)
//        dateFormatter.timeZone = TimeZone.current
//        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
//
//        return dateFormatter.string(from: dt)
//
////        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
////        dateFormatter.timeZone = NSTimeZone(name: "UTC") as TimeZone?
////        let date = dateFormatter.date(from: created_at!)
////        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
////        dateFormatter.timeZone = NSTimeZone.local
////        let timeStamp = dateFormatter.string(from: date!)
////        print(timeStamp)
////        return timeStamp
//
//    }

//    public var sentTime:  Date  {
//        let dateFormatter = DateFormatter()
////        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
////        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
////        let date = dateFormatter.date(from: created_at ?? String(Date()))
////        return date
////
//        if let date = dateFormatter.date(from: created_atDef) {
//            return date
//        }
//        else {
//            print("default date")
//            let date = Date()
//            return date
//        }
//        
//    }
}

// MARK: Generated accessors for deliveries
extension Message {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: MessageDelivery)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: MessageDelivery)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}

// MARK: Generated accessors for reactions
extension Message {

    @objc(addReactionsObject:)
    @NSManaged public func addToReactions(_ value: Reaction)

    @objc(removeReactionsObject:)
    @NSManaged public func removeFromReactions(_ value: Reaction)

    @objc(addReactions:)
    @NSManaged public func addToReactions(_ values: NSSet)

    @objc(removeReactions:)
    @NSManaged public func removeFromReactions(_ values: NSSet)

}
