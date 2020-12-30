//
//  ContentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI
import Foundation

struct ContentView: View {
    let wc = WorkoutController()
    
    var body: some View {
        ZStack{
            Color.black.ignoresSafeArea()
            VStack {
                Spacer()
                NavigationView {
                    List(wc.getAllEquipmentList(), id: \.self) { eq in
                        NavigationLink(destination: WorkoutByEquipmentView()) {
                            Text("\(eq)")
                                .padding(.bottom)
                                .font(.body)
                                .foregroundColor(Color.black)
                        }
                    }
                }
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
