//
//  MessageD+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/3/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageD> {
        return NSFetchRequest<MessageD>(entityName: "MessageD")
    }

    @NSManaged public var content: String?
    @NSManaged public var created_at: String?
    @NSManaged public var uuid: String?
    @NSManaged public var chat: ChatD?
    @NSManaged public var deliveries: NSSet?
    @NSManaged public var reactions: NSSet?
    @NSManaged public var author: UserD?

}

// MARK: Generated accessors for deliveries
extension MessageD {

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
extension MessageD {

    @objc(addReactionsObject:)
    @NSManaged public func addToReactions(_ value: Reaction)

    @objc(removeReactionsObject:)
    @NSManaged public func removeFromReactions(_ value: Reaction)

    @objc(addReactions:)
    @NSManaged public func addToReactions(_ values: NSSet)

    @objc(removeReactions:)
    @NSManaged public func removeFromReactions(_ values: NSSet)

}
