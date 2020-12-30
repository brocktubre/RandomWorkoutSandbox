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
            let workout = SwiftUI.Text(name)
            workout
                .font(Font/*@START_MENU_TOKEN@*/.title/*@END_MENU_TOKEN@*/.weight(.heavy))
                .foregroundColor(.secondary)
        }
    }

}

struct Movement_Previews: PreviewProvider {
    static var previews: some View {
        VStack{
            Text("wall balls")
        }
    }
}
