//
//  ReactionDelivery+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension ReactionDelivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ReactionDelivery> {
        return NSFetchRequest<ReactionDelivery>(entityName: "ReactionDelivery")
    }

    @NSManaged public var is_delivered: String?
    @NSManaged public var uuid: String?
    @NSManaged public var reaction: Reaction?
    @NSManaged public var recipient: User?

}
