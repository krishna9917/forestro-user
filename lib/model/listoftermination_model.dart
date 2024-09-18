class Listof_Testimonial_Model {
  bool? status;
  List<Data>? data;

  Listof_Testimonial_Model({this.status, this.data});

  Listof_Testimonial_Model.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? image;
  String? rating;
  String? comment;

  Data({this.name, this.image, this.rating, this.comment});

  Data.fromJson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
    rating = json['rating'];
    comment = json['comment'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['name'] = this.name;
    data['image'] = this.image;
    data['rating'] = this.rating;
    data['comment'] = this.comment;
    return data;
  }
}
