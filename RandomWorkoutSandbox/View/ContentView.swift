//
//  ContentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List(WorkoutController().getAllEquipmentList(), id: \.id) { equipment in
                EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName))
            }.navigationTitle("Equipment")
        }
    }
        
}


struct EquipmentRow: View {
    let equipment: Equipment
    var body: some View {
        NavigationLink(
            destination: DetailsView(equipment: equipment)
            ) {
            HStack{
                Equipment.Image(name: equipment.imageName, size: 80)
                EquipmentNameAndIdStack(equipment: equipment, equipmentFont: .title)
            }.lineLimit(1)
        }.padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        List(EquipmentList().sortedEquipment, id: \.id) { equipment in
            EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName))
        }.previewInAllColorSchemes
    }
}
