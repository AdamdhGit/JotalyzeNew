//
//  MoodCheckInView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/22/25.
//

import StoreKit
import SwiftUI

struct MoodCheckInView: View {
    
    //all parts of mood check in here, all the way to saving the entry.
    @Environment(\.scenePhase) var scenePhase
    
    @Environment(\.colorScheme) var colorScheme
    @Environment(\.requestReview) var requestReview
    
    @State var journalManager:JournalManager
    
    @Environment(\.dismiss) var dismiss
    
    @State var terribleSelected = false
    @State var sadSelected = false
    @State var averageSelected = false
    @State var happySelected = false
    @State var greatSelected = false
    @State var title = ""
    @State var entry = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    @State var specificMoodWordSelected = ""
    
    //@Binding var calendarViewSelected: Date?
    //@Binding var allSelected: Bool
    
    let worstMoods = [
        "Depressed", "Hopeless", "Anxious", "Overwhelmed", "Despairing",
        "Stressed", "Terrified", "Lonely", "Unhappy", "Guilty"
    ]

    let badMoods = [
        "Sad", "Disappointed", "Frustrated", "Angry", "Irritated",
        "Unmotivated", "Down", "Bitter", "Dismal", "Tired"
    ]

    let neutralMoods = [
        "Calm", "Indifferent", "Meh", "Okay", "Content",
        "Balanced", "Ambivalent", "Uncertain", "Bored", "Uninspired"
    ]

    let goodMoods = [
        "Happy", "Optimistic", "Confident", "Motivated", "Cheerful",
        "Excited", "Proud", "Thankful", "Energized", "Relaxed"
    ]

    let greatMoods = [
        "Ecstatic", "Grateful", "Joyful", "Euphoric", "Elated",
        "Radiant", "Inspired", "Hopeful", "Uplifted", "Pleased"
    ]
    
    let gridItems = [
        GridItem(.fixed(160)), // Flexible width for each column
        GridItem(.fixed(160)),
        ]
    
    @State var tabViewSelection: Int = 0

    
    var body: some View {
        
      
            
        TabView(selection: $tabViewSelection){
                ZStack{
                    Color.gray.opacity(0.1).ignoresSafeArea()
                    ScrollView{
                        VStack {
                            
                            HStack{
                                Button {
                                    
                                    dismiss()
                                    
                                } label: {
                                    Text("Cancel")
                                }.tint(colorScheme == .light ? .black : .white)
                                Spacer()
                            }.padding(.horizontal).padding(.top, 20)
                            
                            Text("What's your mood?").padding(.top, 50).font(.title3).fontWeight(.light)
                            
                            HStack(spacing: 20){
                                
                                terribleButton
                                sadButton
                                neutralButton
                                happyButton
                                greatButton
                                
                            }.padding(.top, 15).padding(.bottom, 50)
                            
                            if terribleSelected {
                                LazyVGrid(columns: gridItems, spacing: 20) {
                                    ForEach(worstMoods, id: \.self){i in
                                        
                                        Button{
                                            specificMoodWordSelected = i
                                        }label:{
                                            ZStack{
                                                
                                                
                                                
                                                RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                
                                                if specificMoodWordSelected == i {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(.red.opacity(0.5))
                                                }
                                                
                                                Text(i)
                                            }
                                        }.tint(colorScheme == .light ? .black : .white)
                                            .fontWeight(.light)
                                        
                                        
                                    }
                                }
                            } else if sadSelected {
                                LazyVGrid(columns: gridItems, spacing: 20) {
                                    ForEach(badMoods, id: \.self){i in
                                        
                                        Button{
                                            specificMoodWordSelected = i
                                        }label:{
                                            ZStack{
                                                
                                                RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                
                                                if specificMoodWordSelected == i {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(.blue.opacity(0.5))
                                                }
                                                Text(i)
                                            }
                                        }.tint(colorScheme == .light ? .black : .white)
                                            .fontWeight(.light)
                                        
                                        
                                    }
                                }
                                
                            } else if averageSelected {
                                LazyVGrid(columns: gridItems, spacing: 20) {
                                    ForEach(neutralMoods, id: \.self){i in
                                        
                                        Button{
                                            specificMoodWordSelected = i
                                        }label:{
                                            ZStack{
                                                
                                                RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                
                                                if specificMoodWordSelected == i {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(.orange.opacity(0.5))
                                                }
                                                Text(i)
                                            }
                                        }.tint(colorScheme == .light ? .black : .white)
                                            .fontWeight(.light)
                                        
                                        
                                    }
                                }
                                
                            } else if happySelected {
                                LazyVGrid(columns: gridItems, spacing: 20) {
                                    ForEach(goodMoods, id: \.self){i in
                                        
                                        Button{
                                            specificMoodWordSelected = i
                                        }label:{
                                            ZStack{
                                                
                                                RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                
                                                if specificMoodWordSelected == i {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(.green.opacity(0.5))
                                                }
                                                Text(i)
                                            }
                                        }.tint(colorScheme == .light ? .black : .white)
                                            .fontWeight(.light)
                                        
                                        
                                    }
                                }
                                
                            } else if greatSelected {
                                LazyVGrid(columns: gridItems, spacing: 20) {
                                    ForEach(greatMoods, id: \.self){i in
                                        
                                        Button{
                                            specificMoodWordSelected = i
                                        }label:{
                                            
                                            
                                            ZStack{
                                                
                                                RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(colorScheme == .light ? .white : darkGrayColor)
                                                    .shadow(color: .black.opacity(0.08), radius: 4, x: 0, y: 2)
                                                
                                                if specificMoodWordSelected == i {
                                                    RoundedRectangle(cornerRadius: 10).frame(width: 150, height: 50).foregroundStyle(.yellow.opacity(0.5))
                                                }
                                                Text(i)
                                            }
                                        }.tint(colorScheme == .light ? .black : .white).fontWeight(.light)
                                        
                                    }
                                }
                                
                            }
                            
                            if terribleSelected || sadSelected || averageSelected || happySelected || greatSelected {
                                Button{
                                    tabViewSelection = 1
                                }label:{
                                    //.shadow(color: .gray, radius: 25, x:0, y:0)
                                    HStack{
                                        Text("Next")
                                        Image(systemName: "chevron.right")
                                    }.foregroundStyle(colorScheme == .light ? .black : .white).padding().background( RoundedRectangle(cornerRadius: 10).frame(height: 40).foregroundStyle(nextButtonColor.opacity(0.5))
                                    )
                                }
                                .padding(.top, 30)
                                .fontWeight(.light)
                                
                            }
                            
                            
                            
                            Spacer()
                        }
                    }.scrollIndicators(.hidden)
                }.toolbar(.hidden, for: .tabBar).tag(0)
            
            VStack {
                
          
                HStack{
                    Button {
                        dismiss()
                    } label: {
                        Text("Cancel")
                    }.tint(colorScheme == .light ? .black : .white)
                    Spacer()
                    saveButton.tint(colorScheme == .light ? .black : .white)
                }.padding(.top, 20)
                
                
                
                ScrollView{

                    HStack{
                    Text("How are you feeling?").font(.title3).padding(.bottom, 15).fontWeight(.light)
                    Spacer()
                    }.padding(.top, 20)
                        
                        ScrollViewReader{proxy in
                                ScrollView{
                        TextField("What's on your mind?", text: $entry, axis: .vertical)
                            .id("bottom")
                            .focused($isTextFieldFocused)
                            .fontWeight(.light)
                            .tint(colorScheme == .light ? .black : .white)
                           
                                }.frame(height: 230)
                                .onAppear {
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        isTextFieldFocused = true // Delay to ensure it works
                                        
                                    }
                                }
                                
 
                        .onChange(of: entry) {
                         withAnimation {
                             proxy.scrollTo("bottom", anchor: .bottom)
                         }
                     }
                     
                }
                        
                    
                    
                    Spacer()
                }
            }.toolbar(.hidden, for: .tabBar).tag(1).padding(.horizontal)
            
        }            
    }
    
    func passInMood() -> String {
        
        if specificMoodWordSelected.isEmpty && terribleSelected  {
            return "Terrible"
        } else if specificMoodWordSelected.isEmpty && sadSelected {
            return "Bad"
        } else if specificMoodWordSelected.isEmpty && averageSelected {
            return "Average"
        } else if specificMoodWordSelected.isEmpty && happySelected {
            return "Good"
        } else if specificMoodWordSelected.isEmpty && greatSelected  {
            return "Great"
        } else if !specificMoodWordSelected.isEmpty && terribleSelected  {
            return specificMoodWordSelected
        } else if !specificMoodWordSelected.isEmpty && sadSelected {
            return specificMoodWordSelected
        } else if !specificMoodWordSelected.isEmpty && averageSelected {
            return specificMoodWordSelected
        } else if !specificMoodWordSelected.isEmpty && happySelected {
            return specificMoodWordSelected
        } else if !specificMoodWordSelected.isEmpty && greatSelected  {
            return specificMoodWordSelected
        }
        
        
        else {
            return specificMoodWordSelected
        }
        
        
        
    }
    
    var saveButton: some View {
        Button("Save"){
            
            if specificMoodWordSelected.isEmpty {
                let newEntry = JournalEntry(id: UUID(), mood: passInMood(), entry: entry, date: Date.now)
                journalManager.saveJournalEntry(newEntry)
                journalManager.getAllJournalEntries()
                
            } else {
                let newEntry = JournalEntry(id: UUID(), mood: passInMood(), customSpecificMoodWord: specificMoodWordSelected, title: title, entry: entry, date: Date.now)
                journalManager.saveJournalEntry(newEntry)
                journalManager.getAllJournalEntries()
                
            }
            
            dismiss()
            
            if journalManager.journalEntries.count == 5 || journalManager.journalEntries.count == 20 || journalManager.journalEntries.count == 50 || journalManager.journalEntries.count == 75 ||
                journalManager.journalEntries.count == 100 {
                requestReview()
            }
            
            
            //calendarViewSelected = nil
            //allSelected = true
            
        }
            .disabled(title.isEmpty && entry.isEmpty)
            .disabled(passInMood().isEmpty)
           
            
    }
    
    var enterATitleText: some View {
        HStack{
            Text("Enter A Title")
            Text("(Optional)")
            Spacer()
        }.opacity(0.4)
            .bold()
            .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
    }
    
    var titleCountAndLengthText: some View {
        HStack {
            Spacer()
            Text("(\(title.count) / \(20))").foregroundStyle(.gray)
        }
    }
    
    var whatsOnYourMindText: some View {
        HStack{
            Text("What's on Your Mind?")
                .opacity(0.4)
                .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
            
            Spacer()
        }
    }
    
    var titleTextField: some View {
        HStack{
            TextField("", text: $title)
                .onChange(of: title) { oldValue, newValue in
                    if title.count > 20 {
                        title = oldValue
                    }
                }.opacity(0.4)
                .bold()
                .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
        }
    }
    
    var terribleButton: some View {
        Button{
            specificMoodWordSelected = ""
            terribleSelected = true
            sadSelected = false
            averageSelected = false
            happySelected = false
            greatSelected = false
        }label: {
            Image(colorScheme == .light ? "terrible" : "terribleWhite").resizable().frame(width:50, height: 50).shadow(color: terribleSelected ? Color.red : Color.clear, radius: 10, x: 0, y: 0)
            //Text("😔").font(.system(size: 50)).shadow(color: terribleSelected ? Color.red : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var sadButton: some View {
        Button{
            specificMoodWordSelected = ""
            terribleSelected = false
            sadSelected = true
            averageSelected = false
            happySelected = false
            greatSelected = false
        }label: {
            Image(colorScheme == .light ? "sad" : "sadWhite").resizable().frame(width:50, height: 50).shadow(color: sadSelected ? Color.blue : Color.clear, radius: 10, x: 0, y: 0)
            //Text("🙁").font(.system(size: 50)).shadow(color: sadSelected ? Color.blue : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var neutralButton: some View {
        Button{
            specificMoodWordSelected = ""
            terribleSelected = false
            sadSelected = false
            averageSelected = true
            happySelected = false
            greatSelected = false
        }label: {
            Image(colorScheme == .light ? "average" : "averageWhite").resizable().frame(width:50, height: 50).shadow(color: averageSelected ? Color.orange : Color.clear, radius: 10, x: 0, y: 0)
           //Text("😐").font(.system(size: 50)).shadow(color: averageSelected ? Color.orange : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var happyButton: some View {
        Button{
            specificMoodWordSelected = ""
            terribleSelected = false
            sadSelected = false
            averageSelected = false
            happySelected = true
            greatSelected = false
            
        }label: {
            Image(colorScheme == .light ? "happy" : "happyWhite").resizable().frame(width:50, height: 50).shadow(color: happySelected ? Color.green : Color.clear, radius: 10, x: 0, y: 0)
            //Text("🙂").font(.system(size: 50)).shadow(color: happySelected ? Color.green : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var greatButton: some View {
        Button{
            specificMoodWordSelected = ""
            terribleSelected = false
            sadSelected = false
            averageSelected = false
            happySelected = false
            greatSelected = true
        }label: {
            Image(colorScheme == .light ? "great" : "greatWhite").resizable().frame(width:50, height: 50).shadow(color: greatSelected ? Color.yellow : Color.clear, radius: 10, x: 0, y: 0)
            //Text("😁").font(.system(size: 50)).shadow(color: greatSelected ? Color.yellow : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var darkGrayColor: Color {
        Color(red: 25/255, green: 25/255, blue: 25/255)
    }
    
    var nextButtonColor: Color {
        if terribleSelected {
            return .red
        } else if sadSelected {
            return .blue
        } else if averageSelected {
            return .orange
        } else if happySelected {
            return .green
        } else if greatSelected {
            return .yellow
        }
        return .clear
    }
    
}

#Preview {
    MoodCheckInView(journalManager: JournalManager())
}
