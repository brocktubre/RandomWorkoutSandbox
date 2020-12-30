//
//  MovementView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/28/20.
//

import SwiftUI

extension Movement {
    struct Text: View {
        let name: String
        var body: some View {
            let workout = SwiftUI.Text(name) ??
                .init("ring muscle ups")
            workout
                .font(Font/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.weight(.heavy))
                .foregroundColor(.secondary)
        }
    }

}

struct Movement_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Movement.Text(name: "wall balls")
        }
    }
}

extension Text {
    init?(title: String) {
        return nil
    }
    self.init(text: "ring rows")
}

//import Foundation
//import SwiftUI
//private var inMemoryMovements:Array<Movement> = Array<Movement>();
//
//struct WorkoutByEquipmentView: View {
//    @State private var movment:String = "Ready for new movement?"
//    let wc = WorkoutController()
//    var body: some View {
//        ZStack{
//            Color.black.ignoresSafeArea()
//            VStack {
//                Spacer()
//                Text(movment)
//                    .multilineTextAlignment(.center)
//                    .foregroundColor(Color.white)
//                    .font(.largeTitle)
//                    .padding(.all)
//                Spacer()
//                Button("Generate Movement", action: {
//                    movment = wc.getRandomMovement(inMemoryMovements)
//                }).onAppear() {
//                    inMemoryMovements = wc.inMemoryMovements
//                }
//                .padding(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
//                .accentColor(Color.white)
//                .background(Color.green
//                                .blur(radius: /*@START_MENU_TOKEN@*/3.0/*@END_MENU_TOKEN@*/))
//                .font(.title2)
//
//                Spacer()
//            }
//
//        }
//    }
//}
