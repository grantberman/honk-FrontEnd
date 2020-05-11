//
//  ChatN+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension Chat {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Chat> {
        return NSFetchRequest<Chat>(entityName: "Chat")
    }

    @NSManaged public var created_at: String?
    @NSManaged public var uuid: String?
    @NSManaged public var name: String?
    @NSManaged public var members: NSSet?
    @NSManaged public var messages: NSSet?
    @NSManaged public var inCommunity: Community?
    
    public var nameDef : String {
        name ?? "Unknown"
    }
    
    public var uuidDef : String {
        uuid ?? ""
    }
    
    public var wrappedName: String {
        name ?? "unkown?"
    }
    
    public var chatMessages : [Message] {
        let set = messages as? Set<Message> ?? []
        
        return set.sorted  {
            $0.sentTime < $1.sentTime
        }
        
    }

}

// MARK: Generated accessors for members
extension Chat {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: User)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: User)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension Chat {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: Message)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: Message)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
