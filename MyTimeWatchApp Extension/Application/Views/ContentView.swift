//
//  ContentView.swift
//  MyTimeWatchApp Extension
//
//  Created by Brian Corrieri on 06/02/2020.
//  Copyright © 2020 FairTrip. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var dataSource: APIWatchAppDataSource
    
    var body: some View {
        List {
            ForEach(dataSource.content) { timer in
                HStack {
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 5, height: 25, alignment: .center)
                        .foregroundColor(TimerColor(rawValue: timer.color)?.create)
                    VStack(alignment: .leading) {
                        Text("\(timer.name)")
                            .font(.system(size: 15))
                            .minimumScaleFactor(0.8)
                            .lineLimit(1)
                        
                        Text(timer.totalDurationString)
                        .font(.system(size: 9))
                    }
                    
                    Spacer()
                    
                    Text(timer.elapsedTimeString)
                        .font(.system(size: 9))
                    .minimumScaleFactor(0.8)
                    
                    Button(action: {
                        self.dataSource.timerButtonPressed(timer)
                        print("pressed")
                    }, label: {
                        Image(systemName: "timer")
                        .frame(width: 12, height: 12, alignment: .center)
                    }).frame(width: 12, height: 12, alignment: .center)
                        .padding()
                        .background(TimerColor(rawValue: timer.buttonColor)?.create)
                        .cornerRadius(15)
                }
            }
            
            HStack {
                
                RoundedRectangle(cornerRadius: 10)
                .frame(width: 5, height: 25, alignment: .center)
                    .foregroundColor(.green)
                
                Text("Add Timer")
                    .font(.system(size: 15))
                    .minimumScaleFactor(0.8)
                    .lineLimit(1)
                    .padding(.trailing)
               
                Spacer()
                
                Button(action: {
                    self.dataSource.addTimer()
                }, label: {
                    Image(systemName: "plus")
                    .frame(width: 24, height: 24, alignment: .center)
                }).background(Color.green)
                .frame(width: 24, height: 24, alignment: .center)
                .cornerRadius(15)
                .padding(4)
            }
        }.navigationBarTitle("MyTime")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataSource: APIWatchAppDataSource(preview: true))
    }
}
