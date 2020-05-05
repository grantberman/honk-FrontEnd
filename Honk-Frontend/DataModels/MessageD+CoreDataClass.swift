//
//  MessageD+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/3/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MessageD)
public class MessageD: NSManagedObject, Decodable {
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "CommunityD", in: managedObjectContext) else {
                fatalError("failed to decode community!")}
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            content = try values.decode(String?.self, forKey: .content) ?? ""
            created_at = try values.decode(String?.self, forKey: .created_at) ?? ""
            uuid = try values.decode(String?.self, forKey: .uuid) ?? ""
            author = (try values.decode(UserD.self, forKey: .author) ?? nil)
            deliveries = NSSet(array: try values.decode([MessageDelivery].self, forKey: .deliveries))
            reactions = NSSet(array: try values.decode([Reaction].self, forKey: .reactions))
            
        } catch {
            print("error")
        }
        
    }
    
    
    
    enum CodingKeys: String, CodingKey {
        case content = "content"
        case created_at = "created_at"
        case uuid = "uuid"
        case deliveries = "deliveries"
        case reactions = "reactions"
        case author = "author"
    }
    
}
