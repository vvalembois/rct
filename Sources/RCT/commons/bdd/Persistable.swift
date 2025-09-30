//
//  Persistable.swift
//  RCT
//
//  Created by Vincent on 28/09/2025.
//

protocol Persistable {
    associatedtype ManagedObject = Encodable & Decodable
    init(managedObject: ManagedObject)
    func managedObject() -> ManagedObject
}
