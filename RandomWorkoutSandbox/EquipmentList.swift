struct EquipmentList {
  var sortedEquipment: [Equipment] { equipmentCache }

  /// An in-memory cache of the manually-sorted books that are persistently stored.
  private var equipmentCache: [Equipment] = [
        .init(name: "Wall Ball", id: 0, imageName: "wallball"),
        .init(name: "Rings", id: 1, imageName: "rings"),
        .init(name: "Dubmbbell", id: 2, imageName: "dumbbell"),
        .init(name: "Wall Ball", id: 0, imageName: "wallball"),
        .init(name: "Rings", id: 1, imageName: "rings"),
        .init(name: "Dubmbbell", id: 2, imageName: "dumbbell"),
        .init(name: "Wall Ball", id: 0, imageName: "wallball"),
        .init(name: "Rings", id: 1, imageName: "rings"),
        .init(name: "Dubmbbell", id: 2, imageName: "dumbbell")
  ]
}
