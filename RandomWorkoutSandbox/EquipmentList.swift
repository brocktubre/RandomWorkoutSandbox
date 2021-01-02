struct EquipmentList {
  var sortedEquipment: [Equipment] { equipmentCache }

  /// An in-memory cache of the manually-sorted books that are persistently stored.
  private var equipmentCache: [Equipment] = [
        .init(name: "Wall Ball", id: "abc", imageName: "wallball"),
        .init(name: "Rings", id: "abcd", imageName: "rings"),
        .init(name: "Dubmbbell", id: "xyz", imageName: "dumbbell")
  ]
}
