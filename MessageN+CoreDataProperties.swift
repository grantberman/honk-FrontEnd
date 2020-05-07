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


extension MessageN {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageN> {
        return NSFetchRequest<MessageN>(entityName: "MessageN")
    }

    @NSManaged public var created_at: String?
    @NSManaged public var content: String?
    @NSManaged public var uuid: String?
    @NSManaged public var deliveries: NSSet?
    @NSManaged public var author: UserN?
    @NSManaged public var reactions: NSSet?
    @NSManaged public var inChat: ChatN?
    
    
    public var contentDef : String {
        content ?? ""
    }
    
    public var authorDef : UserN {
        author ?? UserN()
    }
    
    public var uuidDef: String {
        uuid ?? "unknown"
    }

    
    public var avatar : String {
        return "T"      //change this be based off of the display name
    }
    
    
    public var created_atDef : String {
        created_at ?? ""
    }

    public var sentTime:  Date  {
        let dateFormatter = ISO8601DateFormatter()
        if let date = dateFormatter.date(from: created_atDef) {
            return date
        }
        else {
            let date = Date()
            return date
        }
        
    }
}

// MARK: Generated accessors for deliveries
extension MessageN {

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
extension MessageN {

    @objc(addReactionsObject:)
    @NSManaged public func addToReactions(_ value: ReactionN)

    @objc(removeReactionsObject:)
    @NSManaged public func removeFromReactions(_ value: ReactionN)

    @objc(addReactions:)
    @NSManaged public func addToReactions(_ values: NSSet)

    @objc(removeReactions:)
    @NSManaged public func removeFromReactions(_ values: NSSet)

}
