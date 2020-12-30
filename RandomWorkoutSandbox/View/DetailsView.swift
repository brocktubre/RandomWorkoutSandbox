//
//  DetailsView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//

import SwiftUI

struct DetailsView: View {
    let equipment: Equipment
    var body: some View {
        VStack {
            EquipmentNameAndIdStack(equipment: equipment, equipmentFont: .largeTitle)
            Equipment.Image(name: equipment.imageName)
            Spacer()
            RandomMovementView(equipment: equipment, movement: Movement(equipment: equipment).movement)
            Spacer()
        }.padding()
    }
}

struct RandomMovementView: View {
    let equipment: Equipment
    @State public var movement: String
    var body: some View {
        
        VStack(alignment: .center) {
            Text(movement).font(.largeTitle)
                Spacer()
                Button(action:{
                    movement = WorkoutController().getRandomMovement(equipmentId: equipment.id)
                }) {
                    HStack {
                        Text("Generate New Movement").accentColor(.white)
                    }
                }.onAppear() {
                    movement = WorkoutController().getRandomMovement(equipmentId: equipment.id)
                }
                .padding()
                .background(Color.blue)
        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView(equipment: .init())
    }
}
