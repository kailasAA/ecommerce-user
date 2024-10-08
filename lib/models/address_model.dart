class AddressModel {
  String? name;
  String? phoneNumber;
  String? addressLine;
  String? city;
  String? state;
  String? postalCode;
  String? id;

  AddressModel(
      {this.name,
      this.phoneNumber,
      this.addressLine,
      this.city,
      this.state,
      this.postalCode,
      this.id});

  factory AddressModel.fromJson(Map<String, dynamic> json) {
    return AddressModel(
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        addressLine: json['addressLine'],
        city: json['city'],
        state: json['state'],
        postalCode: json['postalCode'],
        id: json['id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phoneNumber': phoneNumber,
      'addressLine': addressLine,
      'city': city,
      'state': state,
      'postalCode': postalCode,
      'id': id
    };
  }
}
