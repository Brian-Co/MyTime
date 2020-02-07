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
                    VStack {
                        Text("\(timer.name)")
                            .font(.system(size: 15))
                            .minimumScaleFactor(0.5)
                            .lineLimit(1)
                            .frame(width: 60, height: 15, alignment: .leading)
//                            .padding(.top)
                        Text(timer.totalDurationString)
                        .font(.system(size: 9))
                        .frame(width: 60, height: 15, alignment: .leading)
//                            .padding(.bottom)
                    }
//                        .padding()
                    
//                    Spacer()
                    Text(timer.elapsedTimeString)
                        .font(.system(size: 9))
                        .frame(width: 45, height: 30, alignment: .center)
//                        .padding(.trailing)
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
        }.navigationBarTitle("MyTime")
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView(dataSource: APIWatchAppDataSource(preview: true))
    }
}
