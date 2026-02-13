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
                        
                        Text("Jot your thoughts and receive analytics.").multilineTextAlignment(.center) .padding(.top, 10).fontWeight(.light)
                        VStack{
                            Text("It's journaling,").fontWeight(.light)
                            +
                            Text(" but smarter.").bold()
                        }.padding(.top, 10)
                        
                        
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
                        }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                    }
                    
                }.tag(0)
                
                ZStack{

                    VStack{
                        Image(systemName: "sun.max").padding(.top, 130).font(.title)
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
                        }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                    }
                    
                }.tag(1).padding(.horizontal)
                
                ZStack{
      
                    VStack{
                        Image(systemName: "trophy.fill").padding(.top, 130).font(.title)
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
                        }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                    }
                    
                }.tag(2).padding(.horizontal)
                
                ZStack{
             
                    VStack{
                        
                        Image(systemName: "checkmark.circle.fill").padding(.top, 130).font(.title)
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
                        }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                    }
                }.tag(3).padding(.horizontal)
                
                ZStack{
              
                    VStack{
                        Image(systemName: "chart.pie.fill").padding(.top, 130).font(.title)
                        Text("Gain Insights").padding(.top, 10).bold()
                        Text("Chart your journey, uncover mood patterns, dive into rich analytics, and visualize your progress as you achieve your goals.").padding(.top, 10).fontWeight(.light).multilineTextAlignment(.center)
                        
                        Spacer()
                        
                        
                        
                    }
                    
                    VStack{
                        Spacer()
                        Button{
                            withAnimation{
                                tutorialTabSelected = 5
                            }
                        }label:{
                            Text("Next").padding(10).padding(.horizontal, 20)
                        }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                    }
                }.tag(4).padding(.horizontal)
                
         
                    ZStack{
                     
                        ScrollView {
                            
                            Image(systemName: "lock.shield").padding(.top, 80).font(.title)
                            Text("Secure Journaling").padding(.top, 10).bold()
                            Text("Your privacy is our priority. Entries are locally encrypted, and you can secure them with Face ID, Touch ID, or a passcode.").padding(.top, 10).fontWeight(.light).multilineTextAlignment(.center)
                            
                            Spacer()
                        }.scrollIndicators(.hidden)
                        
                        VStack{
                            Spacer()
                            VStack{
                                Button{
                                    withAnimation{
                                        tutorialTabSelected = 6
                                    }
                                }label:{
                                    Text("Next").padding(10).padding(.horizontal, 20)
                                }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                            }
                        }
                        
                    }.tag(5).padding(.horizontal)
                
       
                    ZStack{
                        
                        
                        
                        ScrollView {
                            Image(systemName: "rectangle.fill.on.rectangle.fill").padding(.top, 20).font(.title)
                            Text("6 Journal Styles").padding(.top, 10).bold()
                            
                            
                            
                            VStack{
                                Text("Morning Preparation").padding(.bottom, 3)
                                Text("Set positive intentions for the day.").fontWeight(.light).multilineTextAlignment(.center).font(.subheadline).opacity(0.75)
                                
                                Divider().padding(.vertical, 4)
                                
                                Text("Evening Reflection").padding(.bottom, 3)
                                Text("Reflect on your days intentions.").fontWeight(.light).multilineTextAlignment(.center).opacity(0.75)
                                
                                Divider().padding(.vertical, 4)
                                
                                Text("Mood Check-In").padding(.bottom, 3)
                                Text("Track your emotions and receive weekly analyses.").fontWeight(.light).multilineTextAlignment(.center).opacity(0.75)
                                
                                Divider().padding(.vertical, 4)
                                
                                Text("Gratitude").padding(.bottom, 3)
                                Text("Note what you're thankful for.").fontWeight(.light).multilineTextAlignment(.center).opacity(0.75)
                                
                                
                                Divider().padding(.vertical, 4)
                                
                                Text("Goal Tracking").padding(.bottom, 3)
                                Text("Track goals with weekly analyses.").fontWeight(.light).multilineTextAlignment(.center).opacity(0.75)
                                
                                Divider().padding(.vertical, 4)
                                
                                Text("Capture the Moment").padding(.bottom, 3)
                                Text("Reflect on meaningful experiences.").fontWeight(.light).multilineTextAlignment(.center).opacity(0.75)
                                
                            }.padding().overlay{
                                RoundedRectangle(cornerRadius: 20).stroke(lineWidth: 0.5).foregroundStyle(.gray)
                            }.scaleEffect(0.9)
                            Spacer().frame(height: 150)
                        }.padding().scrollIndicators(.hidden)
                        
                        VStack{
                            Spacer()
                            ZStack{
                                Rectangle().foregroundStyle(colorScheme == .light ? Color.white : Color.black).frame(height: 160)
                                Rectangle().foregroundStyle(Color.gray.opacity(0.1)).frame(height: 160)
                            }
                        }
                        
                        VStack{
                            Spacer()
                            Button{
                                withAnimation{
                                    startupTutorialDone.tutorialIsDone = true
                                }
                            }label:{
                                Text("Start Journaling").padding(10).padding(.horizontal, 20)
                            }.buttonStyle(.borderedProminent).tint(.black).padding(.bottom, 100)
                        }
                        
                    }.tag(6).padding(.horizontal)
                
            }
            .tabViewStyle(PageTabViewStyle()).ignoresSafeArea().onAppear{
                UIPageControl.appearance().currentPageIndicatorTintColor = UIColor(.primary)
                       UIPageControl.appearance().pageIndicatorTintColor = UIColor(.secondary)
            }
        }
    }
}

#Preview {
    StartupTutorialView().environmentObject(StartupTutorialDone())
}
