//
//  StartupTutorialView.swift
//  Jotalyze
//
//  Created by Adam Heidmann on 4/1/25.
//

import SwiftUI

struct StartupTutorialView: View {

    @Environment(\.colorScheme) var colorScheme
    
    @EnvironmentObject var startupTutorialDone: StartupTutorialDone

    @State var tutorialTabSelected:Int = 0
    
    var body: some View {
        ZStack{
            
            Color.gray.opacity(0.1).ignoresSafeArea()
            
            TabView(selection: $tutorialTabSelected){
                
                ZStack{
                  
                    
                    VStack{

                        Text("Jotalyze").font(.title).fontWeight(.light).padding(.top, 130)
                        
                        Text("Jot your thoughts and analyze your growth.").multilineTextAlignment(.center) .padding(.top, 10).fontWeight(.light)
                        
                        Image(colorScheme == .dark ? "jotalyzeIntroPicDarkMode" : "jotalyzeIntroPic")
                            .resizable()
                            
                            .scaledToFit()
                            .frame(width: 300, height: 300)
                          
                        
                        
                        Spacer()
                    }.padding(.horizontal)
                    
                    VStack{
                        Spacer()
                        Button{
                            withAnimation{
                                tutorialTabSelected = 1
                            }
                        }label:{
                            Text("Get Started").padding(10).padding(.horizontal, 20)
                                .foregroundStyle(colorScheme == .dark ? .black : .white)
                            
                        }.buttonStyle(.borderedProminent).tint(colorScheme == .dark ? .white : .black).padding(.bottom, 100)
                    }
                    
                }.tag(0)
                
                ZStack{
                    
                    VStack{
                        Image(colorScheme == .dark ? "moodPicDarkMode" : "moodPicLightMode")
                            .resizable()
                            //.renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 300, height: 300).padding(.top, 80)
                            //.foregroundColor(colorScheme == .dark ? .white : .black)
                        Text("Optimize Your Mood").bold().padding(.top, 10)
                        Text("Track your mood with Mood Check-In entries. Receive analytics comparing mood trends over time through different graphs.").padding(.top, 10).fontWeight(.light).multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    
                    VStack{
                        Spacer()
                        Button{
                            withAnimation{
                                tutorialTabSelected = 2
                            }
                        }label:{
                            Text("Next").padding(10).padding(.horizontal, 20)
                                .foregroundStyle(colorScheme == .dark ? .black : .white)
                            
                        }.buttonStyle(.borderedProminent).tint(colorScheme == .dark ? .white : .black).padding(.bottom, 100)
                    }
                    
                }.tag(1).padding(.horizontal)
                
                ZStack{
      
                    VStack{
                        Image("trophiesPic")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 300, height: 300).padding(.top, 80)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("Track Goals").padding(.top, 10).bold()
                        Text("Create goals, log progress, reflect on what worked and what didn't, and gain valueable insights through analytics tracking completions and hours spent on tasks to help you achieve your objectives.").padding(.top, 10).fontWeight(.light).multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    VStack{
                        Spacer()
                        Button{
                            withAnimation{
                                tutorialTabSelected = 3
                            }
                        }label:{
                            Text("Next").padding(10).padding(.horizontal, 20)
                                .foregroundStyle(colorScheme == .dark ? .black : .white)
                            
                        }.buttonStyle(.borderedProminent).tint(colorScheme == .dark ? .white : .black).padding(.bottom, 100)
                    }
                    
                }.tag(2).padding(.horizontal)
                
                ZStack{
             
                    VStack{
                        
                        Image("checkmarksPic")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 300, height: 300).padding(.top, 80)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("Build Habits").padding(.top, 10).bold()
                        Text("Set habits and check off daily completions to build a routine that supports the lifestyle you want to live.").padding(.top, 10).fontWeight(.light).multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        
                    }
                    
                    VStack{
                        Spacer()
                        Button{
                            withAnimation{
                                tutorialTabSelected = 4
                            }
                        }label:{
                            Text("Next").padding(10).padding(.horizontal, 20)
                                .foregroundStyle(colorScheme == .dark ? .black : .white)
                            
                        }.buttonStyle(.borderedProminent).tint(colorScheme == .dark ? .white : .black).padding(.bottom, 100)
                    }
                }.tag(3).padding(.horizontal)
                
         
                ZStack{
                    
                    ScrollView {
                        
                        Image("SecurityPic")
                            .resizable()
                            .renderingMode(.template)
                            .scaledToFit()
                            .frame(width: 300, height: 300).padding(.top, 80)
                            .foregroundColor(colorScheme == .dark ? .white : .black)
                        
                        Text("Secure Journaling").padding(.top, 10).bold()
                        Text("Your privacy is our priority. Entries are locally encrypted and never leave your device. You can also secure them with Face ID, Touch ID, or a passcode.").padding(.top, 10).fontWeight(.light).multilineTextAlignment(.center)
                        
                        Text("No ads. No tracking. No data selling — ever.").padding(.top, 10).fontWeight(.bold).multilineTextAlignment(.center)
                        
                        Spacer()
                    }.scrollIndicators(.hidden)
                    
                    VStack{
                        Spacer()
                        VStack{
                            Button{
                                withAnimation{
                                    tutorialTabSelected = 5
                                }
                            }label:{
                                Text("Next").padding(10).padding(.horizontal, 20)
                                    .foregroundStyle(colorScheme == .dark ? .black : .white)
                                
                            }.buttonStyle(.borderedProminent).tint(colorScheme == .dark ? .white : .black).padding(.bottom, 100)
                        }
                    }
                    
                }.tag(4).padding(.horizontal)
                
       
                ZStack {

                    VStack {

                        ScrollView {
                            VStack {

                                Image(systemName: "rectangle.fill.on.rectangle.fill")
                                    .font(.title)
                                    .padding(.top, 80)

                                Text("6 Unique Journal Styles")
                                    .padding(.top, 10)
                                    .bold()

                                VStack(spacing: 24) {

                                    journalItem(
                                        title: "Morning Preparation",
                                        description: "Set positive intentions for the day."
                                    )

                                    journalItem(
                                        title: "Evening Reflection",
                                        description: "Reflect on your day’s intentions."
                                    )

                                    journalItem(
                                        title: "Mood Check-In",
                                        description: "Track your mood and receive valuable analytics."
                                    )

                                    journalItem(
                                        title: "Gratitude",
                                        description: "Note what you're thankful for."
                                    )

                                    journalItem(
                                        title: "Goal Tracking",
                                        description: "Track your goals with clear visual progress."
                                    )

                                    journalItem(
                                        title: "Capture the Moment",
                                        description: "Reflect on meaningful experiences."
                                    )
                                }
                                .padding(.top, 20)
                                .scaleEffect(0.95)

                                Spacer()
                                    .frame(height: 180) // space for button

                            }
                        }
                        .scrollIndicators(.hidden)
                        .mask(
                            LinearGradient(
                                stops: [
                                    .init(color: .black, location: 0.0),
                                    .init(color: .black, location: 0.9),
                                    .init(color: .clear, location: 1.0)
                                ],
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            
                        )
                        .padding(.bottom, 160)

                    }

                    VStack {
                        Spacer()

                        Button {
                            withAnimation {
                                startupTutorialDone.tutorialIsDone = true
                            }
                        } label: {
                            Text("Start Journaling")
                                .padding(10)
                                .padding(.horizontal, 20)
                                .foregroundStyle(colorScheme == .dark ? .black : .white)
                        }
                        .buttonStyle(.borderedProminent)
                        .tint(colorScheme == .dark ? .white : .black)
                        .padding(.bottom, 100)
                    }

                }
                .tag(5)
                .padding(.horizontal)

                
            }
            .tabViewStyle(PageTabViewStyle())
            .onAppear{
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.primary)
                       UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
            }
        }
        .overlay(alignment: .topTrailing) {
            Button {
                withAnimation {
                    startupTutorialDone.tutorialIsDone = true
                }
            } label: {
                Image(systemName: "xmark")
                    .font(.system(size: 14, weight: .semibold))
                    .padding(15)
                    .background(.ultraThinMaterial)
                    .clipShape(Circle())
            }
            .frame(width: 50, height: 50) // 👈 bigger invisible hitbox
               .contentShape(Circle())    // 👈 entire frame tappable
            .buttonStyle(.plain)
            .tint(colorScheme == .dark ? .white : .black)
            .padding(.top, 20)
            .padding(.trailing, 20)
        }
    }
    
    @ViewBuilder
    func journalItem(title: String, description: String) -> some View {
        VStack(spacing: 6) {
            Text(title)
                .font(.headline)

            Text(description)
                .font(.subheadline)
                .fontWeight(.light)
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding(.vertical, 14)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 18)
                .fill(colorScheme == .dark
                      ? Color.white.opacity(0.05)
                      : Color.black.opacity(0.03))
        )
    }
    
}

#Preview {
    StartupTutorialView().environmentObject(StartupTutorialDone())
}
