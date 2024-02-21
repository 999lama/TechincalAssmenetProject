//
//  ManagedUser.swift
//  TechincalAssmeent
//
//  Created by Lama Albadri on 21/02/2024.
//

import Foundation
import CoreData

class ManagedUser: NSManagedObject,  Decodable {
    
    
    required convenience public init(from decoder: Decoder) throws {
        guard let entity = NSEntityDescription.entity(forEntityName: String(describing: ManagedUser.self), in: CoreDataManager.shared.managedObjectContext) else {
            fatalError("decode failure")
        }
        
        self.init(entity: entity, insertInto: CoreDataManager.shared.managedObjectContext)
        let container = try decoder.container(keyedBy: CodingKeys.self)

            if let id = try? container.decode(String.self, forKey: .id) {
                self.id_ = id
            }
    
        self.name = try? container.decode(String.self, forKey: .name)
        self.email = try? container.decode(String.self, forKey: .email)
        self.gender = try? container.decode(String.self, forKey: .gender)
        self.status = try? container.decode(String.self, forKey: .status)
        
        CoreDataManager.shared.saveContext()
    }
    
    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id_, forKey: .id)
        try container.encode(name, forKey: .name)
        try container.encode(email, forKey: .email)
        try container.encode(gender, forKey: .gender)
        try container.encode(status, forKey: .status)
    }
    
    enum CodingKeys: String, CodingKey {
        case name, id, email, gender, status
    }
}


