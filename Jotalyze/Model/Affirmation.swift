//
//  Affirmation.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/4/25.
//

import Foundation

struct Affirmation: Codable, Identifiable {
    let id: UUID
    var affirmationText: String
    var date: Date?
}
