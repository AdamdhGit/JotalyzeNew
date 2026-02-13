//
//  RestructuredThought.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/4/25.
//

import Foundation

struct RestructuredThought: Codable, Identifiable {
    let id: UUID
    var thoughtText: String
    var date: Date?
}
