class Ramedy_Model {
  bool? status;
  List<Data>? data;

  Ramedy_Model({this.status, this.data});

  Ramedy_Model.fromJson(Map<String, dynamic> json) {
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
  int? astroId;
  String? astrologerName;
  String? astroImg;
  String? description;

  Data(
      {this.id,
      this.astroId,
      this.astrologerName,
      this.astroImg,
      this.description});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    astroId = json['astro_id'];
    astrologerName = json['astrologer_name'];
    astroImg = json['astro_img'];
    description = json['description'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['astro_id'] = this.astroId;
    data['astrologer_name'] = this.astrologerName;
    data['astro_img'] = this.astroImg;
    data['description'] = this.description;
    return data;
  }
}
