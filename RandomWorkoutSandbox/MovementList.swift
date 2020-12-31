//
//  MovementList.swift
//  RandomWorkoutSandbox
//
//  Created by Brock Tubre on 12/31/20.
//

struct MovementList {
  var sortedMovements: [Movement] { movementCache }

  /// An in-memory cache of the manually-sorted books that are persistently stored.
  private var movementCache: [Movement] = [
        .init(movement: "wall balls", difficulty: 1, repType: "count", dynamic: false, equipment: Equipment(), id: 0)
  ]
}

