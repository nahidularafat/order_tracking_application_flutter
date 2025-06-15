class MyOrder {
  String? id;
  String? name;
  String? phone;
  String? address;
  double? latitude;
  double? longitude;
  int? amount;

  MyOrder({
    this.id,
    this.name,
    this.phone,
    this.address,
    this.latitude,
    this.longitude,
    this.amount,
  });

  factory MyOrder.fromJson(Map<String, dynamic> json) => MyOrder(
        id: json["id"],
        name: json["name"],
        phone: json["phone"],
        address: json["address"],
        latitude: (json["latitude"] as num?)?.toDouble(),
        longitude: (json["longitude"] as num?)?.toDouble(),
        amount: (json["amount"] as num?)?.toInt(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "phone": phone,
        "address": address,
        "latitude": latitude,
        "longitude": longitude,
        "amount": amount,
      };
}
