//
//  ChatD+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/2/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension ChatD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatD> {
        return NSFetchRequest<ChatD>(entityName: "ChatD")
    }

    @NSManaged public var community: String?
    @NSManaged public var created_at: String
    @NSManaged public var members: NSObject?
    @NSManaged public var messages: NSObject?
    @NSManaged public var name: String 
    @NSManaged public var uuid: String?
    @NSManaged public var communityOwner: CommunityD?

}
