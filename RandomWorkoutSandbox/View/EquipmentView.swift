//
//  EquipmentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//
import SwiftUI

extension Equipment {
    struct Image: View {
        let name: String
        var body: some View {
            let symbol = SwiftUI.Image(title: name) ??
                .init("wallball")
            symbol
                .resizable()
                .scaledToFit()
                .frame(width: 80, height: 80)
                .font(Font/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.weight(.light))
                .foregroundColor(.secondary)
        }
    }

}

struct Equipment_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
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

