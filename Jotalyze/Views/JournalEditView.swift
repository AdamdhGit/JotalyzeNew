//
//  JournalEditView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 10/12/24.
//

import SwiftUI

struct JournalEditView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.dismiss) var dismiss
    @Binding var journalEntry:JournalEntry
    
    @Binding var journalManager:JournalManager
    
    @State var terribleSelected = false
    @State var sadSelected = false
    @State var averageSelected = false
    @State var happySelected = false
    @State var greatSelected = false
    
    @State var maxTitleLength = 20
    
    @State var gratitudeOne:String = ""
    @State var gratitudeTwo:String = ""
    @State var gratitudeThree:String = ""
    @State var gratitudeFour:String = ""
    @State var gratitudeFive:String = ""
    
    @State var editedMoodText:String = ""
    @State var editedGratitudeText:String = ""
    @State var editedGoalProgressText:String = ""
    @State var editedPhotoText:String = ""
    @State var editedMorningPreparationText:String = ""
    @State var editedEveningReflectionText:String = ""
    
    @FocusState private var isTextFieldFocused: Bool
    
    
    var body: some View {
        
        ZStack {
            
            //Color.gray.opacity(0.1).ignoresSafeArea()
            if colorScheme == .light {
                Color.white.ignoresSafeArea()
            }
            if colorScheme == .dark {
                Color.black.ignoresSafeArea()
            }
            
                ScrollViewReader{ proxy in
                    ScrollView {
                        
                        ZStack {
                            
                            //Text(dateAsString(entry: journalEntry)).foregroundStyle(.white).bold()
                            
                            HStack {
                                cancelButton
                                Spacer()
                                if !journalEntry.mood.isEmpty {
                                    saveButton.disabled(journalEntry.entry.isEmpty)
                                } else if journalEntry.entryType == "Gratitude" {
                                    saveUpdatedGratitudeEntryButton
                                    
                                } else if journalEntry.entryType == "Goal" {
                                    saveUpdatedGoalEntryButton
                                } else if journalEntry.entryType == "Photo" {
                                    saveUpdatedPhotoEntryButton
                                }  else if journalEntry.entryType == "Morning Preparation" {
                                    saveUpdatedMorningPreparationEntryButton
                                }  else if journalEntry.entryType == "Evening Reflection" {
                                    saveUpdatedEveningReflectionEntryButton
                                }
                            }.padding(.top, 30).padding(.trailing)
                        }
                        
                        if !journalEntry.mood.isEmpty {
                            VStack{
                                
                                
                                HStack {
                                    Text("What would you like to change?") .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
                                    Spacer()
                                }.padding(.horizontal).fontWeight(.light)
                                    .padding(.bottom, 30)
                                
                                /*
                                 HStack(spacing: 20) {
                                 
                                 terribleButton
                                 sadButton
                                 neutralButton
                                 happyButton
                                 greatButton
                                 
                                 }.padding(.top, 15).padding(.bottom, 20)
                                 */
                                
                                /*
                                 ZStack {
                                 
                                 titleCountAndLengthText
                                 
                                 if (journalEntry.title.isEmpty){
                                 
                                 enterATitleText
                                 
                                 }
                                 
                                 titleTextField
                                 
                                 
                                 
                                 
                                 
                                 }.padding(.horizontal).frame(height: 30)
                                 */
                                TextField("What's On Your Mind?", text: $editedMoodText, axis: .vertical).fontWeight(.light).padding(.horizontal)
                                    .fontWeight(.light)
                                    .tint(colorScheme == .light ? .black : .white)
                                  
                                    .focused($isTextFieldFocused)
                                    .onAppear {
                                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                            isTextFieldFocused = true // Delay to ensure it works
                                            
                                        }
                                    }
                                    .onChange(of: editedMoodText) { _, _ in
                                        journalEntry.entry = editedMoodText
                                    }
                                    .onAppear{
                                        editedMoodText = journalEntry.entry
                                        
                                    }
                                
                                
                                Spacer()
                            }.padding(.bottom, 450).padding(.top, 30)
                        } else if journalEntry.entryType == "Gratitude" {
                            VStack{
                                
                                
                                HStack {
                                    Text("What would you like to change?") .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
                                    Spacer()
                                }.padding(.horizontal).fontWeight(.light).padding(.bottom, 30)
                                
                                
                                ZStack{
                                    
                                    TextField("What are you thankful for today?", text: $editedGratitudeText, axis: .vertical)
                                        .fontWeight(.light)
                                        .tint(colorScheme == .light ? .black : .white)
                                        
                                        .onAppear{
                                            editedGratitudeText = journalEntry.entry
                                            
                                        }
                                        .onChange(of: editedGratitudeText) { _, _ in
                                            journalEntry.entry = editedGratitudeText
                                        }
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isTextFieldFocused = true // Delay to ensure it works
                                                
                                            }
                                        }
                                    
                                }.padding(.horizontal)
                                Spacer()
                            }.padding(.bottom, 450).padding(.top, 30)
                        } else if journalEntry.entryType == "Goal" {
                            VStack{
                                
                                
                                HStack {
                                    Text("What would you like to change?") .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
                                    Spacer()
                                }.padding(.horizontal).fontWeight(.light).padding(.bottom, 30)
                                
                                
                                ZStack(alignment: .topLeading){
                                    
                                    if editedGoalProgressText.isEmpty {
                                        Text("How did it go today? What went well? What was challenging?").fontWeight(.light).foregroundStyle(Color(UIColor.placeholderText))
                                    }
                                    
                                    TextField("", text: $editedGoalProgressText, axis: .vertical)
                                        .fontWeight(.light)
                                        .tint(colorScheme == .light ? .black : .white)
                                        
                                        .onAppear{
                                            editedGoalProgressText = journalEntry.entry
                                            
                                        }
                                        .onChange(of: editedGoalProgressText) { _, _ in
                                            journalEntry.entry = editedGoalProgressText
                                        }
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isTextFieldFocused = true // Delay to ensure it works
                                                
                                            }
                                        }
                                    
                                }.padding(.horizontal)
                                Spacer()
                            }.padding(.bottom, 450).padding(.top, 30)
                        }
                        else if journalEntry.entryType == "Photo" {
                            VStack{
                                
                                
                                HStack {
                                    Text("What would you like to change?") .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
                                    Spacer()
                                }.padding(.horizontal).fontWeight(.light).padding(.bottom, 30)
                                
                                ZStack(alignment: .topLeading){
                                    
                                    if editedPhotoText.isEmpty {
                                        Text("What are your thoughts and feelings about this moment? What emotions come to mind?").foregroundStyle(Color(UIColor.placeholderText))
                                            .fontWeight(.light)
                                    }
                                    TextField("", text: $editedPhotoText, axis: .vertical)
                                        .fontWeight(.light)
                                        .tint(colorScheme == .light ? .black : .white)
                                        
                                        .onAppear{
                                            editedPhotoText = journalEntry.entry
                                            
                                        }
                                        .onChange(of: editedPhotoText) { _, _ in
                                            journalEntry.entry = editedPhotoText
                                        }
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isTextFieldFocused = true // Delay to ensure it works
                                                
                                            }
                                        }
                                    
                                }.padding(.horizontal)
                                Spacer()
                            }.padding(.bottom, 450).padding(.top, 30)
                        }
                        else if journalEntry.entryType == "Morning Preparation" {
                            VStack{
                                
                                
                                HStack {
                                    Text("What would you like to change?") .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
                                    Spacer()
                                }.padding(.horizontal).fontWeight(.light).padding(.bottom, 30)
                                
                                ZStack(alignment: .topLeading){
                                    
                                    if editedMorningPreparationText.isEmpty {
                                        Text("What are your goals or intentions for today?").foregroundStyle(Color(UIColor.placeholderText))
                                            .fontWeight(.light)
                                    }
                                    TextField("", text: $editedMorningPreparationText, axis: .vertical)
                                        .fontWeight(.light)
                                        .tint(colorScheme == .light ? .black : .white)
                                        
                                        .onAppear{
                                            editedMorningPreparationText = journalEntry.entry
                                            
                                        }
                                        .onChange(of: editedMorningPreparationText) { _, _ in
                                            journalEntry.entry = editedMorningPreparationText
                                        }
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isTextFieldFocused = true // Delay to ensure it works
                                                
                                            }
                                        }
                                    
                                }.padding(.horizontal)
                                Spacer()
                            }.padding(.bottom, 450).padding(.top, 30)
                        }
                        else if journalEntry.entryType == "Evening Reflection" {
                            VStack{
                                
                                
                                HStack {
                                    Text("What would you like to change?") .font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
                                    Spacer()
                                }.padding(.horizontal).fontWeight(.light).padding(.bottom, 30)
                                
                                ZStack(alignment: .topLeading){
                                    
                                    if editedEveningReflectionText.isEmpty {
                                        Text("Were you able to achieve the goals or intentions you set for yourself today? How did it go?").foregroundStyle(Color(UIColor.placeholderText))
                                            .fontWeight(.light)
                                    }
                                    TextField("", text: $editedEveningReflectionText, axis: .vertical)
                                        .fontWeight(.light)
                                        .tint(colorScheme == .light ? .black : .white)
                                        
                                        .onAppear{
                                            editedEveningReflectionText = journalEntry.entry
                                            
                                        }
                                        .onChange(of: editedEveningReflectionText) { _, _ in
                                            journalEntry.entry = editedEveningReflectionText
                                        }
                                        .focused($isTextFieldFocused)
                                        .onAppear {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                                isTextFieldFocused = true // Delay to ensure it works
                                                
                                            }
                                        }
                                    
                                }.padding(.horizontal)
                                Spacer()
                            }.padding(.bottom, 450).padding(.top, 30)
                        }
                    }
                        
                }
                
        }.onAppear {
            //checkIncomingMood()
        }
    }
    
    func dateAsString(entry: JournalEntry) -> String {
        
        let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "EEEE, MMM d"
        let stringDate = dateFormatter.string(from: entry.date)
             return stringDate
        
    }
    
    func checkIncomingMood() {
        if journalEntry.mood == "terrible" {
            terribleSelected = true
        } else if journalEntry.mood == "sad" {
            sadSelected = true
        } else if journalEntry.mood == "average" {
            averageSelected = true
        } else if journalEntry.mood == "happy" {
            happySelected = true
        } else if journalEntry.mood == "great" {
            greatSelected = true
        }
    }
    
    func passInMood() -> String {
        
        if terribleSelected  {
            return "terrible"
        }
        
        if sadSelected {
            return "sad"
        }
        
        if averageSelected {
            return "average"
        }
        
        if happySelected {
            return "happy"
        }
        
        if greatSelected  {
            return "great"
        }
        
        return ""
    }
    
    var saveButton: some View {
        Button("Save"){
            //journalEntry.mood = passInMood()
            journalManager.saveJournalEntry(journalEntry)
            journalManager.getAllJournalEntries()
            
            dismiss()
        }.tint(colorScheme == .light ? .black : .white)
            .disabled(journalEntry.entry.isEmpty)
            //.disabled(journalEntry.mood.isEmpty)
    }
    
    var cancelButton: some View {
        Button{
            dismiss()
        }label: {
            Text("Cancel")
        }.padding(.horizontal).tint(colorScheme == .light ? .black : .white)
    }
    
    var terribleButton: some View {
        Button {
            terribleSelected = true
            sadSelected = false
            averageSelected = false
            happySelected = false
            greatSelected = false
        } label: {
            Image("whiteSaddest").resizable().frame(width:50, height: 50).shadow(color: terribleSelected ? Color.red : Color.clear, radius: 10, x: 0, y: 0)
           // Text("😔").font(.system(size: 50)).shadow(color: terribleSelected ? Color.red : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var sadButton: some View {
        Button{
            terribleSelected = false
            sadSelected = true
            averageSelected = false
            happySelected = false
            greatSelected = false
        }label: {
            Image("whiteSad").resizable().frame(width:50, height: 50).shadow(color: sadSelected ? Color.blue : Color.clear, radius: 10, x: 0, y: 0)
            //Text("🙁").font(.system(size: 50)).shadow(color: sadSelected ? Color.blue : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var neutralButton: some View {
        Button{
            terribleSelected = false
            sadSelected = false
            averageSelected = true
            happySelected = false
            greatSelected = false
        }label: {
            Image("whiteNeutral").resizable().frame(width:50, height: 50).shadow(color: averageSelected ? Color.orange : Color.clear, radius: 10, x: 0, y: 0)
            //Text("😐").font(.system(size: 50)).shadow(color: averageSelected ? Color.orange : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var happyButton: some View {
        Button{
            terribleSelected = false
            sadSelected = false
            averageSelected = false
            happySelected = true
            greatSelected = false
            
        }label: {
            Image("whiteHappy").resizable().frame(width:50, height: 50).shadow(color: happySelected ? Color.green : Color.clear, radius: 10, x: 0, y: 0)
            //Text("🙂").font(.system(size: 50)).shadow(color: happySelected ? Color.green : Color.clear, radius: 10, x: 0, y: 0)
        }
    }
    
    var greatButton: some View {
        Button{
            terribleSelected = false
            sadSelected = false
            averageSelected = false
            happySelected = false
            greatSelected = true
        }label: {
            Image("whiteHappiest").resizable().frame(width:50, height: 50).shadow(color: greatSelected ? Color.yellow : Color.clear, radius: 10, x: 0, y: 0)
            //Text("😁").font(.system(size: 50)).shadow(color: greatSelected ? Color.yellow : Color.clear, radius: 10, x: 0, y: 0)
        }
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
    
    /*
    var titleTextField: some View {
        HStack{
            TextField("", text: $journalEntry.title)
                .onChange(of: journalEntry.title) { oldValue, newValue in
                    if journalEntry.title.count > 20 {
                        journalEntry.title = oldValue
                    }
                }.opacity(0.4).bold().font(.system(size: 20)).minimumScaleFactor(0.8).lineLimit(1)
        }.frame(height: 21)
    }
     */
    

    
    /*
    var titleCountAndLengthText: some View {
        HStack{
            Spacer()
            Text("(\(journalEntry.title.count) / \(maxTitleLength))").foregroundStyle(.gray)
        
        }
    }
     */
    
    var backgroundColor: some View {
        Color(red: 0.075, green: 0.075, blue: 0.075).ignoresSafeArea(.all)
    }
    
    var saveUpdatedGratitudeEntryButton: some View {
        Button ("Save"){
            
            
            journalManager.saveJournalEntry(journalEntry)
            journalManager.getAllJournalEntries()
            
            dismiss()
            
        }.disabled(editedGratitudeText.isEmpty).tint(colorScheme == .light ? .black : .white)
            
    }
    
    var saveUpdatedGoalEntryButton: some View {
        Button ("Save"){
            
            journalManager.saveJournalEntry(journalEntry)
            journalManager.getAllJournalEntries()
            
            dismiss()
            
        }.disabled(editedGoalProgressText.isEmpty).tint(colorScheme == .light ? .black : .white)
            
    }
    
    var saveUpdatedPhotoEntryButton: some View {
        Button ("Save"){
            
            journalManager.saveJournalEntry(journalEntry)
            journalManager.getAllJournalEntries()
            
            dismiss()
            
        }.disabled(editedPhotoText.isEmpty).tint(colorScheme == .light ? .black : .white)
            
    }
    
    var saveUpdatedMorningPreparationEntryButton: some View {
        Button ("Save"){
            
            journalManager.saveJournalEntry(journalEntry)
            journalManager.getAllJournalEntries()
            
            dismiss()
            
        }.disabled(editedMorningPreparationText.isEmpty).tint(colorScheme == .light ? .black : .white)
            
    }
    
    var saveUpdatedEveningReflectionEntryButton: some View {
        Button ("Save"){
            
            journalManager.saveJournalEntry(journalEntry)
            journalManager.getAllJournalEntries()
            
            dismiss()
            
        }.disabled(editedEveningReflectionText.isEmpty).tint(colorScheme == .light ? .black : .white)
            
    }
    
}

#Preview {
    JournalEditView(journalEntry: .constant(JournalEntry(id: UUID(), mood: "", title: "", entry: "", date: Date.now)),  journalManager: .constant(JournalManager()))
}
