//
//  ContentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI
import Foundation

struct ContentView: View {
    var body: some View {
        EquipmentRow(equipment: .init())
    }
        
}


struct EquipmentRow: View {
    let equipment: Equipment
    var body: some View {
        HStack{
            Equipment.Image(name: equipment.imageName)
            Text(equipment.name)
                .font(.title2)
                .multilineTextAlignment(.leading)
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}

