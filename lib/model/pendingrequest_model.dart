class PandingRequest_Model {
  bool? status;
  List<Data>? data;

  PandingRequest_Model({this.status, this.data});

  PandingRequest_Model.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    if (json['data'] != null) {
      data = <Data>[];
      json['data'].forEach((v) {
        data!.add(new Data.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    if (this.data != null) {
      data['data'] = this.data!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Data {
  int? id;
  String? astroName;
  String? astroProfileImage;

  Data({this.id, this.astroName, this.astroProfileImage});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    astroName = json['astro_name'];
    astroProfileImage = json['astro_profile_image'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['astro_name'] = this.astroName;
    data['astro_profile_image'] = this.astroProfileImage;
    return data;
  }
}
