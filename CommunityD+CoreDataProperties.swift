//
//  CommunityD+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/2/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension CommunityD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CommunityD> {
        return NSFetchRequest<CommunityD>(entityName: "CommunityD")
    }

    @NSManaged public var id: String?
    @NSManaged public var name: String?
    @NSManaged public var chat: NSSet?
    
    public var chatArray: [ChatD] {
        let set = chat as? Set<ChatD> ?? []
        return set.sorted {
            $0.created_at < $1.created_at
        }
    }

}

// MARK: Generated accessors for chat
extension CommunityD {

    @objc(addChatObject:)
    @NSManaged public func addToChat(_ value: ChatD)

    @objc(removeChatObject:)
    @NSManaged public func removeFromChat(_ value: ChatD)

    @objc(addChat:)
    @NSManaged public func addToChat(_ values: NSSet)

    @objc(removeChat:)
    @NSManaged public func removeFromChat(_ values: NSSet)

}
