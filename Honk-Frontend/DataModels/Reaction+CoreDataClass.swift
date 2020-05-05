//
//  Reaction+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/3/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Reaction)
public class Reaction: NSManagedObject, Decodable {
    
     
     required convenience public init(from decoder: Decoder) throws {
         guard let contextUserInfoKey = CodingUserInfoKey.context,
             let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
             let entity = NSEntityDescription.entity(forEntityName: "ChatD", in: managedObjectContext) else {
                 fatalError("failed to decode chat!")}
         
         self.init(entity: entity, insertInto: managedObjectContext)
         
         let values = try decoder.container(keyedBy: CodingKeys.self)
         do {
             reaction_type = try values.decode(String?.self, forKey: .reaction_type) ?? ""
             deliveries = NSSet(array: try values.decode([ReactionDelivery].self, forKey: .deliveries))
             uuid = try values.decode(String?.self, forKey: .uuid) ?? ""
             reactor =  try values.decode(UserD.self, forKey: .reactor) ?? nil
             
             
         } catch {
             print("error")
         }
    
         
     }

     enum CodingKeys: String, CodingKey {
         case reaction_type = "reaction_type"
         case uuid = "uuid"
         case deliveries = "deliveries"
         case reactor = "reactor"
     }
     

}


