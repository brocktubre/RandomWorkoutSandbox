//
//  ContentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI
import Foundation

private var inMemoryMovements:Array<MovementObject> = Array<MovementObject>();

struct ContentView: View {
    
    @State private var movment:String = "Ready for new movement?"
    
    var body: some View {
    
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                Text(movment)
                    .multilineTextAlignment(.center).foregroundColor(Color.white).font(.largeTitle).padding(.all)
                Spacer()
                Button("Generate Movement", action: {
                    let allMovements:Array<MovementObject> = inMemoryMovements
                    let numberOfMovements:Int = allMovements.count
                    let randomIndex = Int.random(in: 0..<numberOfMovements)
                    movment = allMovements[randomIndex].movement
                }).onAppear() {
                    let wc = WorkoutController()
                    inMemoryMovements = wc.getMovements()
                }
                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
                .accentColor(Color.white)
                .background(Color.green
                                .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
                .font(.title2)
                
                Spacer()
            }
            
        }
    }
        
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
