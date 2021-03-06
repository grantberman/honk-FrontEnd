//
//  MessageN+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(Message)
public class Message: NSManagedObject, Codable{

    
    enum CodingKeys: String, CodingKey {
              case created_at = "created_at"
              case content = "content"
              case author = "author"
              case deliveries = "deliveries"
              case reactions = "reactions"
              case uuid = "uuid"
          }
    
    public func encode (to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        do {
            try container.encode(created_at ?? "", forKey: .created_at)
            try container.encode(content ?? "", forKey: .content)
        }
        catch {
            print("message error ")
        }
    }
    
    required convenience public init (from decoder: Decoder) throws {
            guard let contextUserInfoKey = CodingUserInfoKey.context,
                let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
                let entity = NSEntityDescription.entity(forEntityName: "Message", in: managedObjectContext) else { fatalError ("Failed to decode message")}
            self.init(entity: entity, insertInto: managedObjectContext)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {

                created_at = try values.decode(String?.self, forKey: .created_at)
                content = try values.decode(String?.self, forKey: .content)
                author = try values.decode(User?.self, forKey: .author)
                deliveries = NSSet (array: try values.decode([MessageDelivery].self, forKey: .deliveries))
                reactions = NSSet (array: try values.decode([Reaction].self, forKey: .reactions))
                uuid = try values.decode(String?.self, forKey: .uuid)
            
            } catch {
                print("message decoding error")
            }
        }
    
    override public func willChangeValue(forKey key: String) {
        super.willChangeValue(forKey: key)
        self.objectWillChange.send()
    }
    }

