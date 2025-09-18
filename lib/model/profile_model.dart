class ProfileModel {
  dynamic status;
  Data? data;

  ProfileModel({this.status, this.data});

  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      status: json['status'],
      data: json['data'] != null ? Data.fromJson(json['data']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}

class Data {
  dynamic userId;
  dynamic name;
  dynamic email;
  dynamic phone;
  dynamic gender;
  dynamic country;
  dynamic state;
  dynamic city;
  dynamic profileImg;
  dynamic isProfileCreated;
  dynamic status;
  dynamic dateOfBirth;
  dynamic birthTime;
  dynamic sign;
  dynamic wallet;
  dynamic createdAt;
  dynamic pinCode;

  Data({
    this.userId,
    this.name,
    this.email,
    this.phone,
    this.gender,
    this.country,
    this.state,
    this.city,
    this.profileImg,
    this.isProfileCreated,
    this.status,
    this.dateOfBirth,
    this.birthTime,
    this.sign,
    this.wallet,
    this.createdAt,
    this.pinCode
  });

  factory Data.fromJson(Map<String, dynamic> json) {
    return Data(
      userId: json['user_id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      country: json['country'],
      state: json['state'],
      city: json['city'],
      profileImg: json['profile_img'],
      isProfileCreated: json['is_profile_created'],
      status: json['status'],
      dateOfBirth: json['date_of_birth'],
      birthTime: json['birth_time'],
      sign: json['sign'],
      wallet: json['wallet'],
      createdAt: json['created_at'],
      pinCode: json["pin_code"]??""

    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['user_id'] = this.userId;
    data['name'] = this.name;
    data['email'] = this.email;
    data['phone'] = this.phone;
    data['gender'] = this.gender;
    data['country'] = this.country;
    data['state'] = this.state;
    data['city'] = this.city;
    data['profile_img'] = this.profileImg;
    data['is_profile_created'] = this.isProfileCreated;
    data['status'] = this.status;
    data['date_of_birth'] = this.dateOfBirth;
    data['birth_time'] = this.birthTime;
    data['sign'] = this.sign;
    data['wallet'] = this.wallet;
    data['created_at'] = this.createdAt;
    data["pin_code"] = this.pinCode;
    return data;
  }
}

class Certifications {
  int? certificateId;
  String? certificate;
  String? fileSize;

  Certifications({this.certificateId, this.certificate, this.fileSize});

  Certifications.fromJson(Map<String, dynamic> json) {
    certificateId = json['certificate_id'];
    certificate = json['certificate'];
    fileSize = json['file_size'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['certificate_id'] = this.certificateId;
    data['certificate'] = this.certificate;
    data['file_size'] = this.fileSize;
    return data;
  }
}
