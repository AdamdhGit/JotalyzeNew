//
//  MorningPreparationView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/27/25.
//

import SwiftUI

struct MorningPreparationView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.requestReview) var requestReview
    
    @Environment(\.dismiss) var dismiss
    @State var morningPreparationEntryText = ""
    @State var journalManager:JournalManager
    
    @Binding var morningPreparationSaved:Bool
    @Binding var animateSun:Bool
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack{

            HStack{
                Button("Cancel"){
                    dismiss()
                }.tint(colorScheme == .light ? .black : .white)
                Spacer()
                
                Button ("Save"){
                    
                    let newEntry = JournalEntry(id: UUID(), mood: "", title: "", entry: morningPreparationEntryText, date: Date.now, entryType: "Morning Preparation")
                    
                    journalManager.saveJournalEntry(newEntry)
                    journalManager.getAllJournalEntries()
                    
                   
                        morningPreparationSaved = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.linear(duration: 1.5)){
                            animateSun = true
                        }
                    }
                    
                    dismiss()
                    
                }.disabled(morningPreparationEntryText.isEmpty).tint(colorScheme == .light ? .black : .white)
                
            }.padding(.bottom, 30).padding(.top, 20)
            
            HStack{
                Text("What's Your Focus Today?").font(.title3).padding(.bottom, 15).fontWeight(.light)
                Spacer()
            }
            
            ScrollViewReader{proxy in
                    ScrollView{
                        TextField("What are your goals or intentions for today?", text: $morningPreparationEntryText, axis: .vertical).id("bottom")
                            .focused($isTextFieldFocused)
                            .fontWeight(.light)
                            .tint(colorScheme == .light ? .black : .white)
                           
                    }.frame(height: 300)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            isTextFieldFocused = true // Delay to ensure it works
                            
                        }
                    }
                    
                    .onTapGesture {
                                            isTextFieldFocused = true // Focus when tapped anywhere in the area
                                        }
                     // Make full area tappable
                   
                 .onChange(of: morningPreparationEntryText) {
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
    MorningPreparationView(journalManager: JournalManager(), morningPreparationSaved: .constant(false), animateSun: .constant(false))
}
