//
//  JournalManager.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/11/24.
//

import Foundation

@Observable class JournalManager: Observable {
    
        var journalEntries = [JournalEntry]()
    
        func totalWords() -> Int {
        //get total words from entries components separated by
            
            var totalWords = 0
            //set back to zero each evaluation
            
            for i in journalEntries {
                /*
                if !(i.title).isEmpty {
                    let titleWords = (i.title).components(separatedBy: CharacterSet.whitespacesAndNewlines)
                    let titleCount = titleWords.count
                    totalWords += titleCount
                }
                 */
                if !i.entry.isEmpty {
                    let words = i.entry.components(separatedBy: CharacterSet.whitespacesAndNewlines)
                    let wordsCount = words.count
                    totalWords += wordsCount
                }
            }
            
            return totalWords
        }
    
    // Function to calculate the number of days journaled
      func numberOfDaysJournaled() -> Int {
          let calendar = Calendar.current

          // Get the unique dates without the time component
          let uniqueDays = Set(journalEntries.map {
              calendar.startOfDay(for: $0.date)
          })

          return uniqueDays.count
      }

        
        func getDocumentsDirectory() -> URL {
            FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        }
 
        
        func saveJournalEntry(_ entry: JournalEntry) {
            let fileURL = getDocumentsDirectory().appendingPathComponent("\(entry.id).json")
            
            do{
                // Convert the journal entry to JSON data
                let jsonData = try JSONEncoder().encode(entry)
                
                // Write the data to the file with file protection
                try jsonData.write(to: fileURL, options: .completeFileProtection)
            } catch {
                print(error)
            }
        }
        
        func loadJournalEntry(id: UUID) -> JournalEntry? {
            //for drilled in view if i load a specific one.
            let fileURL = getDocumentsDirectory().appendingPathComponent("\(id).json")
            
            do {
                // Read the encrypted data from the file
                let jsonData = try Data(contentsOf: fileURL)
                
                // Decode the JSON data back to a JournalEntry
                let journalEntry = try JSONDecoder().decode(JournalEntry.self, from: jsonData)
                return journalEntry
                
            } catch {
                
                print(error)
                
                return nil
                
                }
           
        }
        
        func getAllJournalEntries() {
            let fileManager = FileManager.default
            let documentsDirectory = getDocumentsDirectory()

            do {
                journalEntries.removeAll()
                // Get all the file URLs in the Documents Directory
                let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
                
                // Loop through each file and decode the JSON data into a JournalEntry
                for fileURL in fileURLs {
                    if fileURL.pathExtension == "json" {
                        if let jsonData = try? Data(contentsOf: fileURL),
                           let journalEntry = try? JSONDecoder().decode(JournalEntry.self, from: jsonData) {
                            journalEntries.append(journalEntry)
                        }
                    }
                }
                
            } catch {
                print("Error reading files from Documents Directory: \(error)")
            }
        }
    
    func getAllJournalEntriesAwaited() async {
        let fileManager = FileManager.default
        let documentsDirectory = getDocumentsDirectory()

        do {
            journalEntries.removeAll()
            // Get all the file URLs in the Documents Directory
            let fileURLs = try fileManager.contentsOfDirectory(at: documentsDirectory, includingPropertiesForKeys: nil)
            
            // Loop through each file and decode the JSON data into a JournalEntry
            for fileURL in fileURLs {
                if fileURL.pathExtension == "json" {
                    if let jsonData = try? Data(contentsOf: fileURL),
                       let journalEntry = try? JSONDecoder().decode(JournalEntry.self, from: jsonData) {
                        journalEntries.append(journalEntry)
                    }
                }
            }
            
        } catch {
            print("Error reading files from Documents Directory: \(error)")
        }
    }
    
    func deleteJournalEntry(journalEntry: JournalEntry) {
        // Remove the journal entry from the array
        if let index = journalEntries.firstIndex(where: { $0.id == journalEntry.id }) {
            journalEntries.remove(at: index)
        }
        
        // Delete the corresponding file from the Documents Directory
        let fileManager = FileManager.default
        
        // Get the path to the Documents Directory
        guard let documentsDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            return
        }
        
        // Construct the file URL for the specific journal entry
        let fileURL = documentsDirectory.appendingPathComponent("\(journalEntry.id).json")
        
        do {
            // Check if the file exists and delete it
            if fileManager.fileExists(atPath: fileURL.path) {
                try fileManager.removeItem(at: fileURL)
               // print("Deleted journal entry: \(journalEntry.title)")
            } else {
               // print("File not found for journal entry: \(journalEntry.title)")
            }
        } catch {
            print("Error deleting file: \(error.localizedDescription)")
        }
    }

    }
