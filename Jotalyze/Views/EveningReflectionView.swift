//
//  EveningReflectionView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 3/27/25.
//

import SwiftUI

struct EveningReflectionView: View {
    
    @Environment(\.colorScheme) var colorScheme
    
    @Environment(\.requestReview) var requestReview
    
    @Environment(\.dismiss) var dismiss
    @State var eveningReflectionEntryText = ""
    @State var journalManager:JournalManager
    
    @Binding var eveningReflectionSaved:Bool
    @Binding var animateMoon:Bool
    
    @FocusState private var isTextFieldFocused: Bool
    
    var body: some View {
        VStack{

            HStack{
                Button("Cancel"){
                    dismiss()
                }.tint(colorScheme == .light ? .black : .white)
                Spacer()
                
                Button ("Save"){
                    
                    let newEntry = JournalEntry(id: UUID(), mood: "", title: "", entry: eveningReflectionEntryText, date: Date.now, entryType: "Evening Reflection")
                    
                    journalManager.saveJournalEntry(newEntry)
                    journalManager.getAllJournalEntries()
                    
                    eveningReflectionSaved = true
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation(.linear(duration: 1.5)){
                            animateMoon = true
                        }
                    }
                    
                    dismiss()
                    
                }.disabled(eveningReflectionEntryText.isEmpty).tint(colorScheme == .light ? .black : .white)
                
            }.padding(.bottom, 30).padding(.top, 20)
            
            HStack{
                Text("How Was Your Day?").font(.title3).padding(.bottom, 15).fontWeight(.light)
                Spacer()
            }
            
            ScrollViewReader{proxy in
                    ScrollView{
                        ZStack(alignment: .topLeading){
                            if eveningReflectionEntryText.isEmpty {

                                    Text("Were you able to achieve the goals or intentions you set for yourself today? How did it go?").fontWeight(.light).foregroundStyle(Color(UIColor.placeholderText))
                                   
                            }
                            TextField("", text: $eveningReflectionEntryText, axis: .vertical).id("bottom")
                                .focused($isTextFieldFocused)
                                .fontWeight(.light)
                                .tint(colorScheme == .light ? .black : .white)
                        }
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
                   
                 .onChange(of: eveningReflectionEntryText) {
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
    EveningReflectionView(journalManager: JournalManager(), eveningReflectionSaved: .constant(false), animateMoon: .constant(false))
}
