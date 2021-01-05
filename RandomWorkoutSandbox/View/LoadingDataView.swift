//
//  LoadingDataView.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 1/4/21.
//

import SwiftUI
import Amplify

struct LoadingDataView: View {
    let user: AuthUser
    @ObservedObject var wc = WorkoutController()
    @ObservedObject var favoriteEquipmentController = FavoriteEquipmentController()
    @EnvironmentObject var sessionManagerService: SessionManagerService
    @State var showEquipmentList = true
    @State private var dataLoaded:Bool = false
    
    var body: some View {
        
        ProgressView()
            .navigate(to: EquipmentListView(user: user, wc: wc).environmentObject(sessionManagerService),
                      when: $dataLoaded)
        .onAppear(){
            // TODO Need to find a better way to NOT next subscriptions
            wc.getMovements().subscribe(onNext: { allMovements in
                favoriteEquipmentController.getUsersFavoriteEquipment(userId: sessionManagerService.getUserId())
                    .subscribe(onNext: { favorites in
                        DispatchQueue.main.async {
                            wc.inMemoryMovements = allMovements
                            wc.getAllEquipmentList(favorites: favorites)
                            self.dataLoaded = true
                        }
                    })
            })
        }
    }
}

struct LoadingDataView_Previews: PreviewProvider {
    static var previews: some View {
        LoadingDataView(user: AuthUser.self as! AuthUser)
    }
}

extension View {

    /// Navigate to a new view.
    /// - Parameters:
    ///   - view: View to navigate to.
    ///   - binding: Only navigates when this condition is `true`.
    func navigate<NewView: View>(to view: NewView, when binding: Binding<Bool>) -> some View {
        ZStack {
            self
                .navigationBarTitle("")
                .navigationBarHidden(true)

            NavigationLink(
                destination: view
                .navigationBarBackButtonHidden(true),
                isActive: binding
            ) {
                EmptyView()
            }
        }
    }
}
