class BannerModel {
  bool? status;
  List<String>? data;

  BannerModel({this.status, this.data});

  BannerModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    // Check if 'data' exists in the JSON and is a list before casting
    if (json['data'] != null && json['data'] is List) {
      data = List<String>.from(json['data']);
    } else {
      // Handle the case when 'data' is not a list or is null
      data = [];
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['data'] = this.data;
    return data;
  }
}
