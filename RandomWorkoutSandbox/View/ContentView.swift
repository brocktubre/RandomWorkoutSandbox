//
//  ContentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI
import RxSwift

struct ContentView: View {
    @ObservedObject var wc = WorkoutController()
    
    var body: some View {
        NavigationView {
            List(wc.inMemoryEquipmentList) { equipment in
                EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName), wc: wc)
            }.navigationTitle("Equipment")
            .onAppear(){
                wc.getMovements().subscribe(onNext: { allMovements in
                    DispatchQueue.main.async {
                            wc.inMemoryMovements = allMovements
                            wc.getAllEquipmentList()

                    }
                })
            }
        }
    }
        
}


struct EquipmentRow: View {
    let equipment: Equipment
    let wc: WorkoutController
    var body: some View {
        NavigationLink(
            destination: DetailsView(equipment: equipment, wc: wc)
            ) {
            HStack{
                FavoriteButton(equipment: equipment)
                    .buttonStyle(BorderlessButtonStyle())
                Equipment.Image(name: equipment.imageName, size: 80)
                EquipmentNameAndIdStack(equipment: equipment, equipmentFont: .title)
            }.lineLimit(1)
        }.padding(.vertical, 8)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        List(EquipmentList().sortedEquipment) { equipment in
            EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName), wc: WorkoutController())
        }.previewInAllColorSchemes
    }
}
