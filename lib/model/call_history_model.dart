class Call_History_Model {
  bool? status;
  List<Data>? data;

  Call_History_Model({this.status, this.data});

  Call_History_Model.fromJson(Map<String, dynamic> json) {
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
  String? name;
  String? profilePic;
  String? date;
  String? time;
  String? communicationId;
  String? status;
  String? type;
  String? callDuration;

  Data(
      {this.id,
      this.astroId,
      this.name,
      this.profilePic,
      this.date,
      this.time,
      this.communicationId,
      this.status,
      this.type,
      this.callDuration});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    astroId = json['astro_id'];
    name = json['name'];
    profilePic = json['profile_pic'];
    date = json['date'];
    time = json['time'];
    communicationId = json['communication_id'];
    status = json['status'];
    type = json['type'];
    callDuration = json['call_duration'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['astro_id'] = this.astroId;
    data['name'] = this.name;
    data['profile_pic'] = this.profilePic;
    data['date'] = this.date;
    data['time'] = this.time;
    data['communication_id'] = this.communicationId;
    data['status'] = this.status;
    data['type'] = this.type;
    data['call_duration'] = this.callDuration;
    return data;
  }
}
