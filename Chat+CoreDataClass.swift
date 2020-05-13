//
//  ChatN+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Chat)
public class Chat: NSManagedObject, Codable{
    
    enum CodingKeys: String, CodingKey {
        case created_at = "created_at"
        case name = "name"
        case uuid = "uuid"
        case members = "members"
        case messages = "messages"
        case inCommunity = "inCommunity"
        
    }
    
    public func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(created_at ?? "", forKey: .created_at)
            try container.encode(name ?? "", forKey: .name)
            try container.encode(uuid ?? "", forKey: .uuid)
//            try container.encode(inCommunity as! Community, forKey: .inCommunity)
            let members = self.members?.allObjects as? [User]
            let messages = self.messages?.allObjects as? [Message]
            try container.encode(members, forKey: .members)
            try container.encode(messages, forKey: .messages)
            
            
            
        }
        catch {
            print("Error: Chat Encdoing")
        }
    }
    
    required convenience public init (from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "Chat", in: managedObjectContext) else {
                fatalError ("Failed to decode chat")
                
        }
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            
            created_at = try values.decode(String?.self, forKey: .created_at)
            name = try values.decode(String?.self, forKey: .name)
            uuid = try values.decode(String?.self, forKey: .uuid)
            members = NSSet( array: try values.decode([User].self, forKey: .members))
            messages = NSSet( array:  try values.decode([Message].self, forKey: .messages))
            
        } catch {
            print("Error: Chat Decoding")
        }
    }
}

