    //
    //  CommunityD+CoreDataClass.swift
    //  Honk-Frontend
    //
    //  Created by Grant Berman on 5/2/20.
    //  Copyright © 2020 Grant Berman. All rights reserved.
    //
    //
    
    import Foundation
    import CoreData
    
    @objc(CommunityD)
    public class CommunityD: NSManagedObject, Decodable {
        
        
        required convenience public init(from decoder: Decoder) throws {
            guard let contextUserInfoKey = CodingUserInfoKey.context,
                let managedObjectContext = decoder.userInfo[contextUserInfoKey] as? NSManagedObjectContext,
                let entity = NSEntityDescription.entity(forEntityName: "CommunityD", in: managedObjectContext) else {
                    fatalError("failed to decode community!")}
            
            self.init(entity: entity, insertInto: managedObjectContext)
            
            let values = try decoder.container(keyedBy: CodingKeys.self)
            do {
                uuid = try values.decode(String?.self, forKey: .uuid) ?? ""
                name = try values.decode(String?.self, forKey: .name) ?? ""
                created_at = try values.decode(String?.self, forKey: .created_at) ?? ""
                chats = NSSet(array: try values.decode([ChatD].self, forKey: .chats))
                subscribers = NSSet(array: try values.decode([UserD].self, forKey: .subscribers))
                about = try values.decode(String?.self, forKey: .about) ?? ""
                
                
            } catch {
                print("error")
            }
            
            
        }
        
        enum CodingKeys: String, CodingKey {
            case name = "name"
            case uuid = "uuid"
            case created_at = "created_at"
            case about = "about"
            case chats = "chats"
            case subscribers = "subscribers"
            
        }
        
        
        
    }
