//
//  GoalManager.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/1/25.
//

import Foundation

@Observable class GoalManager: Observable {
    var myGoals = [Goal]()
    
    func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func getGoalsDirectory() -> URL {
        let goalsDirectory = getDocumentsDirectory().appendingPathComponent("Goals", isDirectory: true)
        
        if !FileManager.default.fileExists(atPath: goalsDirectory.path) {
            try? FileManager.default.createDirectory(at: goalsDirectory, withIntermediateDirectories: true)
        }
        
        return goalsDirectory
    }
    
    func saveGoal(_ goal: Goal) {
        let fileURL = getGoalsDirectory().appendingPathComponent("\(goal.id).json")
        
        do{
            // Convert the journal entry to JSON data
            let jsonData = try JSONEncoder().encode(goal)
            
            // Write the data to the file with file protection
            try jsonData.write(to: fileURL, options: .completeFileProtection)
        } catch {
            print(error)
        }
    }
    
    func loadGoal(id: UUID) -> Goal? {
        let fileURL = getGoalsDirectory().appendingPathComponent("\(id).json")
        
        do {
            // Read the encrypted data from the file
            let jsonData = try Data(contentsOf: fileURL)
            
            // Decode the JSON data back to a JournalEntry
            let goal = try JSONDecoder().decode(Goal.self, from: jsonData)
            return goal
            
        } catch {
            
            print(error)
            
            return nil
            
            }
       
    }
    
    func getAllGoals() {
        let fileManager = FileManager.default

        do {
            myGoals.removeAll()
            // Get all the file URLs in the Documents Directory
            let fileURLs = try fileManager.contentsOfDirectory(at: getGoalsDirectory(), includingPropertiesForKeys: nil)
            
            // Loop through each file and decode the JSON data into a JournalEntry
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" {
                    if let jsonData = try? Data(contentsOf: fileURL),
                       let goal = try? JSONDecoder().decode(Goal.self, from: jsonData) {
                        myGoals.append(goal)
                    }
                }
            }
            
        } catch {
            print("Error reading files from Documents Directory: \(error)")
        }
    }
    
    func deleteGoal(goal: Goal) {
        // Remove the journal entry from the array
        if let index = myGoals.firstIndex(where: { $0.id == goal.id }) {
            myGoals.remove(at: index)
        }
        
        // Delete the corresponding file from the Documents Directory
        let fileManager = FileManager.default
        
        let goalsDirectory = getGoalsDirectory()
        
        // Construct the file URL for the specific journal entry
        let fileURL = goalsDirectory.appendingPathComponent("\(goal.id).json")
        
        do {
            // Check if the file exists and delete it
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
                print("Deleted journal entry: \(goal.goalName)")
            } else {
                print("File not found for journal entry: \(goal.goalName)")
            }
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
    }
    
    
}
