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


extension UserN {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserN> {
        return NSFetchRequest<UserN>(entityName: "UserN")
    }

    @NSManaged public var biography: String?
    @NSManaged public var created_at: String?
    @NSManaged public var display_name: String?
    @NSManaged public var username: String?
    @NSManaged public var uuid: String?
    @NSManaged public var authored: MessageN?
    @NSManaged public var receivedReaction: ReactionDelivery?
    @NSManaged public var recievedMessage: MessageDelivery?
    @NSManaged public var membersOf: ChatN?
    @NSManaged public var subscribedTo: CommunityN?
    @NSManaged public var reaction: ReactionN?
    
    
    public var displayName : String {
        display_name ?? "Unkown"
    }
    public var usernameDef : String {
        username ?? "Unknown"
    }
    
    

}
