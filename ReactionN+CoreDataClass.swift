//
//  ReactionN+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ReactionN)
public class ReactionN: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
        case reaction_type = "reaction_type"
        case uuid = "uuid"
        case reactor = "reactor"
        case deliveries = "deliveries"
    }
   
    
    public func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(reaction_type ?? "", forKey: .reaction_type)
            try container.encode(uuid ?? "", forKey: .uuid)
        }
        catch {
            print("reaction error")
        }
    }
    
    
    required convenience public init (from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "ReactionN", in: managedObjectContext) else { fatalError ("Failed to decode reaction")}
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            
            reaction_type = try values.decode(String?.self, forKey: .reaction_type)
            uuid = try values.decode(String?.self, forKey: .uuid)
            reactor = try values.decode(UserN?.self, forKey: .reactor)
            deliveries = NSSet (array: try values.decode([ReactionDelivery].self, forKey: .deliveries))
        } catch {
            print("reaction delivery error")
        }
    }
}

