//
//  MyGoals.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/1/25.
//

import Foundation

struct Goal: Codable, Hashable, Identifiable {
    let id:UUID
    var goalType:String = ""
    var goalName:String = ""
    var hoursCompleted:Int? = 0
    var goalHours:Int? = 0
    var totalCompletions:Int? = 0
}
