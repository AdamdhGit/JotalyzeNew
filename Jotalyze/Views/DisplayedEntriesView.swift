//
//  DisplayedEntryView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 1/24/25.
//

import SwiftUI

struct DisplayedEntriesView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Binding var journalManager: JournalManager
    var journalEntry: JournalEntry
    @Binding var selectedJournalEntry: JournalEntry
    @Binding var showEditSheet: Bool
    
    var body: some View {
        
        
            ZStack {
                
                
                if !journalEntry.mood.isEmpty {
                   // Color(colorForMood(journalEntry.mood)).opacity(0.1)//.blur(radius: 15).padding(.horizontal, -20)

                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                    
                } else if journalEntry.entryType == "Gratitude" {
                    //Color(.purple).opacity(0.1)//.blur(radius: 15).padding(.horizontal, -20)
                    
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                } else if journalEntry.entryType == "Goal" {
                    //Color(.mint).opacity(0.1)//.blur(radius: 15).padding(.horizontal, -20)
                    
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                }  else if journalEntry.entryType == "Photo" {
                    //Color(.mint).opacity(0.1)//.blur(radius: 15).padding(.horizontal, -20)
                    
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                } else if journalEntry.entryType == "Morning Preparation" {
                    //Color(.mint).opacity(0.1)//.blur(radius: 15).padding(.horizontal, -20)
                    
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                } else if journalEntry.entryType == "Evening Reflection" {
                    //Color(.mint).opacity(0.1)//.blur(radius: 15).padding(.horizontal, -20)
                    
                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                        
                }
                
                VStack {
                    
                    //MARK: title, mood, emoji, edit/delete button
                    HStack{
                       
                        if !journalEntry.mood.isEmpty {
                            VStack{
                                
                                HStack {
                                    
                                    HStack{
                                        Image(systemName: "cloud.sun").fontWeight(.light)
                                        Text("Mood Check-In").font(.subheadline).foregroundStyle(.gray).bold().opacity(0.7)
                                      
                                    }
                                    
                                        
                                    //Text(displayRelevantEmoji(entry: journalEntry)).font(.title2).opacity(0.9)
                                    Spacer()
                                    Menu {
                                        Button("Edit"){
                                            selectedJournalEntry = journalEntry
                                            showEditSheet.toggle()
                                        }
                                        Button("Delete", role: .destructive){
                                            journalManager.deleteJournalEntry(journalEntry: journalEntry)
                                        }
                                        
                                    }label:{
                                        
                                        Image(systemName: "pencil.line").font(.body).opacity(0.5)
                                            .contentShape(Rectangle()).frame(width: 80, height: 50)
                                        
                                        
                                    }.foregroundStyle(.gray).opacity(0.75)
                                }.opacity(0.8).padding(.bottom, -13)
                                //mood/emoji/journal entry
                                
                                
                                
                                HStack{
                                    
                                    //Image(systemName: "clock.fill").font(.caption).opacity(0.5)
                                    Text(dateAsString(entry: journalEntry)).font(.caption2).opacity(0.5)
                                    Spacer()
                                }
                                
                                HStack{
                                    HStack{
                                        Image(displayRelevantEmoji(entry: journalEntry)).resizable().frame(width:23, height: 23).overlay{
                                            colorForMood(journalEntry.mood)
                                            //Color.black
                                        }.mask{
                                            Image(displayRelevantEmoji(entry: journalEntry)).resizable()
                                        .frame(width:23, height: 23)
                                        
                                        
                                        }
                                        
                                        if let customMoodChosen = journalEntry.customSpecificMoodWord {
                                            Text(customMoodChosen).font(.subheadline).fontWeight(.light).opacity(1)
                                                .foregroundStyle(colorForMood(journalEntry.mood))
                                        } else {
                                            
                                            Text(journalEntry.mood).font(.subheadline).foregroundStyle(colorForMood(journalEntry.mood)).fontWeight(.light).opacity(0.9)
                                        }
                                    }.padding(8).overlay {
                                        RoundedRectangle(cornerRadius: 10).frame(height: 32).foregroundStyle(colorForMood(journalEntry.mood))
                                            .opacity(0.1)
                                        
                                    }
                                    Spacer()
                                }
                                
                                //clock/date
                                
                                Spacer().frame(height: 10)
                            }
                            
                        } else if journalEntry.entryType == "Gratitude" {
                            ZStack{
                                VStack{
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "heart").fontWeight(.light)
                                            Text("Gratitude").font(.subheadline).foregroundStyle(.gray).bold().opacity(0.7)
                                               
                                        }
                                        
                                        Spacer()
                                        Menu {
                                            Button("Edit"){
                                                selectedJournalEntry = journalEntry
                                                showEditSheet.toggle()
                                            }
                                            Button("Delete", role: .destructive){
                                                journalManager.deleteJournalEntry(journalEntry: journalEntry)
                                            }
                                            
                                        }label:{
                                            
                                            Image(systemName: "pencil.line").font(.body).opacity(0.5)
                                                .contentShape(Rectangle()).frame(width: 80, height: 50)
                                            
                                            
                                        }.foregroundStyle(.gray).opacity(0.75)
                                    }.padding(.bottom, -15).padding(.top, 5)
                                    
                                    //title/menu
                                    
                                    /*
                                    HStack{
                                        HStack{
                                            Text("🙏").font(.subheadline).opacity(0.9)
                                            Text("thankful").font(.title3).foregroundStyle(.purple).fontWeight(.light).opacity(0.9)
                                        }.padding(9).overlay {
                                            RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1).foregroundStyle(.purple)
                                            
                                        }
                                        
                                        Spacer()
                                    }.padding(.top, 10)
                                    */
                                    
                                    HStack{
                                        
                                        //Image(systemName: "clock.fill").font(.caption).opacity(0.5)
                                        Text(dateAsString(entry: journalEntry)).font(.caption2).opacity(0.5)
                                        Spacer()
                                    }
                                    //clock/time
                                    HStack{
                                        Text("WHAT I'M THANKFUL FOR").bold().font(.caption)
                                        Spacer()
                                    }.padding(.top, 10)
                                }
                            }.padding(.bottom, 5)
                        }
                        
                        else if journalEntry.entryType == "Goal" {
                            ZStack{
                                VStack{
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "chart.line.uptrend.xyaxis").fontWeight(.light)
                                            Text("Goal Tracking").font(.subheadline).foregroundStyle(.gray).bold().opacity(0.7)
                                          
                                        }
                                        
                                        Spacer()
                                        Menu {
                                            Button("Edit"){
                                                selectedJournalEntry = journalEntry
                                                showEditSheet.toggle()
                                            }
                                            Button("Delete", role: .destructive){
                                                journalManager.deleteJournalEntry(journalEntry: journalEntry)
                                            }
                                            
                                        }label:{
                                            
                                            Image(systemName: "pencil.line").font(.body).opacity(0.5)
                                                .contentShape(Rectangle()).frame(width: 80, height: 50)
                                            
                                            
                                        }.foregroundStyle(.gray).opacity(0.75)
                                    }.padding(.bottom, -15).padding(.top, 5)
                                    
                                    //title/menu
                                    
                               
                                      /*
                                        HStack{
                                            
                                            HStack{
                                                Text("📈").font(.subheadline).opacity(0.9)
                                                
                                                Text("progress").font(.title3).foregroundStyle(.mint).fontWeight(.light).opacity(0.9)
                                            }.padding(9).overlay {
                                                RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1).foregroundStyle(.mint)
                                                
                                            }
                                            
                                            Spacer()
                                        }.padding(.top, 10)
                                    */
                                    
                                    HStack{
                                        
                                        //Image(systemName: "clock.fill").font(.caption).opacity(0.5)
                                        Text(dateAsString(entry: journalEntry)).font(.caption2).opacity(0.5)
                                        Spacer()
                                    }
                                    
                                    
                                    
                                 
                                    
                                    HStack{
                                        Text("YOUR GOAL").font(.caption).foregroundStyle(.gray)
                                        Spacer()
                                    }.padding(.top, 10)
                                    HStack{
                                        Text(journalEntry.goalName ?? "").opacity(0.75).foregroundStyle(.gray).fontWeight(.light)
                                        Spacer()
                                    }
                                    
                                    if journalEntry.progressLogged != 0 {
                                        HStack{
                                            Text("Duration: \(Int(journalEntry.progressLogged ?? 0)) Hours")
                                            Spacer()
                                        }.padding(.top, 10).font(.caption).foregroundStyle(.gray).bold()
                                    }
                                    
                                    
                                    HStack{
                                        Text("PROGRESS RECAP").bold().font(.caption)
                                        Spacer()
                                    }.padding(.top, 10)
                                }
                            }.padding(.bottom, 5)
                        }
                        
                        else if journalEntry.entryType == "Photo" {
                            ZStack{
                                VStack{
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "camera").fontWeight(.light)
                                            Text("Capture The Moment").font(.subheadline).foregroundStyle(.gray).bold().opacity(0.7) .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .allowsTightening(true)
                                          
                                        }
                                        
                                        Spacer()
                                        Menu {
                                            Button("Edit"){
                                                selectedJournalEntry = journalEntry
                                                showEditSheet.toggle()
                                            }
                                            Button("Delete", role: .destructive){
                                                journalManager.deleteJournalEntry(journalEntry: journalEntry)
                                            }
                                            
                                        }label:{
                                            
                                            Image(systemName: "pencil.line").font(.body).opacity(0.5)
                                                .contentShape(Rectangle()).frame(width: 80, height: 50)
                                            
                                            
                                        }.foregroundStyle(.gray).opacity(0.75)
                                    }.padding(.bottom, -15).padding(.top, 5)
                                    
                                    //title/menu
                                    
                               
                                      /*
                                        HStack{
                                            
                                            HStack{
                                                Text("📈").font(.subheadline).opacity(0.5)
                                                
                                                Text("progress").font(.title3).foregroundStyle(.mint).fontWeight(.light).opacity(0.9)
                                            }.padding(9).overlay {
                                                RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1).foregroundStyle(.mint)
                                                
                                            }
                                            
                                            Spacer()
                                        }.padding(.top, 10)
                                    */
                                    
                                    HStack{
                                        
                                        //Image(systemName: "clock.fill").font(.caption).opacity(0.5)
                                        Text(dateAsString(entry: journalEntry)).font(.caption2).opacity(0.5)
                                        Spacer()
                                    }
                                    
                                    HStack{
                                        
                                        JournalThumbnailView(entry: journalEntry)
                                            .frame(maxHeight: 300)
                                            .padding(.trailing, 40)
                                            .padding(.vertical)
                                        
                                        Spacer()
                                    }
                                }
                            }.padding(.bottom, 5)
                        }
                        
                        else if journalEntry.entryType == "Morning Preparation" {
                            ZStack{
                                VStack{
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "sunrise").fontWeight(.light)
                                            Text("Morning Preparation").font(.subheadline).foregroundStyle(.gray).bold().opacity(0.7)
                                                .lineLimit(1)
                                                .minimumScaleFactor(0.5)
                                                .allowsTightening(true)
                                          
                                        }
                                        
                                        Spacer()
                                        Menu {
                                            Button("Edit"){
                                                selectedJournalEntry = journalEntry
                                                showEditSheet.toggle()
                                            }
                                            Button("Delete", role: .destructive){
                                                journalManager.deleteJournalEntry(journalEntry: journalEntry)
                                            }
                                            
                                        }label:{
                                            
                                            Image(systemName: "pencil.line").font(.body).opacity(0.5)
                                                .contentShape(Rectangle()).frame(width: 80, height: 50)
                                            
                                            
                                        }.foregroundStyle(.gray).opacity(0.75)
                                    }.padding(.bottom, -15).padding(.top, 5)
                                    
                                    HStack{

                                        Text(dateAsString(entry: journalEntry)).font(.caption2).opacity(0.5)
                                        Spacer()
                                    }

                                }
                            }.padding(.bottom, 5)
                        }
                        
                        else if journalEntry.entryType == "Evening Reflection" {
                            ZStack{
                                VStack{
                                    
                                    HStack{
                                        HStack{
                                            Image(systemName: "moon").fontWeight(.light)
                                            Text("Evening Reflection").font(.subheadline).foregroundStyle(.gray).bold().opacity(0.7)
                                          
                                        }
                                        
                                        Spacer()
                                        Menu {
                                            Button("Edit"){
                                                selectedJournalEntry = journalEntry
                                                showEditSheet.toggle()
                                            }
                                            Button("Delete", role: .destructive){
                                                journalManager.deleteJournalEntry(journalEntry: journalEntry)
                                            }
                                            
                                        }label:{
                                            
                                            Image(systemName: "pencil.line").font(.body).opacity(0.5)
                                                .contentShape(Rectangle()).frame(width: 80, height: 50)
                                            
                                            
                                        }.foregroundStyle(.gray).opacity(0.75)
                                    }.padding(.bottom, -15).padding(.top, 5)
                                    
                                    HStack{

                                        Text(dateAsString(entry: journalEntry)).font(.caption2).opacity(0.5)
                                        Spacer()
                                    }

                                }
                            }.padding(.bottom, 5)
                        }
                        
                    }
                    
                    //MARK: ENTRY
                    
                    VStack(spacing:0){
                        
                        if !journalEntry.entry.isEmpty {
                            HStack{
                                Text(journalEntry.entry
                                ).padding(.bottom, 25).font(.body).padding(.trailing, 20)
                                Spacer()
                            }
                                .fontWeight(.light)
                        }
                        
                        
                    }
                }
                .padding(.leading, 20)
                .padding(.top, 5)
                .padding(.horizontal)
            
            }.padding(.bottom, 2)
        
    }
    
    func colorForMood(_ mood: String) -> Color {
        //retains general mood lowercase to maintain old users entries.
           switch mood {
           case "terrible", "Terrible", "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing",
               "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty":
               return .red
           case "sad", "Bad", "Sad", "Disappointed", "Frustrated", "Angry", "Irritated",
               "Unmotivated", "Down", "Bitter", "Dismal", "Tired":
               return .blue
           case "average", "Average", "Calm", "Indifferent", "Meh", "Okay", "Content",
               "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired":
               return .orange
           case "happy", "Good", "Happy", "Optimistic", "Confident", "Motivated", "Cheerful",
               "Excited", "Proud", "Thankful", "Energized", "Relaxed":
               return .green
           case "great", "Great", "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated",
               "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased":
               return .yellow
           default:
               return .black
           }
       }
    
    func dateAsString(entry: JournalEntry) -> String {
        
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "EEEE, MMM d, yyyy h:mm a"
        //"MMM d, yyyy h:mm a"
        
        let stringDate = dateFormatter.string(from: entry.date)
        
        return stringDate
    }
    
    func displayRelevantEmoji(entry: JournalEntry) -> String {
        
        //retains general mood lowercase to maintain old users entries.
        
        if entry.mood == "terrible" || entry.mood == "Terrible" || entry.mood == "Depressed" || entry.mood == "Hopeless" || entry.mood == "Anxious" || entry.mood == "Overwhelmed" || entry.mood == "Despairing" || entry.mood == "Stressed" || entry.mood == "Terrified" || entry.mood == "Lonely" || entry.mood == "Unhappy" || entry.mood == "Guilty"  {
            //5 mood words required. can use an || here to change a word while conserving current users data.
            return "terrible"
            //image names required to display emojies!
        }
        
        if entry.mood == "sad" || entry.mood == "Bad" || entry.mood == "Sad" || entry.mood == "Disappointed" || entry.mood == "Frustrated" || entry.mood == "Angry" || entry.mood == "Irritated" || entry.mood ==
           "Unmotivated" || entry.mood == "Down" || entry.mood == "Bitter" || entry.mood == "Dismal" || entry.mood == "Tired"  {
            return "sad"
        }
        
        if entry.mood == "average" || entry.mood == "Average" || entry.mood == "Calm" || entry.mood == "Indifferent" || entry.mood == "Meh" || entry.mood == "Okay" || entry.mood == "Content" || entry.mood ==
           "Balanced" || entry.mood == "Ambivalent" || entry.mood == "Uncertain" || entry.mood == "Bored" || entry.mood == "Uninspired"  {
            return "average"
        }
        
        if entry.mood == "happy" || entry.mood == "Good" || entry.mood == "Happy" || entry.mood == "Optimistic" || entry.mood == "Confident" || entry.mood == "Motivated" || entry.mood == "Cheerful" || entry.mood ==
           "Excited" || entry.mood == "Proud" || entry.mood == "Thankful" || entry.mood == "Energized" || entry.mood == "Relaxed"  {
            return "happy"
        }
        
        if entry.mood == "great" || entry.mood == "Great" || entry.mood == "Ecstatic" || entry.mood == "Grateful" || entry.mood == "Joyful" || entry.mood == "Euphoric" || entry.mood == "Elated" || entry.mood ==
           "Radiant" || entry.mood == "Inspired" || entry.mood == "Hopeful" || entry.mood == "Uplifted" || entry.mood == "Pleased"  {
            return "great"
        }
        
        return ""
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
}

#Preview {
    
   //let journalEntry = JournalEntry(id: UUID(), mood: "happy", title: "Sample Title", entry: "This is a sample journal entry.", date: Date())
    
    //DisplayedEntriesView(journalEntry: journalEntry, selectedJournalEntry: .constant(journalEntry), showEditSheet: .constant(false))
    
    ContentView(journalManager: JournalManager(), showingEntryTypes: .constant(false)).environmentObject(JournalLock())
    
}
