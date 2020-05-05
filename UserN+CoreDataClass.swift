//
//  UserN+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData


extension CodingUserInfoKey {
    static let context = CodingUserInfoKey(rawValue: "context")
}

@objc(UserN)
public class UserN: NSManagedObject, Codable {
    
    enum CodingKeys: String, CodingKey {
           case biography = "biography"
           case created_at = "created_at"
           case display_name = "display_name"
           case username = "username"
           case uuid = "uuid"
       }
    
    public func encode(to encoder: Encoder) throws {
           var container = encoder.container(keyedBy: CodingKeys.self)
           do {
               try container.encode(biography ?? "", forKey: .biography)
               try container.encode(created_at ?? "", forKey: .created_at)
               try container.encode(display_name ?? "", forKey: .display_name)
               try container.encode(username ?? "", forKey: .username)
               try container.encode(uuid ?? "", forKey: .uuid)
           } catch {
               print(" user encoding error")
           }
       }
     required convenience public init (from decoder: Decoder) throws {
            guard let contextUserInfoKey = CodingUserInfoKey.context,
                let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
            let entity = NSEntityDescription.entity(forEntityName: "UserN", in: managedObjectContext) else { fatalError ("Failed to decode user")}
            self.init(entity: entity, insertInto: managedObjectContext)
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {
                biography = try values.decode(String?.self, forKey: .biography)
                created_at = try values.decode(String?.self, forKey: .created_at)
                display_name = try values.decode(String?.self, forKey: .display_name)
                username = try values.decode(String?.self, forKey: .username)
                uuid = try values.decode(String?.self, forKey: .uuid)
            } catch {
                print("user decoding error ")
            }
        }

    }
