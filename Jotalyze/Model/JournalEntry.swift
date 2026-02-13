//
//  JournalEntry.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/11/24.
//

import Foundation

struct JournalEntry: Codable, Equatable, Identifiable {
    
    let id:UUID
    var mood:String
    var customSpecificMoodWord:String?
    var title:String?
    var entry:String
    var date:Date
    var entryType:String?
    var goalName:String?
    var goalType:String?
    var progressLogged:Double?
    var imageData:String?
    
}
