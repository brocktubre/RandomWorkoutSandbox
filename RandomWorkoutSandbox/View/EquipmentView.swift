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
            Equipment.Image(name: Equipment().name)
            Equipment.Image(name: "")
            Equipment.Image(name: "brock")
        }
    }
}

extension Image {
    init?(title: String) {
        guard
            let char = title.first,
            case let symbolName = "\(char.lowercased()).square",
            UIImage(systemName: symbolName) != nil else {
            return nil
        }
        self.init(systemName: symbolName)
    }
}

