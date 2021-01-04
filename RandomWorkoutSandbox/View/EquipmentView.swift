//
//  EquipmentView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/30/20.
//
import SwiftUI

struct FavoriteButton: View {
    @ObservedObject var equipment: Equipment
    @EnvironmentObject var sessionManagerService: SessionManagerService
    let wc: WorkoutController
    
    var body: some View {
        let bookmark:String = "bookmark"
        Button {
            equipment.favorite.toggle()
            wc.addFavoriteToUser(equipment: equipment, userId: sessionManagerService.getUserId())
        } label: {
            Image(systemName: equipment.favorite ? "\(bookmark).fill" : bookmark)
                .font(.system(size: 48, weight: .light))
        }
    }
}

struct EquipmentNameAndIdStack: View {
    let equipment: Equipment
    let equipmentFont: Font
    var body: some View {
        VStack(alignment: .leading){
            Text(equipment.name.capitalized).font(equipmentFont)
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
            HStack {
//                FavoriteButton(equipment: Equipment(), wc: WorkoutController)
//                FavoriteButton(equipment: Equipment(favorite: true), wc: WorkoutController)
                EquipmentNameAndIdStack(equipment: Equipment(), equipmentFont: .largeTitle)
            }
            Equipment.Image(name: Equipment().imageName)
            Equipment.Image(name: "dumbbell")
            Equipment.Image(name: "Something else")
        }.previewInAllColorSchemes
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

extension View {
    var previewInAllColorSchemes: some View {
        ForEach(ColorScheme.allCases, id: \.self, content: preferredColorScheme)
    }
}

