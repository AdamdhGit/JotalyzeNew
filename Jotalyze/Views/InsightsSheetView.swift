//
//  InsightsSheetView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/12/24.
//

import Charts
import LocalAuthentication
import SwiftUI

struct InsightsSheetView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.scenePhase) var scenePhase
    
    @State var journalManager:JournalManager
    
    @State var goalManager:GoalManager
    
    @EnvironmentObject var journalLock: JournalLock
    
    @State var showProtectYourDataView = false
    
    let fixedMoodOrder = ["great", "happy", "average", "sad", "terrible"]
    
    @State var timelineDictionary: [Date: Int] = [:]
    
    @State var strideCount:Int = 1
    
    @State var moodStreak:Int = 0
    @State var gratitudeStreak:Int = 0
    @State var goalsStreak:Int = 0
    @State var momentsStreak:Int = 0
    
    @State var showLocalNotificationsView: Bool = false
    
    //MARK: ALL TIME MOOD
    var totalMoodCount: Int {
            //return journalManager.journalEntries.count
        return journalManager.journalEntries.filter { !$0.mood.isEmpty }.count
        }
    
    
    var moodGroups: [String: Int] {
       
        var moodsDictionary = [String:Int]()
        
        var terribleCount = 0
        for i in journalManager.journalEntries {
            if i.mood == "terrible" || i.mood == "Terrible" || i.mood == "Depressed" || i.mood == "Hopeless" || i.mood == "Anxious" || i.mood == "Overwhelmed" || i.mood == "Despairing" || i.mood ==
               "Stressed" || i.mood == "Terrified" || i.mood == "Lonely" || i.mood == "Unhappy" || i.mood == "Guilty" {
                terribleCount += 1

            }
        }
        moodsDictionary["terrible"] = terribleCount
        
        var sadCount = 0
        for i in journalManager.journalEntries {
            if i.mood == "sad" || i.mood == "Sad" || i.mood == "Bad" || i.mood == "Disappointed" || i.mood == "Frustrated" || i.mood == "Angry" || i.mood == "Irritated" || i.mood ==
               "Unmotivated" || i.mood == "Down" || i.mood == "Bitter" || i.mood == "Dismal" || i.mood == "Tired" {
                sadCount += 1

            }
        }
        moodsDictionary["sad"] = sadCount
        
        var averageCount = 0
        for i in journalManager.journalEntries {
            if i.mood == "average" || i.mood == "Average" || i.mood == "Calm" || i.mood == "Indifferent" || i.mood == "Meh" || i.mood == "Okay" || i.mood == "Content" || i.mood ==
               "Balanced" || i.mood == "Ambivalent" || i.mood == "Uncertain" || i.mood == "Bored" || i.mood == "Uninspired" {
                averageCount += 1

            }
        }
        moodsDictionary["average"] = averageCount
        
        var happyCount = 0
        for i in journalManager.journalEntries {
            if i.mood == "happy" || i.mood == "Happy" || i.mood == "Good" || i.mood == "Optimistic" || i.mood == "Confident" || i.mood == "Motivated" || i.mood == "Cheerful" || i.mood ==
               "Excited" || i.mood == "Proud" || i.mood == "Thankful" || i.mood == "Energized" || i.mood == "Relaxed" {
                happyCount += 1

            }
        }
        moodsDictionary["happy"] = happyCount
        
        var greatCount = 0
        for i in journalManager.journalEntries {
            if i.mood == "great" || i.mood == "Great" || i.mood == "Ecstatic" || i.mood == "Grateful" || i.mood == "Joyful" || i.mood == "Euphoric" || i.mood == "Elated" || i.mood ==
               "Radiant" || i.mood == "Inspired" || i.mood == "Hopeful" || i.mood == "Uplifted" || i.mood == "Pleased" {
                greatCount += 1

            }
        }
        moodsDictionary["great"] = greatCount
        
        return moodsDictionary
       
    }
    
    //MARK: WEEKLY MOOD
    
    func oneWeekAgo() -> Date {
            return Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
        }
        
        // Compute the total mood count for the last week
        var totalMoodCountForWeek: Int {
            return journalManager.journalEntries.filter { $0.date > oneWeekAgo() && !$0.mood.isEmpty}.count
        }
        
        // Group mood entries for the last week
        var moodGroupsForWeek: [String: Int] {
            var moodsDictionary = [String: Int]()
            
            // Filter journal entries from the last 7 days and group them by mood
            let weeklyEntries = journalManager.journalEntries.filter { $0.date > oneWeekAgo() && !$0.mood.isEmpty}
            
            for entry in weeklyEntries {
                // Check which mood category the entry belongs to and increment the count
                        if ["terrible", "Terrible", "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing", "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty"].contains(entry.mood) {
                            moodsDictionary["terrible", default: 0] += 1
                        }
                        
                        if ["sad", "Sad", "Bad", "Disappointed", "Frustrated", "Angry", "Irritated", "Unmotivated", "Down", "Bitter", "Dismal", "Tired"].contains(entry.mood) {
                            moodsDictionary["sad", default: 0] += 1
                        }
                        
                        if ["average", "Average", "Calm", "Indifferent", "Meh", "Okay", "Content", "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired"].contains(entry.mood) {
                            moodsDictionary["average", default: 0] += 1
                        }
                        
                        if ["happy", "Happy", "Good", "Optimistic", "Confident", "Motivated", "Cheerful", "Excited", "Proud", "Thankful", "Energized", "Relaxed"].contains(entry.mood) {
                            moodsDictionary["happy", default: 0] += 1
                        }
                        
                        if ["great", "Great", "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated", "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased"].contains(entry.mood) {
                            moodsDictionary["great", default: 0] += 1
                        }
            }
            
            return moodsDictionary
        }
    
    //MARK: MONTHLY MOOD
    
    // Helper function to get the date 30 days ago
      func thirtyDaysAgo() -> Date {
          return Calendar.current.date(byAdding: .day, value: -30, to: Date()) ?? Date()
      }
      
      // Compute the total mood count for the last 30 days
      var totalMoodCountForLast30Days: Int {
          return journalManager.journalEntries.filter { $0.date > thirtyDaysAgo() && !$0.mood.isEmpty}.count
      }
      
      // Group mood entries for the last 30 days
      var moodGroupsForLast30Days: [String: Int] {
          var moodsDictionary = [String: Int]()
          
          // Filter journal entries from the last 30 days and group them by mood
          let last30DaysEntries = journalManager.journalEntries.filter { $0.date > thirtyDaysAgo() && !$0.mood.isEmpty }
          
          for entry in last30DaysEntries {
              // Check which mood category the entry belongs to and increment the count
                      if ["terrible", "Terrible", "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing", "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty"].contains(entry.mood) {
                          moodsDictionary["terrible", default: 0] += 1
                      }
                      
                      if ["sad", "Sad", "Bad", "Disappointed", "Frustrated", "Angry", "Irritated", "Unmotivated", "Down", "Bitter", "Dismal", "Tired"].contains(entry.mood) {
                          moodsDictionary["sad", default: 0] += 1
                      }
                      
                      if ["average", "Average", "Calm", "Indifferent", "Meh", "Okay", "Content", "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired"].contains(entry.mood) {
                          moodsDictionary["average", default: 0] += 1
                      }
                      
                      if ["happy", "Happy", "Good", "Optimistic", "Confident", "Motivated", "Cheerful", "Excited", "Proud", "Thankful", "Energized", "Relaxed"].contains(entry.mood) {
                          moodsDictionary["happy", default: 0] += 1
                      }
                      
                      if ["great", "Great", "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated", "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased"].contains(entry.mood) {
                          moodsDictionary["great", default: 0] += 1
                      }
          }
          
          return moodsDictionary
      }
    
    //MARK: YEARLY MOOD
    
    func oneYearAgo() -> Date {
            return Calendar.current.date(byAdding: .day, value: -365, to: Date()) ?? Date()
        }
        
        // Compute the total mood count for the last 365 days
        var totalMoodCountForLastYear: Int {
            return journalManager.journalEntries.filter { $0.date > oneYearAgo() && !$0.mood.isEmpty}.count
        }
        
        // Group mood entries for the last 365 days
        var moodGroupsForLastYear: [String: Int] {
            var moodsDictionary = [String: Int]()
            
            // Filter journal entries from the last 365 days and group them by mood
            let lastYearEntries = journalManager.journalEntries.filter { $0.date > oneYearAgo() && !$0.mood.isEmpty }
            
            for entry in lastYearEntries {
                // Check which mood category the entry belongs to and increment the count
                        if ["terrible", "Terrible", "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing", "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty"].contains(entry.mood) {
                            moodsDictionary["terrible", default: 0] += 1
                        }
                        
                        if ["sad", "Sad", "Bad", "Disappointed", "Frustrated", "Angry", "Irritated", "Unmotivated", "Down", "Bitter", "Dismal", "Tired"].contains(entry.mood) {
                            moodsDictionary["sad", default: 0] += 1
                        }
                        
                        if ["average", "Average", "Calm", "Indifferent", "Meh", "Okay", "Content", "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired"].contains(entry.mood) {
                            moodsDictionary["average", default: 0] += 1
                        }
                        
                        if ["happy", "Happy", "Good", "Optimistic", "Confident", "Motivated", "Cheerful", "Excited", "Proud", "Thankful", "Energized", "Relaxed"].contains(entry.mood) {
                            moodsDictionary["happy", default: 0] += 1
                        }
                        
                        if ["great", "Great", "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated", "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased"].contains(entry.mood) {
                            moodsDictionary["great", default: 0] += 1
                        }
            }
            
            return moodsDictionary
        }
    
    var body: some View {
            
        if UIDevice.current.userInterfaceIdiom != .pad {
            ZStack{
                backgroundColor.ignoresSafeArea()
                VStack(spacing: 0){
                    
                    ScrollView {
                        
                        Spacer().frame(height: 20)
                        
                        VStack {
                            
                            
                            
                            //MARK: streaks
                            
                            HStack {
                                
                                streaksText
                                    .onAppear{
                                        journalManager.getAllJournalEntries()
                                        
                                        calculateMoodStreak()
                                        calculateGratitudeStreak()
                                        calculateGoalsStreak()
                                        calculateMomentsStreak()
                                    }
                                    .onChange(of: journalManager.journalEntries) {
                                        journalManager.getAllJournalEntries()
                                        
                                        calculateMoodStreak()
                                        calculateGratitudeStreak()
                                        calculateGoalsStreak()
                                        calculateMomentsStreak()
                                    }
                                    .onChange(of: scenePhase) {oldPhase, newPhase in
                                        
                                        if newPhase == .active {
                                            journalManager.getAllJournalEntries()
                                            calculateMoodStreak()
                                            calculateGratitudeStreak()
                                            calculateGoalsStreak()
                                            calculateMomentsStreak()
                                        }
                                        
                                    }
                                
                                Spacer()
                                
                            }.padding(.horizontal)
                            
                            
                            VStack{
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                        
                                        
                                        VStack{
                                            Image(systemName: "cloud.sun")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 17).padding(.bottom, 3).fontWeight(.light)
                                            
                                            Text("Check-In")
                                                .font(.subheadline)
                                            Text("\(moodStreak) \(moodStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                            
                                        }.padding()
                                    }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    
                                    
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                        VStack{
                                            Image(systemName: "heart")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 15)
                                                .padding(.bottom, 3)
                                                .fontWeight(.light)
                                            
                                            Text("Gratitude")
                                                .font(.subheadline)
                                            
                                            
                                            Text("\(gratitudeStreak) \(gratitudeStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                            
                                        }.padding()
                                    }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    Spacer()
                                }.font(.caption).padding(.leading)
                                
                                
                                HStack{
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                        VStack{
                                            Image(systemName: "chart.line.uptrend.xyaxis")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 15)
                                                .padding(.bottom, 3)
                                                .fontWeight(.light)
                                            
                                            Text("Goals").font(.subheadline)
                                            Text("\(goalsStreak) \(goalsStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                            
                                        }.padding()
                                    }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                        
                                        
                                        VStack{
                                            Image(systemName: "camera")
                                                .resizable()
                                                .scaledToFit()
                                                .frame(height: 15).padding(.bottom, 3).fontWeight(.light)
                                            
                                            Text("Moments")
                                                .font(.subheadline)
                                            Text("\(momentsStreak) \(momentsStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                            
                                        }.padding()
                                    }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    
                                    Spacer()
                                }.font(.caption).padding(.leading)
                            }
                            //MARK: writing analytics
                            
                            HStack {
                                
                                
                                writingAnalyticsText
                                Spacer()
                                
                            }.padding(.horizontal).padding(.top)
                            
                            
                            ZStack{
                                HStack{
                                    RoundedRectangle(cornerRadius: 10).frame(width: 250).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    Spacer()
                                }
                                VStack {
                                    
                                    totalEntriesTextAndImage
                                    wordsWrittenTextAndImage
                                    daysJournaledTextAndImage
                                    
                                }.font(.caption).fontWeight(.light).padding().opacity(0.9).padding(.leading)
                            }
                            
                            HStack {
                                
                                moodAnalyticsText
                                Spacer()
                                
                            }.padding(.top).padding(.horizontal).padding(.top, 5)
                            
                            
                            //MARK: mood analytics chart
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 350, height: 410).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    chartTabView.padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                }
                                Spacer()
                            }
                            
                            //MARK: timeline chart
                            HStack {
                                
                                chartTimelineText
                                Spacer()
                                
                            }.padding(.top).padding(.horizontal)
                            
                            
                            
                            //MARK: mood timeline
                            HStack{
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 350, height: 340).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    
                                    if timelineDictionary.count >= 2 {
                                        HStack{
                                            Chart {
                                                ForEach(timelineDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { date, avgMood in
                                                    
                                                    PointMark(
                                                        x: .value("Date", date),
                                                        y: .value("Mood", avgMood)
                                                    ).foregroundStyle(colorScheme == .light ? .black : .white)
                                                    
                                                    LineMark(
                                                        x: .value("Date", date),
                                                        y: .value("Mood", avgMood)
                                                    ).foregroundStyle(colorScheme == .light ? .black : .white)
                                                }
                                            }
                                            .padding(.trailing)
                                            .chartXAxis {
                                                
                                                //if more than 7 dqys has passed from first to last entry, then stride count 7 otherwise 1
                                                
                                                
                                                
                                                //**preset: .aligned maintains labels not getting cut-off in view, while also maintaing amount of gride lines structure with .stride
                                                AxisMarks(preset: .aligned, values: .stride(by: .day, count: strideCount)) { value in
                                                    AxisTick()
                                                    AxisGridLine()
                                                    AxisValueLabel {
                                                        
                                                        Text(value.as(Date.self)!.formatted(.dateTime.month(.defaultDigits).day()))
                                                            .font(.caption)
                                                            .rotationEffect(Angle(degrees: 45))
                                                            .padding(.top, 15)
                                                        
                                                        
                                                        
                                                        
                                                    }
                                                }
                                            }
                                            .chartYScale(domain: 1...5)
                                            .chartYAxis(.hidden)
                                            .frame(width: 220, height: 240)
                                            
                                            VStack {
                                                
                                                Image(colorScheme == .light ? "great" : "greatWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                Spacer()
                                                Image(colorScheme == .light ? "happy" : "happyWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                Spacer()
                                                Image(colorScheme == .light ? "average" : "averageWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                Spacer()
                                                Image(colorScheme == .light ? "sad" : "sadWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                Spacer()
                                                Image(colorScheme == .light ? "terrible" : "terribleWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5).padding(.bottom, 20)
                                                Spacer()
                                            }.frame(width: 30, height: 290).offset(x:10)
                                            
                                            
                                        }
                                    } else {
                                        
                                        HStack{
                                            VStack{
                                                
                                                ContentUnavailableView("No Recent Data", systemImage: "chart.xyaxis.line", description: Text("Create at least two Mood Check-In entries on separate days within a 30-day period to begin charting data.")).scaleEffect(0.9)
                                            }.frame(width: 340, height: 340)
                                        }
                                    }
                                    
                                    
                                }.onAppear {
                                    journalManager.getAllJournalEntries()
                                    
                                    // Filter journal entries to only include entries with non-empty moods
                                    
                                    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                                    
                                    let filteredEntries = journalManager.journalEntries.filter { !$0.mood.isEmpty && $0.date >= thirtyDaysAgo }
                                    
                                    
                                    
                                    
                                    let groupedByDate = Dictionary(grouping: filteredEntries) { entry in
                                        Calendar.current.startOfDay(for: entry.date)
                                    }
                                    //groups unique date with value being an array of all associated entries
                                    
                                    for (date, entries) in groupedByDate {
                                        
                                        let moodValues = entries.compactMap { valueForMood($0.mood) }  //put each days entries into a mood values array.
                                        
                                        let averageMood = moodValues.isEmpty ? 0 : moodValues.reduce(0, +) / moodValues.count  // Calculate average of moods from the array.
                                        
                                        timelineDictionary[date] = averageMood  // Assign the average mood value to the dictionary for that unique date
                                        
                                    }
                                    
                                    
                                    
                                    
                                }
                                .onChange(of: journalManager.journalEntries){
                                    
                                    timelineDictionary = [:]
                                    
                                    journalManager.getAllJournalEntries()
                                    
                                    // Filter journal entries to only include entries with non-empty moods
                                    
                                    let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                                    
                                    let filteredEntries = journalManager.journalEntries.filter { !$0.mood.isEmpty && $0.date >= thirtyDaysAgo }
                                    
                                    
                                    
                                    
                                    let groupedByDate = Dictionary(grouping: filteredEntries) { entry in
                                        Calendar.current.startOfDay(for: entry.date)
                                    }
                                    //groups unique date with value being an array of all associated entries
                                    
                                    for (date, entries) in groupedByDate {
                                        
                                        let moodValues = entries.compactMap { valueForMood($0.mood) }  //put each days entries into a mood values array.
                                        
                                        let averageMood = moodValues.isEmpty ? 0 : moodValues.reduce(0, +) / moodValues.count  // Calculate average of moods from the array.
                                        
                                        timelineDictionary[date] = averageMood  // Assign the average mood value to the dictionary for that unique date
                                        
                                    }
                                }
                                .onChange(of: timelineDictionary) {
                                    if !timelineDictionary.isEmpty {
                                        // Sort the dictionary by the Date key (chronologically)
                                        let sortedTimeline = timelineDictionary.sorted(by: { $0.key < $1.key })
                                        
                                        // Safely unwrap first and last entry
                                        if let earliestDate = sortedTimeline.first?.key, let lastDate = sortedTimeline.last?.key {
                                            // Calculate the total days between the earliest and latest date
                                            let totalDays = Calendar.current.dateComponents([.day], from: earliestDate, to: lastDate).day ?? 0
                                            
                                            // Adjust strideCount based on the total days difference
                                            strideCount = totalDays > 7 ? 7 : 1
                                        }
                                    }
                                }
                                Spacer()
                            }.padding(.leading)
                            
                            
                            //MARK: goals
                            HStack {
                                
                                goalProgressionText.onAppear{
                                    goalManager.getAllGoals()
                                }
                                Spacer()
                                
                            }.padding(.top).padding(.horizontal)
                            
                            
                            //MARK: goal charts
                            
                            ForEach(goalManager.myGoals
                                .sorted(by: { $0.goalName < $1.goalName })
                                .filter({ $0.goalType == "Hour Based"
                                })
                            ) {i in
                                ZStack{
                                    HStack{
                                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                        Spacer()
                                    }
                                    VStack(alignment: .leading){
                                        
                                        
                                        Text(i.goalName)
                                            .padding(.bottom, 5)
                                            .fontWeight(.light)
                                        
                                        
                                        //MARK: new progress bar
                                        
                                        ZStack{
                                            
                                            HStack{
                                                RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).frame(width: 200, height: 12).opacity(0.3)
                                                Spacer()
                                            }
                                            
                                            HStack{
                                                RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .black : .white).frame(width: 200, height: 12)
                                                Spacer()
                                            }.mask{
                                                
                                                HStack{
                                                    
                                                    Rectangle().frame(width: getGoalHoursChartWidth(goal: i), height: 12)
                                                    Spacer()
                                                }
                                            }
                                            
                                        }.offset(x:-2)
                                        
                                        
                                        //MARK: old progress bar
                                        /*
                                         ZStack{
                                         
                                         HStack{
                                         RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).frame(width: 200, height: 20).opacity(0.2)
                                         Spacer()
                                         }
                                         
                                         HStack{
                                         
                                         RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .black : .white).frame(width: getGoalHoursChartWidth(goal: i), height: 20)
                                         Spacer()
                                         }
                                         
                                         }
                                         */
                                        Text("PROGRESS: \(i.hoursCompleted ?? 0) / \(i.goalHours ?? 0) \(i.goalHours == 1 ? "HOUR" : "HOURS")").fontWeight(.light).foregroundStyle(.gray).font(.caption2)
                                        
                                        let completed = Double(i.hoursCompleted ?? 0)
                                        let total = Double(i.goalHours ?? 1) // Avoid zero division by setting fallback to 1
                                        
                                        
                                        let rawPercent = (completed / total) * 100
                                        let flooredPercent = Int(floor(rawPercent))
                                        
                                        let displayedPercent = flooredPercent > 100 ? 100 : flooredPercent
                                        
                                        Text("\(displayedPercent)% Complete")
                                            .foregroundStyle(colorScheme == .light ? .black : .white)
                                            .font(.subheadline).fontWeight(.light).padding(.top, 3)
                                        
                                    }.padding(.horizontal).padding(.vertical)
                                    Spacer()
                                    
                                }.padding(.leading).padding(.top, 2)
                            }
                            
                            
                            ForEach(goalManager.myGoals
                                .sorted(by: { $0.goalName < $1.goalName })
                                .filter({ $0.goalType == "Action Based"
                                })
                            ) {i in
                                ZStack{
                                    HStack{
                                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                        Spacer()
                                    }
                                    VStack{
                                        
                                        
                                        HStack{
                                            Text(i.goalName)
                                                .padding(.bottom, 5)
                                                .fontWeight(.light)
                                            Spacer()
                                        }
                                        HStack{
                                            Image(systemName: "checkmark.circle.fill").foregroundStyle(colorScheme == .light ? .black : .white).fontWeight(.light)
                                            Text("Completions: \(i.totalCompletions ?? 0)").font(.subheadline).fontWeight(.light)
                                            Spacer()
                                        }
                                        
                                        
                                    }.padding()
                                    Spacer()
                                    
                                }.padding(.leading)
                                    .padding(.top, 2)
                            }
                            
                            let filteredGoalCheck = goalManager.myGoals.filter({$0.goalType == "Action Based" || $0.goalType == "Hour Based"})
                            if filteredGoalCheck.isEmpty {
                                HStack{
                                    ZStack{
                                        RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 350, height: 250).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                    }.overlay {
                                        
                                        ContentUnavailableView("No Recent Data", systemImage: "trophy.fill", description: Text("Create a new Goal Tracking entry that is either Action or Hour Based to begin charting data.")).frame(height: 300).scaleEffect(0.9)
                                    }
                                    .padding(.leading)
                                    Spacer()
                                }
                            }
                            
                            Spacer()
                        }
                        .padding(.bottom, 50)
                        .onAppear{
                            journalManager.getAllJournalEntries()
                            //print(journalManager.journalEntries)
                        }
                        
                    }.scrollIndicators(.hidden)
                    
                }.sheet(isPresented: $showProtectYourDataView, content: {
                    ProtectYourDataView()
                })
                .sheet(isPresented: $showLocalNotificationsView, content: {
                    LocalNotificationsView()
                })
                
            }
        } else {
            ZStack{
                backgroundColor.ignoresSafeArea()
                VStack(spacing: 0){
                    
                    VStack{
                        ZStack{
                            HStack{
                                Image(systemName: "chart.pie.fill").font(.title3)
                                insightsText.font(.title3).bold()
                                Spacer()
                            }.padding(.leading)
                            
                            HStack{
                                Spacer()
                                Menu {
                                    
                                    Button {
                                        authenticateWithBiometrics { success, error in
                                            if success {
                                                journalLock.isLocked.toggle()
                                                journalLock.justSet = true
                                            } else {
                                                print("error authenticating")
                                            }
                                        }
                                    }label: {
                                        Text(journalLock.isLocked ? "Unlock Journal" : "Lock Journal on Launch")
                                        Image(systemName: journalLock.isLocked ? "lock" : "lock.open")
                                    }
                                    Button{
                                        showProtectYourDataView.toggle()
                                    }label: {
                                        Text("How We Protect Your Data")
                                        Image(systemName: "info.circle")
                                    }
                                    
                                    Button{
                                        showLocalNotificationsView.toggle()
                                    }label:{
                                        Text("Notifications")
                                        Image(systemName: "bell")
                                    }
                                    
                                }label: {
                                    menuButton
                                }.offset(y:-1)
                            }
                        }.padding(.bottom, 5)
                    }
                    
                    Divider()
                    
                    ScrollView {
                        
                        Spacer().frame(height: 20)
                        
                        VStack {
                            
                            
                            HStack{ //ipad row 1 starts
                                //MARK: streaks
                                VStack{
                                    HStack {
                                        
                                        streaksText
                                            .onAppear{
                                                journalManager.getAllJournalEntries()
                                                
                                                calculateMoodStreak()
                                                calculateGratitudeStreak()
                                                calculateGoalsStreak()
                                                calculateMomentsStreak()
                                            }
                                            .onChange(of: journalManager.journalEntries) {
                                                journalManager.getAllJournalEntries()
                                                
                                                calculateMoodStreak()
                                                calculateGratitudeStreak()
                                                calculateGoalsStreak()
                                                calculateMomentsStreak()
                                            }
                                            .onChange(of: scenePhase) {oldPhase, newPhase in
                                                
                                                if newPhase == .active {
                                                    journalManager.getAllJournalEntries()
                                                    calculateMoodStreak()
                                                    calculateGratitudeStreak()
                                                    calculateGoalsStreak()
                                                    calculateMomentsStreak()
                                                }
                                                
                                            }
                                        
                                        Spacer()
                                        
                                    }.padding(.horizontal).padding(.top)
                                    
                                    
                                    VStack{
                                        HStack{
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                
                                                
                                                VStack{
                                                    Image(systemName: "cloud.sun")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 17).padding(.bottom, 3).fontWeight(.light)
                                                    
                                                    Text("Check-In")
                                                        .font(.subheadline)
                                                    Text("\(moodStreak) \(moodStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                                    
                                                }.padding()
                                            }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            
                                            
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                VStack{
                                                    Image(systemName: "heart")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 15)
                                                        .padding(.bottom, 3)
                                                        .fontWeight(.light)
                                                    
                                                    Text("Gratitude")
                                                        .font(.subheadline)
                                                    
                                                    
                                                    Text("\(gratitudeStreak) \(gratitudeStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                                    
                                                }.padding()
                                            }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            Spacer()
                                        }.font(.caption).padding(.leading)
                                        
                                        
                                        HStack{
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                VStack{
                                                    Image(systemName: "chart.line.uptrend.xyaxis")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 15)
                                                        .padding(.bottom, 3)
                                                        .fontWeight(.light)
                                                    
                                                    Text("Goals").font(.subheadline)
                                                    Text("\(goalsStreak) \(goalsStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                                    
                                                }.padding()
                                            }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            
                                            ZStack{
                                                RoundedRectangle(cornerRadius: 10).frame(width: 120, height: 100).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                
                                                
                                                VStack{
                                                    Image(systemName: "camera")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .frame(height: 15).padding(.bottom, 3).fontWeight(.light)
                                                    
                                                    Text("Moments")
                                                        .font(.subheadline)
                                                    Text("\(momentsStreak) \(momentsStreak == 1 ? "DAY" : "DAYS")").font(.caption).foregroundStyle(.gray).minimumScaleFactor(0.75)
                                                    
                                                }.padding()
                                            }.fontWeight(.light).opacity(0.9).frame(width: 120, height: 100).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            
                                            Spacer()
                                        }.font(.caption).padding(.leading)
                                    }
                                    Spacer()
                                }
                                //MARK: writing analytics
                                
                                VStack{
                                    HStack {
                                        
                                        
                                        writingAnalyticsText
                                        Spacer()
                                        
                                    }.padding(.horizontal).padding(.top)
                                    
                                    
                                    ZStack{
                                        HStack{
                                            RoundedRectangle(cornerRadius: 10).frame(width: 250, height: 120).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            Spacer()
                                        }
                                        VStack {
                                            
                                            totalEntriesTextAndImage
                                            wordsWrittenTextAndImage
                                            daysJournaledTextAndImage
                                            
                                        }.font(.caption).fontWeight(.light).padding().opacity(0.9).padding(.leading)
                                    }
                                    Spacer()
                                }
                                
                                Spacer()
                                
                            } //ipad row 1 ends
                            
                            HStack{ //ipad 2nd row starts
                                
                                //MARK: mood analytics ipad
                                VStack{
                                    HStack {
                                        
                                        moodAnalyticsText
                                        Spacer()
                                        
                                    }.padding(.top).padding(.horizontal).padding(.top, 5)
                                    
                                    
                                    //MARK: mood analytics chart
                                    HStack{
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 350, height: 410).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            chartTabView.padding([.leading, .trailing]).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                        }
                                        Spacer()
                                    }
                                    Spacer()
                                }
                                
                                //MARK: timeline chart
                                VStack{
                                    HStack {
                                        
                                        chartTimelineText
                                        Spacer()
                                        
                                    }.padding(.top).padding(.horizontal)
                                    
                                    
                                    HStack{
                                        ZStack{
                                            RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 350, height: 340).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                            
                                            if timelineDictionary.count >= 2 {
                                                HStack{
                                                    Chart {
                                                        ForEach(timelineDictionary.sorted(by: { $0.key < $1.key }), id: \.key) { date, avgMood in
                                                            
                                                            PointMark(
                                                                x: .value("Date", date),
                                                                y: .value("Mood", avgMood)
                                                            ).foregroundStyle(colorScheme == .light ? .black : .white)
                                                            
                                                            LineMark(
                                                                x: .value("Date", date),
                                                                y: .value("Mood", avgMood)
                                                            ).foregroundStyle(colorScheme == .light ? .black : .white)
                                                        }
                                                    }
                                                    .padding(.trailing)
                                                    .chartXAxis {
                                                        
                                                        //if more than 7 dqys has passed from first to last entry, then stride count 7 otherwise 1
                                                        
                                                        
                                                        
                                                        //**preset: .aligned maintains labels not getting cut-off in view, while also maintaing amount of gride lines structure with .stride
                                                        AxisMarks(preset: .aligned, values: .stride(by: .day, count: strideCount)) { value in
                                                            AxisTick()
                                                            AxisGridLine()
                                                            AxisValueLabel {
                                                                
                                                                Text(value.as(Date.self)!.formatted(.dateTime.month(.defaultDigits).day()))
                                                                    .font(.caption)
                                                                    .rotationEffect(Angle(degrees: 45))
                                                                    .padding(.top, 15)
                                                                
                                                                
                                                                
                                                                
                                                            }
                                                        }
                                                    }
                                                    .chartYScale(domain: 1...5)
                                                    .chartYAxis(.hidden)
                                                    .frame(width: 220, height: 240)
                                                    
                                                    VStack {
                                                        
                                                        Image(colorScheme == .light ? "great" : "greatWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                        Spacer()
                                                        Image(colorScheme == .light ? "happy" : "happyWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                        Spacer()
                                                        Image(colorScheme == .light ? "average" : "averageWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                        Spacer()
                                                        Image(colorScheme == .light ? "sad" : "sadWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5)
                                                        Spacer()
                                                        Image(colorScheme == .light ? "terrible" : "terribleWhite").resizable().frame(width: 30, height: 30).padding(.vertical, 5).padding(.bottom, 20)
                                                        Spacer()
                                                    }.frame(width: 30, height: 290).offset(x:10)
                                                    
                                                    
                                                }
                                            } else {
                                                
                                                HStack{
                                                    VStack{
                                                        
                                                        ContentUnavailableView("No Recent Data", systemImage: "chart.xyaxis.line", description: Text("Create at least two Mood Check-In entries on separate days within a 30-day period to begin charting data.")).scaleEffect(0.9)
                                                    }.frame(width: 340, height: 340)
                                                }
                                            }
                                            
                                            
                                        }.onAppear {
                                            journalManager.getAllJournalEntries()
                                            
                                            // Filter journal entries to only include entries with non-empty moods
                                            
                                            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                                            
                                            let filteredEntries = journalManager.journalEntries.filter { !$0.mood.isEmpty && $0.date >= thirtyDaysAgo }
                                            
                                            
                                            
                                            
                                            let groupedByDate = Dictionary(grouping: filteredEntries) { entry in
                                                Calendar.current.startOfDay(for: entry.date)
                                            }
                                            //groups unique date with value being an array of all associated entries
                                            
                                            for (date, entries) in groupedByDate {
                                                
                                                let moodValues = entries.compactMap { valueForMood($0.mood) }  //put each days entries into a mood values array.
                                                
                                                let averageMood = moodValues.isEmpty ? 0 : moodValues.reduce(0, +) / moodValues.count  // Calculate average of moods from the array.
                                                
                                                timelineDictionary[date] = averageMood  // Assign the average mood value to the dictionary for that unique date
                                                
                                            }
                                            
                                            
                                            
                                            
                                        }
                                        .onChange(of: journalManager.journalEntries){
                                            
                                            timelineDictionary = [:]
                                            
                                            journalManager.getAllJournalEntries()
                                            
                                            // Filter journal entries to only include entries with non-empty moods
                                            
                                            let thirtyDaysAgo = Calendar.current.date(byAdding: .day, value: -30, to: Date())!
                                            
                                            let filteredEntries = journalManager.journalEntries.filter { !$0.mood.isEmpty && $0.date >= thirtyDaysAgo }
                                            
                                            
                                            
                                            
                                            let groupedByDate = Dictionary(grouping: filteredEntries) { entry in
                                                Calendar.current.startOfDay(for: entry.date)
                                            }
                                            //groups unique date with value being an array of all associated entries
                                            
                                            for (date, entries) in groupedByDate {
                                                
                                                let moodValues = entries.compactMap { valueForMood($0.mood) }  //put each days entries into a mood values array.
                                                
                                                let averageMood = moodValues.isEmpty ? 0 : moodValues.reduce(0, +) / moodValues.count  // Calculate average of moods from the array.
                                                
                                                timelineDictionary[date] = averageMood  // Assign the average mood value to the dictionary for that unique date
                                                
                                            }
                                        }
                                        .onChange(of: timelineDictionary) {
                                            if !timelineDictionary.isEmpty {
                                                // Sort the dictionary by the Date key (chronologically)
                                                let sortedTimeline = timelineDictionary.sorted(by: { $0.key < $1.key })
                                                
                                                // Safely unwrap first and last entry
                                                if let earliestDate = sortedTimeline.first?.key, let lastDate = sortedTimeline.last?.key {
                                                    // Calculate the total days between the earliest and latest date
                                                    let totalDays = Calendar.current.dateComponents([.day], from: earliestDate, to: lastDate).day ?? 0
                                                    
                                                    // Adjust strideCount based on the total days difference
                                                    strideCount = totalDays > 7 ? 7 : 1
                                                }
                                            }
                                        }
                                        Spacer()
                                    }.padding(.leading)
                                    Spacer()
                                }
                          
                                Spacer()
                            }
                            //ipad row 2 ends above }
                            
                            //ipad 3rd row
                            HStack{
                                
                                 //MARK: goals
                                 VStack{
                                 HStack {
                                     
                                     goalProgressionText.onAppear{
                                         goalManager.getAllGoals()
                                     }
                                     Spacer()
                                     
                                 }.padding(.top).padding(.horizontal)
                                 
                                 
                               
                                     //MARK: goal charts
                                     
                                     ForEach(goalManager.myGoals
                                         .sorted(by: { $0.goalName < $1.goalName })
                                         .filter({ $0.goalType == "Hour Based"
                                         })
                                     ) {i in
                                         ZStack{
                                             HStack{
                                                 RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                 Spacer()
                                             }
                                             VStack(alignment: .leading){
                                                 
                                                 
                                                 Text(i.goalName)
                                                     .padding(.bottom, 5)
                                                     .fontWeight(.light)
                                                 
                                                 
                                                 //MARK: new progress bar
                                                 
                                                 ZStack{
                                                     
                                                     HStack{
                                                         RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).frame(width: 200, height: 12).opacity(0.3)
                                                         Spacer()
                                                     }
                                                     
                                                     HStack{
                                                         RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .black : .white).frame(width: 200, height: 12)
                                                         Spacer()
                                                     }.mask{
                                                         
                                                         HStack{
                                                             
                                                             Rectangle().frame(width: getGoalHoursChartWidth(goal: i), height: 12)
                                                             Spacer()
                                                         }
                                                     }
                                                     
                                                 }.offset(x:-2)
                                                 
                                                 
                                                 //MARK: old progress bar
                                                 /*
                                                  ZStack{
                                                  
                                                  HStack{
                                                  RoundedRectangle(cornerRadius: 10).foregroundStyle(.gray).frame(width: 200, height: 20).opacity(0.2)
                                                  Spacer()
                                                  }
                                                  
                                                  HStack{
                                                  
                                                  RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .black : .white).frame(width: getGoalHoursChartWidth(goal: i), height: 20)
                                                  Spacer()
                                                  }
                                                  
                                                  }
                                                  */
                                                 Text("PROGRESS: \(i.hoursCompleted ?? 0) / \(i.goalHours ?? 0) \(i.goalHours == 1 ? "HOUR" : "HOURS")").fontWeight(.light).foregroundStyle(.gray).font(.caption2)
                                                 
                                                 let completed = Double(i.hoursCompleted ?? 0)
                                                 let total = Double(i.goalHours ?? 1) // Avoid zero division by setting fallback to 1
                                                 
                                                 
                                                 let rawPercent = (completed / total) * 100
                                                 let flooredPercent = Int(floor(rawPercent))
                                                 
                                                 let displayedPercent = flooredPercent > 100 ? 100 : flooredPercent
                                                 
                                                 Text("\(displayedPercent)% Complete")
                                                     .foregroundStyle(colorScheme == .light ? .black : .white)
                                                     .font(.subheadline).fontWeight(.light).padding(.top, 3)
                                                 
                                             }.padding(.horizontal).padding(.vertical)
                                             Spacer()
                                             
                                         }.padding(.leading).padding(.top, 2)
                                     }
                                     
                                     
                                     ForEach(goalManager.myGoals
                                         .sorted(by: { $0.goalName < $1.goalName })
                                         .filter({ $0.goalType == "Action Based"
                                         })
                                     ) {i in
                                         ZStack{
                                             HStack{
                                                 RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 300).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                 Spacer()
                                             }
                                             VStack{
                                                 
                                                 
                                                 HStack{
                                                     Text(i.goalName)
                                                         .padding(.bottom, 5)
                                                         .fontWeight(.light)
                                                     Spacer()
                                                 }
                                                 HStack{
                                                     Image(systemName: "checkmark.circle.fill").foregroundStyle(colorScheme == .light ? .black : .white).fontWeight(.light)
                                                     Text("Completions: \(i.totalCompletions ?? 0)").font(.subheadline).fontWeight(.light)
                                                     Spacer()
                                                 }
                                                 
                                                 
                                             }.padding()
                                             Spacer()
                                             
                                         }.padding(.leading)
                                             .padding(.top, 2)
                                     }
                                     
                                     let filteredGoalCheck = goalManager.myGoals.filter({$0.goalType == "Action Based" || $0.goalType == "Hour Based"})
                                     if filteredGoalCheck.isEmpty {
                                         HStack{
                                             ZStack{
                                                 RoundedRectangle(cornerRadius: 10).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(width: 350, height: 250).shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                             }.overlay {
                                                 
                                                 ContentUnavailableView("No Recent Data", systemImage: "trophy.fill", description: Text("Create a new Goal Tracking entry that is either Action or Hour Based to begin charting data.")).frame(height: 300).scaleEffect(0.9)
                                             }
                                             .padding(.leading)
                                             Spacer()
                                         }
                                     }
                                     Spacer()
                                 }
                            }
                            //3rd row ends above
                        }
                        .padding(.bottom, 50)
                        .onAppear{
                            journalManager.getAllJournalEntries()
                            //print(journalManager.journalEntries)
                        }
                        
                    }.scrollIndicators(.hidden)
                    
                }.sheet(isPresented: $showProtectYourDataView, content: {
                    ProtectYourDataView()
                })
                .sheet(isPresented: $showLocalNotificationsView, content: {
                    LocalNotificationsView()
                })
                
            }
        }
    }
    
    func emojiForMood(_ mood: String) -> String {
            switch mood {
            case "terrible", "Terrible", "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing",
                "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty":
                return "terrible"
            case "sad", "Bad", "Sad", "Disappointed", "Frustrated", "Angry", "Irritated",
                "Unmotivated", "Down", "Bitter", "Dismal", "Tired":
                return "sad"
            case "average", "Average", "Calm", "Indifferent", "Meh", "Okay", "Content",
                "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired":
                return "average"
            case "happy", "Good", "Happy", "Optimistic", "Confident", "Motivated", "Cheerful",
                "Excited", "Proud", "Thankful", "Energized", "Relaxed":
                return "happy"
            case "great", "Great", "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated",
                "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased":
                return "great"
            default:
                return "❓"
            }
        }
    
    func valueForMood(_ mood: String) -> Int {
            switch mood {
            case "terrible", "Terrible", "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing",
                "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty":
                return 1
            case "sad", "Sad", "Bad", "Disappointed", "Frustrated", "Angry", "Irritated",
                "Unmotivated", "Down", "Bitter", "Dismal", "Tired":
                return 2
            case "average", "Average", "Calm", "Indifferent", "Meh", "Okay", "Content",
                "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired":
                return 3
            case "happy", "Happy", "Good", "Optimistic", "Confident", "Motivated", "Cheerful",
                "Excited", "Proud", "Thankful", "Energized", "Relaxed":
                return 4
            case "great", "Great", "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated",
                "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased":
                return 5
            default:
                return 0
            }
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
    
    var backgroundColor: some View {
        Color.gray.opacity(0.1)
    }
    
    var insightsText: some View {
        Text("Insights")
    }
    
    var streaksText: some View {
        Text("Streaks").fontWeight(.light).font(.title3)
    }
    
    var goalProgressionText: some View {
        Text("Goal Progression").fontWeight(.light).font(.title3)
    }
    
    var writingAnalyticsText: some View {
        Text("Writing Analytics").fontWeight(.light).font(.title3)
    }
    
    var totalEntriesTextAndImage: some View {
        HStack{
            HStack{
                Image(systemName: "book.fill").opacity(0.8)
                Text(String(journalManager.journalEntries.count))
            }.font(.subheadline)
            
            Text("Total \(journalManager.journalEntries.count == 1 ? "Entry" : "Entries")")
            Spacer()
        }.frame(height: 25)
    }
    
    var wordsWrittenTextAndImage: some View {
        HStack{
            HStack{
                Image(systemName: "chart.line.uptrend.xyaxis").opacity(0.8)
                Text(String(journalManager.totalWords()))
            }.font(.subheadline)
            
            Text("\(journalManager.totalWords() == 1 ? "Word" : "Words") Written")
            Spacer()
        }.frame(height: 25)
    }
    
    var daysJournaledTextAndImage: some View {
        HStack{
            HStack{
                Image(systemName: "calendar").opacity(0.8)
                Text(String(journalManager.numberOfDaysJournaled()))
                
            }.font(.subheadline)
            
            Text("\(journalManager.numberOfDaysJournaled() == 1 ? "Day" : "Days") Journaled")
            Spacer()
        }.frame(height: 25)
    }
    
    var moodAnalyticsText: some View {
        Text("Mood Analytics").fontWeight(.light).font(.title3)
    }
    
    var chartTimelineText: some View {
        Text("30-Day Mood Timeline").fontWeight(.light).font(.title3)
    }

    
    var chartTabView: some View {
        
        TabView {
            
            if totalMoodCount > 0 {
                ZStack{
                    VStack{
                        HStack{
                            Text("All-Time").fontWeight(.light).opacity(0.75).padding(.top, 20)
                            Spacer()
                        }.padding(.horizontal)
                        Spacer()
                    }
                    ZStack{
                        Chart{
                            ForEach(Array(moodGroups.filter { $0.value > 0 && fixedMoodOrder.contains($0.key) }).sorted{
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key){ mood, count in
                                SectorMark(
                                    angle: .value("Count", count),  // Use count to determine the size of each sector
                                    innerRadius: .ratio(0.9),       // Adjust for a donut chart effect
                                    angularInset: 2                 // Spacing between sectors
                                )
                                .foregroundStyle(colorForMood(mood))
                                
                                
                            }
                        }
                        .chartLegend(.hidden)
                        .frame(width: 280, height: 280)
                        
                        
                        VStack {
                            
                            ForEach(Array(moodGroups.filter { $0.value > 0 && fixedMoodOrder.contains($0.key) }).sorted {
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key) { mood, count in
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 30).foregroundStyle(colorForMood(mood)).opacity(0.1)
                                    HStack {
                                        Image(emojiForMood(mood))
                                            .renderingMode(.template)
                                            .resizable()
                                                .frame(width: 23, height: 23)
                                                .foregroundStyle(colorForMood(mood))
                                            
                                        Text("\(String(format: "%.0f", Double(count) / Double(totalMoodCount) * 100))%").fontWeight(.light)
                                       .font(.body)
                                           
                                    }
                                }
                                
                            }
                        }
                        .padding()
                        
                        
                    }
                }
                
            } else {
                unavailableAllTimeView

            }
            
            if totalMoodCountForWeek > 0 {
                
                ZStack {
                    VStack{
                        HStack {
                            
                            Text("Previous 7 Days").fontWeight(.light).opacity(0.75).padding(.top, 20)
                            Spacer()
                            
                        }.padding(.horizontal)
                        Spacer()
                    }
                    
                    ZStack {
                        
                        Chart {
                            ForEach(Array(moodGroupsForWeek.filter {
                                //5 moods
                                $0.value > 0 && fixedMoodOrder.contains($0.key) }).sorted{
                                    fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                                }, id: \.key) { mood, count in
                                SectorMark(
                                    angle: .value("Count", count),
                                    innerRadius: .ratio(0.9),
                                    angularInset: 2
                                )
                                .foregroundStyle(colorForMood(mood))
                                
                            }
                        }
                        .chartLegend(.hidden)
                        .frame(width: 280, height: 280)
                        
                        
                        VStack {
                            
                            ForEach(Array(moodGroupsForWeek.filter { $0.value > 0 && fixedMoodOrder.contains($0.key)}).sorted {
                                //for ech of the 5 moods that exist
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key) { mood, count in
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 30).foregroundStyle(colorForMood(mood)).opacity(0.1)
                                    HStack {
                                        Image(emojiForMood(mood))
                                            .renderingMode(.template)
                                            .resizable()
                                                .frame(width: 23, height: 23)
                                                .foregroundStyle(colorForMood(mood))
                                        //mood emoji
                                        Text("\(String(format: "%.0f", Double(count) / Double(totalMoodCountForWeek) * 100))%").fontWeight(.light)
                                            .font(.body)
                                            //percent
                                        //right now every added cuts by 50%
                                        //count (of the 5 mood types) / totalMoodCount (ALL entries in last week)
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                
            } else {
               unavailable7DayView
            }
            
            if totalMoodCountForLast30Days > 0 {
                ZStack {
                    VStack{
                        HStack {
                            Text("Previous 30 Days").fontWeight(.light).opacity(0.75).padding(.top, 20)
                            
                            Spacer()
                        }.padding(.horizontal)
                        Spacer()
                    }
                    
                    ZStack {
                        Chart {
                            ForEach(Array(moodGroupsForLast30Days.filter { $0.value > 0 && fixedMoodOrder.contains($0.key) }).sorted{
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key) { mood, count in
                                SectorMark(
                                    angle: .value("Count", count),
                                    innerRadius: .ratio(0.9),
                                    angularInset: 2
                                )
                                .foregroundStyle(colorForMood(mood))
                                
                            }
                        }
                        .chartLegend(.hidden)
                        .frame(width: 280, height: 280)
                        
                        
                        VStack {
                            
                            ForEach(Array(moodGroupsForLast30Days.filter { $0.value > 0 && fixedMoodOrder.contains($0.key)}).sorted {
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key) { mood, count in
                                
                                ZStack{
                                    RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 30).foregroundStyle(colorForMood(mood)).opacity(0.1)
                                    HStack {
                                        Image(emojiForMood(mood))
                                            .renderingMode(.template)
                                            .resizable()
                                                .frame(width: 23, height: 23)
                                                .foregroundStyle(colorForMood(mood))
                                        Text("\(String(format: "%.0f", Double(count) / Double(totalMoodCountForLast30Days) * 100))%").fontWeight(.light)
                                            .font(.body)
                                           
                                    }
                                    
                                    
                                }
                                
                            }
                        }
                    }
                    
                }
                
            } else {
               unavailable30DayView
            }
            
            if totalMoodCountForLastYear > 0 {
                
                ZStack {
                    VStack{
                        HStack {
                            
                            Text("Previous Year").fontWeight(.light).opacity(0.75).padding(.top, 20)
                            
                            Spacer()
                            
                        }.padding(.horizontal)
                        Spacer()
                    }
                    
                    ZStack {
                        Chart {
                            ForEach(Array(moodGroupsForLastYear.filter { $0.value > 0 && fixedMoodOrder.contains($0.key)}).sorted{
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key) { mood, count in
                                SectorMark(
                                    angle: .value("Count", count),
                                    innerRadius: .ratio(0.9),
                                    angularInset: 2
                                )
                                .foregroundStyle(colorForMood(mood))
                                
                            }
                        }
                        .chartLegend(.hidden)
                        .frame(width: 280, height: 280)
                        
                        
                        VStack {
                            
                            ForEach(Array(moodGroupsForLastYear.filter { $0.value > 0 && fixedMoodOrder.contains($0.key)}).sorted {
                                fixedMoodOrder.firstIndex(of: $0.key)! < fixedMoodOrder.firstIndex(of: $1.key)!
                            }, id: \.key) { mood, count in
                                
                                ZStack {
                                    RoundedRectangle(cornerRadius: 10).frame(width: 100, height: 30).foregroundStyle(colorForMood(mood)).opacity(0.1)
                                    HStack {
                                        Image(emojiForMood(mood))
                                            .renderingMode(.template)
                                            .resizable()
                                                .frame(width: 23, height: 23)
                                                .foregroundStyle(colorForMood(mood))
                                        Text("\(String(format: "%.0f", Double(count) / Double(totalMoodCountForLastYear) * 100))%").fontWeight(.light)
                                            .font(.body)
                                           
                                    }
                                }
                                
                            }
                        }
                    }
                    
                }
                
            } else {
                unavailableYearDataView
            }
            
        }.tabViewStyle(PageTabViewStyle()).frame(width: 350, height: 400).onAppear{
            UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.primary)
                   UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
        }


    }
    
    var menuButton: some View {
        ZStack{
            Rectangle().foregroundStyle(.clear).frame(width: 80, height: 50)
            Image(systemName: "slider.horizontal.3").bold().font(.body).foregroundStyle(.gray).opacity(0.5)
        }
    }
    
    func authenticateWithBiometrics(completion: @escaping (Bool, Error?) -> Void) {
        let context = LAContext()
        var error: NSError?
        
        // Check if biometric authentication is available
        if context.canEvaluatePolicy(.deviceOwnerAuthentication, error: &error) {
            let reason = "Authenticate using Face ID, Touch ID, or passcode."
            
            // Request biometric authentication
            context.evaluatePolicy(.deviceOwnerAuthentication, localizedReason: reason) { success, authenticationError in
                DispatchQueue.main.async {
                    if success {
                        completion(true, nil)
                    } else {
                        completion(false, authenticationError)
                    }
                }
            }
        } else {
            completion(false, error)
        }
    }
    
    var unavailableYearDataView: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Previous Year").fontWeight(.light).opacity(0.75).padding(.top, 20)
                    Spacer()
                }.padding(.horizontal)
                Spacer()
            }
            ContentUnavailableView("No Recent Data", systemImage: "chart.pie.fill", description: Text("Create a new Mood Check-In entry to begin charting data.")).scaleEffect(0.9)
        }.frame(height: 400)
    }
    
    var unavailable30DayView: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Previous 30 Days").fontWeight(.light).opacity(0.75).padding(.top, 20)
                    Spacer()
                }.padding(.horizontal)
                Spacer()
            }
            ContentUnavailableView("No Recent Data", systemImage: "chart.pie.fill", description: Text("Create a new Mood Check-In entry to begin charting data.")).scaleEffect(0.9)
        }.frame(height: 400)
    }
    
    var unavailable7DayView: some View {
        ZStack{
            VStack{
                HStack{
                    Text("Previous 7 Days").fontWeight(.light).opacity(0.75).padding(.top, 20)
                    Spacer()
                }.padding(.horizontal)
                Spacer()
            }
            ContentUnavailableView("No Recent Data", systemImage: "chart.pie.fill", description: Text("Create a new Mood Check-In entry to begin charting data.")).scaleEffect(0.9)
        }.frame(height: 400)
    }
    
    var unavailableAllTimeView: some View {
        ZStack{
            VStack{
                HStack{
                    Text("All-Time").fontWeight(.light).opacity(0.75).padding(.top, 20)
                    Spacer()
                }.padding(.horizontal)
                Spacer()
            }
            ContentUnavailableView("No Recent Data", systemImage: "chart.pie.fill", description: Text("Create a new Mood Check-In entry to begin charting data.")).scaleEffect(0.9)
        }.frame(height: 400)
    }
    
    func calculateMoodStreak() {
        
        let filteredEntries = journalManager.journalEntries.filter { !$0.mood.isEmpty }
        print(filteredEntries.count)

              // Step 2: Sort entries by date (newest first)
              let sortedEntries = filteredEntries.sorted { $0.date > $1.date }
        print(sortedEntries.count)
        
        var previousDate:Date?
        var streak = 0
        
        for entry in sortedEntries {
            //going from NEWEST to oldest.
            print(entry.date)
            
            
            if let existingPreviousDate = previousDate {
                
                
                //compare the dates and add 1 to moodStreak
                if let followingDay = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                   Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                    
                    //next recent entry a day separate? add 1 to streak.
                    
                    streak += 1
                    print(streak)
                    
                    //what if it's another entry on the same day? just add zero?
                } else if let followingDay = Calendar.current.date(byAdding: .day, value: 0, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                          Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                           
                           //next recent entry a day separate? add 1 to streak.
                           
                           streak += 0
                           print(streak)
                           
                           //what if it's another entry on the same day? just add zero?
                } else {
                    //not 1 day after?
                    //AND not same day?
                    //means a day has been missed.
                    break
                    
                }
   
                
            } else {
                //first round of the loop will give 1 since no previous date is found, so adds that first 1 automatically.

               streak = 1
                
            }
            previousDate = entry.date
            print(previousDate == nil)
            //set each iterations date to be the previous date to compare with the next entry iteration.
        }
        
        if let existingFirstEntry = sortedEntries.first?.date {
            
            let startOfFirstEntry = Calendar.current.startOfDay(for: existingFirstEntry)
               let startOfNow = Calendar.current.startOfDay(for: Date.now)
            
            let daysDifference = Calendar.current.dateComponents([.day], from: startOfFirstEntry, to: startOfNow).day ?? 0
            print("difference of days : \(daysDifference)")
            
            print("first entry date: \(startOfFirstEntry)")
            print("todays date: \(startOfNow)")
            self.moodStreak = daysDifference > 1 ? 0 : streak
        }else {
            self.moodStreak = 0
        }
        
    }
    

    func calculateGratitudeStreak() {
        
        let filteredEntries = journalManager.journalEntries.filter { $0.entryType == "Gratitude" }
        print(filteredEntries.count)

              // Step 2: Sort entries by date (newest first)
              let sortedEntries = filteredEntries.sorted { $0.date > $1.date }
        print(sortedEntries.count)
        
        var previousDate:Date?
        var streak = 0
        
        for entry in sortedEntries {
            //going from NEWEST to oldest.
            
            if let existingPreviousDate = previousDate {
                
                
                //compare the dates and add 1 to moodStreak
                if let followingDay = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                   Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                    
                    //next recent entry a day separate? add 1 to streak.
                    
                    streak += 1
                    //print(streak)
                    
                    //what if it's another entry on the same day? just add zero?
                } else if let followingDay = Calendar.current.date(byAdding: .day, value: 0, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                          Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                           
                           //next recent entry a day separate? add 1 to streak.
                           
                           streak += 0
                           //print(streak)
                           
                           //what if it's another entry on the same day? just add zero?
                } else {
                    //not 1 day after?
                    //AND not same day?
                    //means a day has been missed.
                    break
                    
                }
   
                
            } else {
                //first round of the loop will give 1 since no previous date is found, so adds that first 1 automatically.

               streak = 1
                
            }
            previousDate = entry.date
            print(previousDate == nil)
            //set each iterations date to be the previous date to compare with the next entry iteration.
        }
        
        if let existingFirstEntry = sortedEntries.first?.date {
            
            let startOfFirstEntry = Calendar.current.startOfDay(for: existingFirstEntry)
               let startOfNow = Calendar.current.startOfDay(for: Date.now)
            
            let daysDifference = Calendar.current.dateComponents([.day], from: startOfFirstEntry, to: startOfNow).day ?? 0
            print("difference of days : \(daysDifference)")
            
            print("first entry date: \(startOfFirstEntry)")
            print("todays date: \(startOfNow)")
            self.gratitudeStreak = daysDifference > 1 ? 0 : streak
        } else {
            self.gratitudeStreak = 0
        }

        
    }
    
    func calculateGoalsStreak() {
        
        let filteredEntries = journalManager.journalEntries.filter { $0.entryType == "Goal" }
        //print(filteredEntries.count)

              // Step 2: Sort entries by date (newest first)
              let sortedEntries = filteredEntries.sorted { $0.date > $1.date }
        //print(sortedEntries.count)
        
        var previousDate:Date?
        var streak = 0
        
        for entry in sortedEntries {
            //going from NEWEST to oldest.
            //print(entry.date)
            
            
            if let existingPreviousDate = previousDate {
                
                
                //compare the dates and add 1 to moodStreak
                if let followingDay = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                   Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                    
                    //next recent entry a day separate? add 1 to streak.
                    
                    streak += 1
                    print(streak)
                    
                    //what if it's another entry on the same day? just add zero?
                } else if let followingDay = Calendar.current.date(byAdding: .day, value: 0, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                          Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                           
                           //next recent entry a day separate? add 1 to streak.
                           
                           streak += 0
                           print(streak)
                           
                           //what if it's another entry on the same day? just add zero?
                } else {
                    //not 1 day after?
                    //AND not same day?
                    //means a day has been missed.
                    break
                    
                }
   
                
            } else {
                //first round of the loop will give 1 since no previous date is found, so adds that first 1 automatically.

               streak = 1
                
            }
            previousDate = entry.date
            print(previousDate == nil)
            //set each iterations date to be the previous date to compare with the next entry iteration.
        }
        
        if let existingFirstEntry = sortedEntries.first?.date {
            
            let startOfFirstEntry = Calendar.current.startOfDay(for: existingFirstEntry)
               let startOfNow = Calendar.current.startOfDay(for: Date.now)
            
            let daysDifference = Calendar.current.dateComponents([.day], from: startOfFirstEntry, to: startOfNow).day ?? 0
            print("difference of days : \(daysDifference)")
            
            print("first entry date: \(startOfFirstEntry)")
            print("todays date: \(startOfNow)")
            self.goalsStreak = daysDifference > 1 ? 0 : streak
        } else {
            self.goalsStreak = 0
        }
        
    }
    
    func calculateMomentsStreak() {
        
        let filteredEntries = journalManager.journalEntries.filter { $0.entryType == "Photo" }
        //print(filteredEntries.count)

              // Step 2: Sort entries by date (newest first)
              let sortedEntries = filteredEntries.sorted { $0.date > $1.date }
        //print(sortedEntries.count)
        
        var previousDate:Date?
        var streak = 0
        
        for entry in sortedEntries {
            //going from NEWEST to oldest.
            //print(entry.date)
            
            
            if let existingPreviousDate = previousDate {
                
                
                //compare the dates and add 1 to moodStreak
                if let followingDay = Calendar.current.date(byAdding: .day, value: -1, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                   Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                    
                    //next recent entry a day separate? add 1 to streak.
                    
                    streak += 1
                    print(streak)
                    
                    //what if it's another entry on the same day? just add zero?
                } else if let followingDay = Calendar.current.date(byAdding: .day, value: 0, to: Calendar.current.startOfDay(for: existingPreviousDate)),
                          Calendar.current.isDate(Calendar.current.startOfDay(for: entry.date), inSameDayAs: followingDay) {
                           
                           //next recent entry a day separate? add 1 to streak.
                           
                           streak += 0
                           print(streak)
                           
                           //what if it's another entry on the same day? just add zero?
                } else {
                    //not 1 day after?
                    //AND not same day?
                    //means a day has been missed.
                    break
                    
                }
   
                
            } else {
                //first round of the loop will give 1 since no previous date is found, so adds that first 1 automatically.

               streak = 1
                
            }
            previousDate = entry.date
            print(previousDate == nil)
            //set each iterations date to be the previous date to compare with the next entry iteration.
        }
        
        if let existingFirstEntry = sortedEntries.first?.date {
            
            let startOfFirstEntry = Calendar.current.startOfDay(for: existingFirstEntry)
               let startOfNow = Calendar.current.startOfDay(for: Date.now)
            
            let daysDifference = Calendar.current.dateComponents([.day], from: startOfFirstEntry, to: startOfNow).day ?? 0
            print("difference of days : \(daysDifference)")
            
            print("first entry date: \(startOfFirstEntry)")
            print("todays date: \(startOfNow)")
            self.momentsStreak = daysDifference > 1 ? 0 : streak
        } else {
            self.momentsStreak = 0
        }
        
    }
    
    func getGoalHoursChartWidth(goal: Goal) -> CGFloat {
        let calculateHours = 200 * CGFloat(goal.hoursCompleted ?? 0) / CGFloat(goal.goalHours ?? 0)
        if calculateHours > 200 {
            return 200
        } else {
            return calculateHours
        }
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }

}

#Preview {
    InsightsSheetView(journalManager: JournalManager(), goalManager: GoalManager()).environmentObject(JournalLock())
}
