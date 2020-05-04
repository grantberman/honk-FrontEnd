//
//  MessageDelivery+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/3/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MessageDelivery)
public class MessageDelivery: NSManagedObject, Decodable {
    
    
    required convenience public init(from decoder: Decoder) throws {
        guard let contextUserInfoKey = CodingUserInfoKey.context,
            let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "UserD", in: managedObjectContext) else {
                fatalError("failed to decode chat!")}
        
        self.init(entity: entity, insertInto: managedObjectContext)
        let values = try decoder.container(keyedBy: CodingKeys.self)
        do {
            is_delivered = try values.decode(Bool?.self, forKey: .is_delivered) ?? false
            recipient = try values.decode(UserD?.self, forKey: .recipient) ?? nil
            uuid = try values.decode(String?.self, forKey: .uuid) ?? ""
            
            
        } catch {
            print("error")
        }
        
        
    }
    
    
    enum CodingKeys: String, CodingKey {
        case is_delivered = "is_delivered"
        case uuid = "uuid"
        case recipient = "recipient"
    }
    

    

}
