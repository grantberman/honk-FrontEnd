//
//  UserN+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension User {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<User> {
        return NSFetchRequest<User>(entityName: "User")
    }

    @NSManaged public var biography: String?
    @NSManaged public var created_at: String?
    @NSManaged public var display_name: String?
    @NSManaged public var username: String?
    @NSManaged public var uuid: String?
    @NSManaged public var authored: NSSet?
    @NSManaged public var receivedReaction: ReactionDelivery?
    @NSManaged public var recievedMessage: MessageDelivery?
    @NSManaged public var memberOf: Chat?
    @NSManaged public var subscribedTo: Community?
    @NSManaged public var reaction: Reaction?
    
    
    public var displayName : String {
        display_name ?? "Unkown"
    }
    
    public var usernameDef : String {
        username ?? "Unknown"
    }
    
    

}
