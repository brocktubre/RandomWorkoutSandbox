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
        List(WorkoutController().getAllEquipmentList(), id: \.id) { equipment in
            EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName))
        }
    }
        
}


struct EquipmentRow: View {
    let equipment: Equipment
    var body: some View {
        HStack{
            Equipment.Image(name: equipment.imageName)
            Spacer()
            Text(equipment.name)
                .font(.title2)
                .fontWeight(/*@START_MENU_TOKEN@*/.bold/*@END_MENU_TOKEN@*/)
                .multilineTextAlignment(.leading)
                .lineLimit(1)
            Spacer()
            
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        List(EquipmentList().sortedEquipment, id: \.id) { equipment in
            EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName))
        }
    }
}

