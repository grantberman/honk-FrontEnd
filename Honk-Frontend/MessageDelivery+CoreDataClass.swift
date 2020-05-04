//
//  MessageDelivery+CoreDataClass.swift
//  Honk-Frontend
//
//  Created by Grant Berman on 5/4/20.
//  Copyright © 2020 Grant Berman. All rights reserved.
//
//

import Foundation
import CoreData

@objc(MessageDelivery)
public class MessageDelivery: NSManagedObject, Codable {

    enum CodingKeys: String, CodingKey {
        case is_delivered = "is_delivered"
        case uuid = "uuid"
        case recipient  = "recipient"
    }
    
    public func encode (to encoder: Encoder) throws {
                var container = encoder.container(keyedBy: CodingKeys.self)
                do {
                    try container.encode(is_delivered ?? "" , forKey: .is_delivered)
                    try container.encode(uuid ?? "", forKey: .uuid)
                }
                catch {
                    print("error")
                }
            }
    
    required convenience public init (from decoder: Decoder) throws {
                guard let contextUserInfoKey = CodingUserInfoKey.context,
                    let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
                    let entity = NSEntityDescription.entity(forEntityName: "MessageDelivery", in: managedObjectContext) else { fatalError ("Failed to decode message delivery")}
                self.init(entity: entity, insertInto: managedObjectContext)
                let values = try decoder.container(keyedBy: CodingKeys.self)
                do {

                    is_delivered = try values.decode(String?.self, forKey: .is_delivered)
                    uuid = try values.decode(String?.self, forKey: .uuid)
                    recipient = try values.decode(UserN?.self, forKey: .recipient)

                } catch {
                    print("error")
                }
            }
        }

    


