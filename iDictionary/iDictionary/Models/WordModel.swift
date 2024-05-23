//
//  WordModel.swift
//  iDictionary
//
//  Created by Guren Icim on 3.01.2024.
//

import Foundation

class Definition: Decodable, Equatable, Identifiable {
    static func == (lhs: Definition, rhs: Definition) -> Bool {
        return lhs.definition == rhs.definition
    }
    var id = UUID()
    var definition: String
    var example: String
    init(definition: String, example: String) {
        self.definition = definition
        self.example = example
    }
}
