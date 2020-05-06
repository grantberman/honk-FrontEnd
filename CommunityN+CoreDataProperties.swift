//
//  CommunityN+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension CommunityN {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommunityN> {
        return NSFetchRequest<CommunityN>(entityName: "CommunityN")
    }

    @NSManaged public var created_at: String?
    @NSManaged public var about: String?
    @NSManaged public var name: String?
    @NSManaged public var uuid: String?
    @NSManaged public var subscribers: NSSet?
    @NSManaged public var chats: NSSet?
    
    public var communityName : String {
        name ?? "unknown"
    }
    
    public var chatArray : [ChatN] {
        let set = chats as? Set<ChatN> ?? []
        
            return set.sorted {
                $0.wrappedName < $1.wrappedName
            
        }
    }
    public var uuidDef : String {
        uuid ?? "unknown"
    }
    
    

}

// MARK: Generated accessors for subscribers
extension CommunityN {

    @objc(addSubscribersObject:)
    @NSManaged public func addToSubscribers(_ value: UserN)

    @objc(removeSubscribersObject:)
    @NSManaged public func removeFromSubscribers(_ value: UserN)

    @objc(addSubscribers:)
    @NSManaged public func addToSubscribers(_ values: NSSet)

    @objc(removeSubscribers:)
    @NSManaged public func removeFromSubscribers(_ values: NSSet)

}

// MARK: Generated accessors for chats
extension CommunityN {

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: ChatN)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: ChatN)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSSet)

}
