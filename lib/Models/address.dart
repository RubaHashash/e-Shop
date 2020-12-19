
class AddressModel {
  String name;
  String phoneNumber;
  String homeNumber;
  String city;
  String state;
  String addressDetails;
  String pincode;
  double latitude;
  double longitude;

  AddressModel(
      {this.name,
        this.phoneNumber,
        this.homeNumber,
        this.city,
        this.state,
        this.addressDetails,
        this.pincode,
        this.latitude,
        this.longitude});

  AddressModel.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    phoneNumber = json['phoneNumber'];
    homeNumber = json['homeNumber'];
    city = json['city'];
    state = json['state'];
    addressDetails = json['addressDetails'];
    pincode = json['pincode'];
    latitude = json['latitude'];
    longitude = json['longitude'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['phoneNumber'] = this.phoneNumber;
    data['homeNumber'] = this.homeNumber;
    data['city'] = this.city;
    data['state'] = this.state;
    data['addressDetails'] = this.addressDetails;
    data['pincode'] = this.pincode;
    data['latitude'] = this.latitude;
    data['longitude'] = this.longitude;
    return data;
  }
}