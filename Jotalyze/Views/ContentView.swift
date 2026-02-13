//
//  ContentView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/11/24.
//

import LocalAuthentication
import StoreKit
import SwiftUI

struct ContentView: View {
    
    @Environment(\.colorScheme) var colorScheme
    @State var journalManager:JournalManager
    @Environment(\.requestReview) var requestReview
    @EnvironmentObject var journalLock: JournalLock
    @State var showEditSheet = false
    @State var showProtectYourDataView = false
    @State var showAnalyzeSheet = false
    @State var selectedJournalEntry: JournalEntry = JournalEntry(id: UUID(), mood: "", title: "", entry: "", date: Date.now)
    @State var calendarViewSelected: Date?
    @State var allSelected = true
    @Binding var showingEntryTypes: Bool
    
    @State var hasScrolled = false
    @State var opacityAmount = 1.0
    
    @State var showLocalNotificationsView: Bool = false
    
    var body: some View {
        
        NavigationStack {
            
            ZStack { // to let new entry button overlay everything
                
                Color.gray.ignoresSafeArea().opacity(0.1)
                
                VStack(spacing: 0) {  //everything in content view
                    
          
                    //immediate cutoff after padding.
                    ZStack{
                 
                        
                       
                        //entries
                        if journalManager.journalEntries.isEmpty {
                            emptyJournalView
                        } else {

                                    VStack {
                                        
                                        ZStack {
                                         
                                            
                                            
                                            ScrollView {
                                                
                                                
                                                //MARK: display calendar
                                                if !journalManager.journalEntries.isEmpty{
                                                  
                                                 
                                                        VStack{
                                                            
                                                       
                                                                ZStack{
                                                                    
                                                                    RoundedRectangle(cornerRadius: 20).foregroundStyle(colorScheme == .light ? .white : darkGrayColor).frame(height: 45).frame(width: 350)
                                                                    
                                                                    
                                                                    ScrollView(.horizontal){
                                                                        
                                                                        HStack(spacing: 3) {
                                                             
                                                                            
                                                                            Button{
                                                                                calendarViewSelected = nil
                                                                                allSelected = true
                                                                            }label: {
                                                                                ZStack{
                                                                                    RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1).frame(width: 70, height: 27).foregroundColor(colorScheme == .light ? .gray : .black).padding(.horizontal, 5).opacity(0.2)
                                                                                        .background(
                                                                                            RoundedRectangle(cornerRadius: 20).frame(width: 70, height: 27).foregroundStyle(colorScheme == .light ? .gray : .black).opacity(allSelected ? (colorScheme == .light ? 0.15 : 0.5) : 0)
                                                                                        )
                                                                                    Text("All").flipsForRightToLeftLayoutDirection(true)
                                                                                        .environment(\.layoutDirection, .rightToLeft)
                                                                                        .opacity(0.5)
                                                                                        .fontWeight(.light)
                                                                                        .font(.system(size: UIScreen.main.bounds.width < 350 ? 12 : 14))
                                                                                    
                                                                                }
                                                                            }.buttonStyle(.plain)
                                                                                .padding(.vertical, 1).padding(.leading, 5)
                                                                            
                                                                            let uniqueEntries = journalManager.journalEntries.sorted(by: { $0.date > $1.date })
                                                                                .reduce(into: [JournalEntry]()) { result, entry in
                                                                                    let calendar = Calendar.current
                                                                                    let entryComponents = calendar.dateComponents([.year, .month, .day], from: entry.date)
                                                                                    if !result.contains(where: {
                                                                                        let resultComponents = calendar.dateComponents([.year, .month, .day], from: $0.date)
                                                                                        return resultComponents == entryComponents
                                                                                    }) {
                                                                                        result.append(entry)
                                                                                    }
                                                                                }
                                                                            
                                                                            //**you can assign a property in any view as long as its assigned before the views that depend on it use it.
                                                                            
                                                                            
                                                                            ForEach(uniqueEntries, id: \.id){i in
                                                                                
                                                                                Button {
                                                                                    
                                                                                    calendarViewSelected = i.date
                                                                                    
                                                                                    print(calendarViewSelected ?? Date())
                                                                                    
                                                                                    allSelected = false
                                                                                    
                                                                                }label:{
                                                                                    ZStack{
                                                                                        RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 1).frame(width: 70, height: 27).foregroundColor(colorScheme == .light ? .gray : .black).padding(.horizontal, 5).opacity(0.2)
                                                                                            .background(
                                                                                                RoundedRectangle(cornerRadius: 20).foregroundStyle(colorScheme == .light ? .gray : .black).frame(width: 70, height: 27).opacity(!allSelected ? returnCalendarColor(entry: i) : 0)
                                                                                                
                                                                                            )
                                                                                        
                                                                                        HStack{
                                                                                            Text(dateAsStringCalendar(entry: i)).opacity(0.5).fontWeight(.light) .font(.system(size: UIScreen.main.bounds.width < 350 ? 12 : 14))
                                                                                                
                                                                                                
                                                                                        }.padding(.horizontal, 5)
                                                                                    }.flipsForRightToLeftLayoutDirection(true)
                                                                                        .environment(\.layoutDirection, .rightToLeft)
                                                                                        .scrollIndicators(.hidden)
                                                                                    
                                                                                }.buttonStyle(.plain).padding(.vertical, 1)
                                                                                
                                                                                
                                                                            }
                                                                            Spacer().frame(width: 2)
                                                                        }
                                                                        
                                                                        
                                                                        
                                                                    }
                                                                    .flipsForRightToLeftLayoutDirection(true)
                                                                    .environment(\.layoutDirection, .rightToLeft)
                                                                    .scrollIndicators(.hidden)
                                                                    .frame(width: 350, height: 45)
                                                                    .clipShape(RoundedRectangle(cornerRadius: 20))
                                                                    
                                                                    
                                                                    
                                                                }.shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                            
                                                            Spacer()
                                                        }.padding(.top, 17)//.opacity(opacityAmount)
                                                        
                                                    
                                                            //.overlay(Color.red)
                                                           
                                                    
                                                    
                                                }
                                                
                                                
                                                
                                                //MARK: display all journal entries
                                                VStack {
                                                    
                                                    //all journal entries filtered by day selected.
                                                    let selectedDayEntries = journalManager.journalEntries.filter{entry in
                                                        //filter/display each entry in a foreach where the following conditional is true about the entry.
                                                        
                                                        let calendar = Calendar.current
                                                        
                                                        return calendar.component(.day, from: entry.date) == calendar.component(.day, from: calendarViewSelected ?? Date()) && calendar.component(.month, from: entry.date) == calendar.component(.month, from: calendarViewSelected ?? Date()) && calendar.component(.year, from: entry.date) == calendar.component(.year, from: calendarViewSelected ?? Date())
                                                        
                                                    }
                                                    
                                                    
                                                    
                                                    if calendarViewSelected != nil && !selectedDayEntries.isEmpty {
                                                        //MARK: if a date is selected display that dates entries
                                                        
                                                        ForEach(selectedDayEntries.sorted(by: { $0.date > $1.date }), id: \.id){i in
                                                            
                                                            DisplayedEntriesView(journalManager: $journalManager, journalEntry: i, selectedJournalEntry: $selectedJournalEntry, showEditSheet: $showEditSheet)
                                                            
                                                            //if you are on that date but no data exists... set calendarViewSelected to nil.
                                                            
                                                            
                                                        }
                                                    } else {
                                                        
                                                        //if all is selected display all
                                                        
                                                        ForEach(journalManager.journalEntries.sorted(by: { $0.date > $1.date }), id: \.id){i in
                                                            DisplayedEntriesView(journalManager: $journalManager, journalEntry: i, selectedJournalEntry: $selectedJournalEntry, showEditSheet: $showEditSheet)
                                                        }
                                                    }
                                                    
                                                }
                                                .background(
                                                    
                                                    GeometryReader { geo in
                                                        Color.clear.ignoresSafeArea()
                                                        /*
                                                            .onChange(of: geo.frame(in: .global).minY) {oldY, newY in
                                                                // Detect if it's at the top more precisely
                                                                //print(newY)

                                                                withAnimation{
                                                                    // Reset when near the top (adjust the threshold if needed)
                                                                    
                                                                    
                                                                    if newY < 176 {
                                                                        
                                                                               opacityAmount -= 0.03
                                                                            
                                                                       } else {
                                                                         
                                                                           opacityAmount = 1.0
                                                                       }
                                                                    
                                                                }
                                                                
                                                                
                                                            }
                                                         */
                                                    }
                                                ).padding(.bottom, 100).padding(.top, 5)
                                                    .onChange(of: journalManager.journalEntries) { _, _ in
                                                        let selectedDayEntries = journalManager.journalEntries.filter{entry in
                                                            //filter/display each entry in a foreach where the following conditional is true about the entry.
                                                            
                                                            let calendar = Calendar.current
                                                            
                                                            return calendar.component(.day, from: entry.date) == calendar.component(.day, from: calendarViewSelected ?? Date()) && calendar.component(.month, from: entry.date) == calendar.component(.month, from: calendarViewSelected ?? Date()) && calendar.component(.year, from: entry.date) == calendar.component(.year, from: calendarViewSelected ?? Date())
                                                            
                                                        }
                                                        
                                                        if selectedDayEntries.isEmpty {
                                                            calendarViewSelected = nil
                                                            allSelected = true
                                                        }
                                                        
                                                    }
                                            }.scrollIndicators(.hidden)
                                                
                                            
                                           
                                          
                                            
                                        }
                                        
                                    }
                            
                        }

                    }
                    
                }
                
                //new entry button, zstack lets this overlay everything.
                HStack {
                    
                    Spacer()
                    
                    
                    VStack {
                        
                        Spacer()
                            
                            Button {
                               
                                showingEntryTypes = true
                            } label: {
                                newEntryButton
                                
                            }

                    }
                    Spacer()
                    
                }.padding(.bottom, 20)
                
                //MARK: analyze button?
                /*
                HStack {
                    
                    Spacer()
                    
                    
                    VStack {
                        
                        Spacer()
                      
                   
                        Button{
                            
                        }label:{
                            ZStack{
                                RoundedRectangle(cornerRadius: 10).frame(width: 130, height: 50).foregroundStyle(.gray)
                                HStack{
                                    Image(systemName: "sparkles")
                                    Text("Analyze").font(.title2)
                                }.foregroundStyle(.white)
                            }
                        }.padding(.bottom, 90)
                        
                        
                    }
                    
                }.padding(.horizontal, 20).padding(.bottom, 20)
                */
                
               
                
            }
            .onAppear {
                journalManager.getAllJournalEntries()
                
            }
            .sheet(isPresented: $showEditSheet, content: {
                JournalEditView(journalEntry: $selectedJournalEntry, journalManager: $journalManager)
                
            })
            .sheet(isPresented: $showProtectYourDataView, content: {
                ProtectYourDataView()
            })
            .sheet(isPresented: $showLocalNotificationsView, content: {
                LocalNotificationsView()
            })
            
        }
    }
    
    func dateAsString(entry: JournalEntry) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "MMM d, yyyy h:mm a"
        
        let stringDate = dateFormatter.string(from: entry.date)
        
        return stringDate
    }
    
    func dateAsStringCalendar(entry: JournalEntry) -> String {
        let dateFormatter = DateFormatter()
        
        dateFormatter.dateFormat = "M/d/yy"
        
        let stringDate = dateFormatter.string(from: entry.date)
        
        return stringDate
    }
    
    func displayRelevantEmoji(entry: JournalEntry) -> String {
        if entry.mood == "terrible"  {
            return "😔"
        }
        
        if entry.mood == "sad"  {
            return "🙁"
        }
        
        if entry.mood == "average"  {
            return "😐"
        }
        
        if entry.mood == "happy"  {
            return "🙂"
        }
        
        if entry.mood == "great"  {
            return "😁"
        }
        
        return ""
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
    
    func colorForMood(_ mood: String) -> Color {
           switch mood {
           case "terrible":
               return .red
           case "sad":
               return .blue
           case "average":
               return .orange
           case "happy":
               return .green
           case "great":
               return .yellow
           default:
               return .black
           }
       }
    
    var menuButton: some View {
        ZStack{
            Rectangle().foregroundStyle(.clear).frame(width: 80, height: 50)
            Image(systemName: "slider.horizontal.3").bold().font(.body).foregroundStyle(.gray).opacity(0.5)
        }
    }

    var insightsButton: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 10).stroke(lineWidth: 1).frame(width: 105, height: 45)
            HStack{
                Text("Insights")
                    .minimumScaleFactor(0.8) // Shrinks text if space is tight
                        .lineLimit(1)
                Image(systemName: "chart.pie")
                    .minimumScaleFactor(0.8) // Shrinks text if space is tight
                        .lineLimit(1)
            }.font(.system(size: 16)).padding(.horizontal, 10)
        }.frame(width: 115, height: 55)
    }
    
    var emptyJournalView: some View {
        VStack(spacing: 20) {
            /*Image("coolLogo")
             .interpolation(.high)
             .resizable()
             .clipShape(RoundedRectangle(cornerRadius: 12))
             .frame(width: 75, height: 75) // Set the image size here
             .shadow(color: .purple, radius: 30)
             */
            /*
            Text("Start Journaling").padding(.top, 20)
                .font(.title2)
                .fontWeight(.light)
            
            Text("Tap the + button below to create your first entry.")
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
                .fontWeight(.light)
            */
            ContentUnavailableView("Start Journaling", systemImage: "square.and.pencil", description: Text("Tap the + button below to create your first entry.")).frame(height: 330)
            
            Spacer()
            
        }
    }
    
    var newEntryButton: some View {
        ZStack{
            Circle().frame(width: 60).foregroundStyle(colorScheme == .dark ? .white : .black).opacity(0.75)//.shadow(color: .gray, radius: 25, x:0, y:0)
            HStack{
                Image(systemName: "plus")
                    .font(.system(size: 30))
                    .foregroundStyle(colorScheme == .dark ? .black : .white).fontWeight(.light)
                    .minimumScaleFactor(0.9) // Shrinks text if space is tight
                        .lineLimit(1)
                
            }.padding(.horizontal, 5)
            
        }
    }
    
    var analyzeButton: some View {
        ZStack{
            Circle().frame(width: 60).foregroundStyle(.black).opacity(0.7)//.shadow(color: .gray, radius: 25, x:0, y:0)
            HStack{
                Image(systemName: "sparkles")
                    .font(.system(size: 30))
                    .foregroundStyle(.white).fontWeight(.light)
                    .minimumScaleFactor(0.9) // Shrinks text if space is tight
                        .lineLimit(1)
                
            }.padding(.horizontal, 5)
            
        }
    }
    
    var topBlackFadeOutView: some View {
        VStack{
            
            Rectangle().foregroundStyle(.black).frame(height: 50).padding(.horizontal, 30)
            Rectangle().foregroundStyle(.black).frame(height:35).offset(y: -90)
            Rectangle().foregroundStyle(.black).frame(height:50).offset(y: -80).blur(radius: 8)
            Spacer()
        }.padding(.horizontal, -50)
    }
    
    var bottomBlackRectangleBehindFadeOut: some View {
        VStack{
            Spacer()
            
            VStack{
                
                Rectangle().frame(height:20).foregroundStyle(.red).overlay{
                    Color.red.frame(height: 50).blur(radius: 7).offset(y:-30)
                }
                
                
                
            }.padding(.horizontal, -50)
            
        }.offset(y:50)
    }
    
    func returnCalendarColor(entry: JournalEntry) -> Double {
        
        let calendar = Calendar.current
        
        //equals today?

        if calendar.component(.day, from: entry.date) == calendar.component(.day, from: calendarViewSelected ?? Date()) && calendar.component(.month, from: entry.date) == calendar.component(.month, from: calendarViewSelected ?? Date()) && calendar.component(.year, from: entry.date) == calendar.component(.year, from: calendarViewSelected ?? Date()){
            return colorScheme == .light ? 0.15 : 0.5
        }
             
        //if calendarViewSelected is nil:
        return 0
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }

}

#Preview {
    ContentView(journalManager: JournalManager(), showingEntryTypes: .constant(false)).environmentObject(JournalLock())
}
