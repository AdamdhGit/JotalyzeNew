//
//  GratitudeEntryView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 2/22/25.
//

import SwiftUI

struct GratitudeEntryView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.requestReview) var requestReview
    
    @Environment(\.dismiss) var dismiss
    @State var gratitudeEntryText = ""
    @State var journalManager:JournalManager
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack{
            
            
            HStack{
                Button("Cancel"){
                    dismiss()
                }.tint(colorScheme == .light ? .black : .white)
                Spacer()
                
                Button ("Save"){
                    
                    let newEntry = JournalEntry(id: UUID(), mood: "", title: "", entry: gratitudeEntryText, date: Date.now, entryType: "Gratitude")
                    
                    journalManager.saveJournalEntry(newEntry)
                    journalManager.getAllJournalEntries()
                    
                    dismiss()
                    
                    if journalManager.journalEntries.count == 5 || journalManager.journalEntries.count == 20 || journalManager.journalEntries.count == 50 || journalManager.journalEntries.count == 75 ||
                        journalManager.journalEntries.count == 100 {
                        requestReview()
                    }
                    
                    
                    
                    //calendarViewSelected = nil
                    //allSelected = true
                    
                    
                }.disabled(gratitudeEntryText.isEmpty).tint(colorScheme == .light ? .black : .white)
                
            }.padding(.bottom, 30).padding(.top, 20)
            
            HStack{
                Text("What are you thankful for today?").font(.title3).padding(.bottom, 15).fontWeight(.light)
                Spacer()
            }
            
            ScrollViewReader{proxy in
                    ScrollView{
                        TextField("I'm thankful for...", text: $gratitudeEntryText, axis: .vertical).id("bottom")
                            .focused($isTextFieldFocused)
                            .fontWeight(.light)
                            .tint(colorScheme == .light ? .black : .white)
                           
                    }.frame(height: 130)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isTextFieldFocused = true // Delay to ensure it works
                            
                        }
                    }
                    
                    .onTapGesture {
                                            isTextFieldFocused = true // Focus when tapped anywhere in the area
                                        }
                     // Make full area tappable
                   
                 .onChange(of: gratitudeEntryText) {
                     withAnimation {
                         proxy.scrollTo("bottom", anchor: .bottom)
                     }
                 }
                 
            }
            
            Spacer()
            
        }.padding(.horizontal)
    }
}

#Preview {
    GratitudeEntryView(journalManager: JournalManager())
}
