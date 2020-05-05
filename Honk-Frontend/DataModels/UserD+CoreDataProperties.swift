//
//  UserD+CoreDataProperties.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/3/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension UserD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserD> {
        return NSFetchRequest<UserD>(entityName: "UserD")
    }

    @NSManaged public var biography: String?
    @NSManaged public var created_at: String?
    @NSManaged public var display_name: String?
    @NSManaged public var username: String?
    @NSManaged public var uuid: String?
    @NSManaged public var communities: NSSet?
    @NSManaged public var chats: NSSet?
    @NSManaged public var messages: NSSet?
    @NSManaged public var messageDeliveries: NSSet?
    @NSManaged public var reactionDeliveries: NSSet?
    @NSManaged public var reactions: NSSet?

}

// MARK: Generated accessors for communities
extension UserD {

    @objc(addCommunitiesObject:)
    @NSManaged public func addToCommunities(_ value: CommunityD)

    @objc(removeCommunitiesObject:)
    @NSManaged public func removeFromCommunities(_ value: CommunityD)

    @objc(addCommunities:)
    @NSManaged public func addToCommunities(_ values: NSSet)

    @objc(removeCommunities:)
    @NSManaged public func removeFromCommunities(_ values: NSSet)

}

// MARK: Generated accessors for chats
extension UserD {

    @objc(addChatsObject:)
    @NSManaged public func addToChats(_ value: ChatD)

    @objc(removeChatsObject:)
    @NSManaged public func removeFromChats(_ value: ChatD)

    @objc(addChats:)
    @NSManaged public func addToChats(_ values: NSSet)

    @objc(removeChats:)
    @NSManaged public func removeFromChats(_ values: NSSet)

}

// MARK: Generated accessors for messages
extension UserD {

    @objc(addMessagesObject:)
    @NSManaged public func addToMessages(_ value: MessageD)

    @objc(removeMessagesObject:)
    @NSManaged public func removeFromMessages(_ value: MessageD)

    @objc(addMessages:)
    @NSManaged public func addToMessages(_ values: NSSet)

    @objc(removeMessages:)
    @NSManaged public func removeFromMessages(_ values: NSSet)

}

// MARK: Generated accessors for messageDeliveries
extension UserD {

    @objc(addMessageDeliveriesObject:)
    @NSManaged public func addToMessageDeliveries(_ value: MessageDelivery)

    @objc(removeMessageDeliveriesObject:)
    @NSManaged public func removeFromMessageDeliveries(_ value: MessageDelivery)

    @objc(addMessageDeliveries:)
    @NSManaged public func addToMessageDeliveries(_ values: NSSet)

    @objc(removeMessageDeliveries:)
    @NSManaged public func removeFromMessageDeliveries(_ values: NSSet)

}

// MARK: Generated accessors for reactionDeliveries
extension UserD {

    @objc(addReactionDeliveriesObject:)
    @NSManaged public func addToReactionDeliveries(_ value: ReactionDelivery)

    @objc(removeReactionDeliveriesObject:)
    @NSManaged public func removeFromReactionDeliveries(_ value: ReactionDelivery)

    @objc(addReactionDeliveries:)
    @NSManaged public func addToReactionDeliveries(_ values: NSSet)

    @objc(removeReactionDeliveries:)
    @NSManaged public func removeFromReactionDeliveries(_ values: NSSet)

}

// MARK: Generated accessors for reactions
extension UserD {

    @objc(addReactionsObject:)
    @NSManaged public func addToReactions(_ value: Reaction)

    @objc(removeReactionsObject:)
    @NSManaged public func removeFromReactions(_ value: Reaction)

    @objc(addReactions:)
    @NSManaged public func addToReactions(_ values: NSSet)

    @objc(removeReactions:)
    @NSManaged public func removeFromReactions(_ values: NSSet)

}
