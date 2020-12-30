//
//  EquipmentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//
import SwiftUI

struct EquipmentNameAndIdStack: View {
    let equipment: Equipment
    let equipmentFont: Font
    var body: some View {
        VStack(alignment: .leading){
            Text(equipment.name.capitalized).font(equipmentFont)
//            Text("Equipment ID: \(String(equipment.id))")
//                    .font(.title3).foregroundColor(.secondary)
        }
    }
}


extension Equipment {
    struct Image: View {
        let name: String
        var size: CGFloat?
        var body: some View {
            let symbol = SwiftUI.Image(title: name) ??
                .init("wallball")
            symbol
                .resizable()
                .scaledToFit()
                .frame(width: size, height: size)
                .font(Font/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.weight(.light))
                .foregroundColor(.secondary)
        }
    }

}

struct Equipment_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            EquipmentNameAndIdStack(equipment: Equipment(), equipmentFont: .largeTitle)
            Equipment.Image(name: Equipment().imageName)
            Equipment.Image(name: "dumbbell")
            Equipment.Image(name: "Something else")
        }
    }
}

extension Image {
    init?(title: String) {
        let imageExist = UIImage(named: title) != nil
        if (imageExist) {
            self.init(title)
        } else {
            let char = title.first
            let symbolName = "\(char?.lowercased() ?? "").square"
            self.init(systemName: symbolName)
        }
    }
}

