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


extension ChatN {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<ChatN> {
        return NSFetchRequest<ChatN>(entityName: "ChatN")
    }

    @NSManaged public var created_at: String?
    @NSManaged public var uuid: String?
    @NSManaged public var name: String?
    @NSManaged public var members: NSSet?
    @NSManaged public var messages: NSSet?
    @NSManaged public var inCommunity: CommunityN?
    
    public var uuidDef : String {
        uuid ?? ""
    }
    
    public var wrappedName: String {
        name ?? "unknown?"
    }
    public var communityName: String{
        inCommunity?.name ?? "unknown"
    }
    
    public var chatMessages : [MessageN] {
        let set = messages as? Set<MessageN> ?? []
        
        return set.sorted  {
            $0.sentTime < $1.sentTime
        }
        
    }

}

// MARK: Generated accessors for members
extension ChatN {

    @objc(addMembersObject:)
    @NSManaged public func addToMembers(_ value: UserN)

    @objc(removeMembersObject:)
    @NSManaged public func removeFromMembers(_ value: UserN)

    @objc(addMembers:)
    @NSManaged public func addToMembers(_ values: NSSet)

    @objc(removeMembers:)
    @NSManaged public func removeFromMembers(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension ChatN {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageN)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageN)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}
