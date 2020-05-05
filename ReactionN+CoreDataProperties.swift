//
//  ReactionN+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension ReactionN {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReactionN> {
        return NSFetchRequest<ReactionN>(entityName: "ReactionN")
    }

    @NSManaged public var reaction_type: String?
    @NSManaged public var uuid: String?
    @NSManaged public var deliveries: NSSet?
    @NSManaged public var reactedTo: MessageN?
    @NSManaged public var reactor: UserN?

}

// MARK: Generated accessors for deliveries
extension ReactionN {

    @objc(addDeliveriesObject:)
    @NSManaged public func addToDeliveries(_ value: ReactionDelivery)

    @objc(removeDeliveriesObject:)
    @NSManaged public func removeFromDeliveries(_ value: ReactionDelivery)

    @objc(addDeliveries:)
    @NSManaged public func addToDeliveries(_ values: NSSet)

    @objc(removeDeliveries:)
    @NSManaged public func removeFromDeliveries(_ values: NSSet)

}
