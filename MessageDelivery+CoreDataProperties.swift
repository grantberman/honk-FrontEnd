//
//  MessageDelivery+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension MessageDelivery {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MessageDelivery> {
        return NSFetchRequest<MessageDelivery>(entityName: "MessageDelivery")
    }
    
    //Message Delivery Object
    @NSManaged public var is_delivered: String?
    @NSManaged public var uuid: String?
    @NSManaged public var message: Message?
    @NSManaged public var recipient: User?

}

