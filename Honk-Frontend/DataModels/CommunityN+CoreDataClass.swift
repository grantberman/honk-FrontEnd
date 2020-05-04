//
//  CommunityN+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(CommunityN)
public class CommunityN: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case name = "name"
        case uuid = "uuid"
        case about = "about"
        case created_at = "created_at"
        case subscribers = "subscribers"
        case chats = "chats"
    }
    
    public func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(created_at ?? "", forKey: .created_at)
            try container.encode(name ?? "", forKey: .name)
            try container.encode(uuid ?? "", forKey: .uuid)
            try container.encode(about ?? "", forKey: .about)
        }
        catch {
            print("error")
        }
    }
    
    
    required convenience public init (from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "CommunityN", in: managedObjectContext) else { fatalError ("Failed to decode communiyu")}
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            
            created_at = try values.decode(String?.self, forKey: .created_at)
            name = try values.decode(String?.self, forKey: .name)
            about = try values.decode(String?.self, forKey: .about)
            uuid = try values.decode(String?.self, forKey: .uuid)
            subscribers = NSSet( array: try values.decode([UserN].self, forKey: .subscribers))
            chats = NSSet( array: try values.decode([ChatN].self, forKey: .chats))
            
        } catch {
            print("error")
        }
    }
}


