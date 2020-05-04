//
//  ReactionDelivery+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/3/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(ReactionDelivery)
public class ReactionDelivery: NSManagedObject, Decodable{
    
            
        required convenience public init(from decoder: Decoder) throws {
            guard let contextUserInfoKey = CodingUserInfoKey.context,
                let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
                let entity = NSEntityDescription.entity(forEntityName: "CommunityD", in: managedObjectContext) else {
                    fatalError("failed to decode community!")}
            
            self.init(entity: entity, insertInto: managedObjectContext)
            
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {
                is_delivered = try values.decode(Bool?.self, forKey: .is_delivered) ?? false
                recipient = try values.decode(UserD?.self, forKey: .recipient) ?? nil
                
                
                
            } catch {
                print("error")
            }
            
            
        }
        
        enum CodingKeys: String, CodingKey {
            case is_delivered = "is_delivered"
            case recipient = "recipient"

            
        }
        
        
        
    }
