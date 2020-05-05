//
//  ChatD+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/2/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData



@objc(ChatD)
public class ChatD: NSManagedObject, Decodable {
    

    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ChatD", in: managedObjectContext) else {
                fatalError("failed to decode chat!")}
        
        self.init(entity: entity, insertInto: managedObjectContext)
        
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            created_at = try values.decode(String?.self, forKey: .created_at) ?? ""
            name = try values.decode(String?.self, forKey: .name) ?? ""
//            messages = NSSet(array: try values.decode([MessageD].self, forKey: .messages))
            uuid = try values.decode(String?.self, forKey: .uuid) ?? ""
            members = NSSet(array: try values.decode([UserD].self, forKey: .members))
            
            
        } catch {
            print("error")
        }
   
        
    }

    enum CodingKeys: String, CodingKey {
        case created_at = "created_at"
        case name = "name"
        case uuid = "uuid"
        case members = "members"
        case messages = "messages"
    }
    
    
}
