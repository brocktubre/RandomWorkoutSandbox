//
//  DetailsView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//

import SwiftUI
import Combine

struct DetailsView: View {
    let equipment: Equipment
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                FavoriteButton(equipment: equipment)
                EquipmentNameAndIdStack(equipment: equipment, equipmentFont: .largeTitle)
            }
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
    @State private var showAlert: Bool = false
    @ObservedObject var wc = WorkoutController()
    var body: some View {
        
        VStack {
                Spacer()
                Text(movement)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                Spacer()
                Button(action:{
                    self.showAlert = true
                }) {
                    HStack {
                        Text("Generate New Movement").accentColor(.white)
                    }
                }.onAppear() {
                    DispatchQueue.main.async {
                        _ = wc.getMovementsByEqId(equipment.id).subscribe()
                        _ = wc.getRandomMovement(equipmentId: equipment.id)
                            .subscribe(onNext: { m in
                             movement = m
                        })
                    }
                }
                .padding()
                .background(Color.blue)
                .alert(isPresented: $showAlert, content: {
                    .init(
                        title: .init("Generate new \(equipment.name.lowercased()) movement?"),
                          primaryButton: .default(.init("Yes")) {
                            DispatchQueue.main.async {
                                _ = wc.getMovementsByEqId(equipment.id).subscribe()
                                _ = wc.getRandomMovement(equipmentId: equipment.id)
                                    .subscribe(onNext: { m in
                                     movement = m
                                })
                            }
                          }, secondaryButton: .cancel())

                })

        }
    }
}

struct DetailsView_Previews: PreviewProvider {
    static var previews: some View {
        DetailsView_Preview(equipment: .init())
            .previewInAllColorSchemes
    }
}

// Only for preview purposes
struct DetailsView_Preview: View {
    let equipment: Equipment
    var body: some View {
        VStack {
            Spacer()
            HStack(spacing: 16) {
                FavoriteButton(equipment: Equipment())
                EquipmentNameAndIdStack(equipment: equipment, equipmentFont: .largeTitle)
            }
            Equipment.Image(name: equipment.imageName)
            Spacer()
            RandomMovementView_Preview(equipment: equipment, movement: Movement(equipment: equipment).movement)
            Spacer()
        }.padding()
    }
}
// Only for preview purposes
struct RandomMovementView_Preview: View {
    let equipment: Equipment
    @State public var movement: String
    @State private var showAlert: Bool = false
    var body: some View {
        
        VStack {
                Spacer()
                Text(movement)
                .font(.largeTitle)
                .multilineTextAlignment(.center)
                Spacer()
                Button(action:{
                    self.showAlert = true
                }) {
                    HStack {
                        Text("Generate New Movement").accentColor(.white)
                    }
                }.onAppear() {
                    movement = MovementList().sortedMovements.first?.movement ?? "wall balls"
                    
                }
                .padding()
                .background(Color.blue)
                .alert(isPresented: $showAlert, content: {
                    .init(
                        title: .init("Generate new \(equipment.name.lowercased()) movement?"),
                          primaryButton: .default(.init("Yes")) {
                            movement = MovementList().sortedMovements.first?.movement ?? "wall balls"
                          }, secondaryButton: .cancel())

                })

        }
    }
}
