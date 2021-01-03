//
//  ContentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI
import RxSwift
import Amplify

struct EquipmentListView: View {
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @ObservedObject var wc = WorkoutController()
    @ObservedObject var equipment = Equipment()
    @State var authStatus: String?
    let user: AuthUser
    
    var body: some View {
            List(wc.inMemoryEquipmentList) { equipment in
                EquipmentRow(equipment: equipment, wc: wc)
            }.navigationTitle("Equipment")
            .navigationBarItems(trailing: Button("Logout", action: {              sessionManagerService.signOut()
                })
            )
            .listStyle(PlainListStyle())
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


struct EquipmentRow: View {
    let equipment: Equipment
    let wc: WorkoutController
    @EnvironmentObject var sessionManagerService: SessionManagerService
    var body: some View {
        NavigationLink(
            destination: DetailsView(equipment: equipment, wc: wc)
                .environmentObject(sessionManagerService)
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

struct EquipmentListView_Previews: PreviewProvider {
    static var previews: some View {
        List(EquipmentList().sortedEquipment) { equipment in
            EquipmentRow(equipment: .init(name: equipment.name, id: equipment.id, imageName: equipment.imageName), wc: WorkoutController())
        }.previewInAllColorSchemes
    }
}
