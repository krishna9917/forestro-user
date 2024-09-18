class ListAustroModel {
  dynamic status;
  List<Data>? data;

  ListAustroModel({this.status, this.data});

  ListAustroModel.fromJson(Map<String, dynamic> json) {
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
  dynamic id;
  dynamic name;
  dynamic profileImg;
  dynamic experience;
  dynamic rating;
  List<dynamic>? languaage;
  dynamic specialization;
  dynamic beforeChatDiscountPrice;
  dynamic chatChargesPerMin;
  dynamic chatCouponCode;
  dynamic chatDiscountStatus;
  dynamic beforeCallChargesPerMin;
  dynamic callChargesPerMin;
  dynamic callCouponCode;
  dynamic callDiscountStatus;
  dynamic callDiscountStatusType;
  dynamic beforVideoChargesPerMin;
  dynamic videoChargesPerMin;
  dynamic videoCouponCode;
  dynamic videoDiscountStatus;
  dynamic isOnline;
  dynamic followStatus;
  dynamic notifactionToken;

  Data(
      {this.id,
      this.name,
      this.profileImg,
      this.experience,
      this.rating,
      this.languaage,
      this.specialization,
      this.beforeChatDiscountPrice,
      this.chatChargesPerMin,
      this.chatCouponCode,
      this.chatDiscountStatus,
      this.beforeCallChargesPerMin,
      this.callChargesPerMin,
      this.callCouponCode,
      this.callDiscountStatus,
      this.callDiscountStatusType,
      this.beforVideoChargesPerMin,
      this.videoChargesPerMin,
      this.videoCouponCode,
      this.videoDiscountStatus,
      this.isOnline,
      this.followStatus,
      this.notifactionToken});

  Data.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    profileImg = json['profile_img'];
    experience = json['experience'];
    rating = json['rating'];
    languaage = json['languaage'].cast<String>();
    specialization = json['specialization'];
    beforeChatDiscountPrice = json['before_chat_discount_price'];
    chatChargesPerMin = json['chat_charges_per_min'];
    chatCouponCode = json['chat_coupon_code'];
    chatDiscountStatus = json['chat_discount_status'];
    beforeCallChargesPerMin = json['before_call_charges_per_min'];
    callChargesPerMin = json['call_charges_per_min'];
    callCouponCode = json['call_coupon_code'];
    callDiscountStatus = json['call_discount_status'];
    callDiscountStatusType = json['call_discount_status_type'];
    beforVideoChargesPerMin = json['befor_video_charges_per_min'];
    videoChargesPerMin = json['video_charges_per_min'];
    videoCouponCode = json['video_coupon_code'];
    videoDiscountStatus = json['video_discount_status'];
    isOnline = json['is_online'];
    followStatus = json['follow_status'];
    notifactionToken = json['notifaction_token'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['profile_img'] = this.profileImg;
    data['experience'] = this.experience;
    data['rating'] = this.rating;
    data['languaage'] = this.languaage;
    data['specialization'] = this.specialization;
    data['before_chat_discount_price'] = this.beforeChatDiscountPrice;
    data['chat_charges_per_min'] = this.chatChargesPerMin;
    data['chat_coupon_code'] = this.chatCouponCode;
    data['chat_discount_status'] = this.chatDiscountStatus;
    data['before_call_charges_per_min'] = this.beforeCallChargesPerMin;
    data['call_charges_per_min'] = this.callChargesPerMin;
    data['call_coupon_code'] = this.callCouponCode;
    data['call_discount_status'] = this.callDiscountStatus;
    data['call_discount_status_type'] = this.callDiscountStatusType;
    data['befor_video_charges_per_min'] = this.beforVideoChargesPerMin;
    data['video_charges_per_min'] = this.videoChargesPerMin;
    data['video_coupon_code'] = this.videoCouponCode;
    data['video_discount_status'] = this.videoDiscountStatus;
    data['is_online'] = this.isOnline;
    data['follow_status'] = this.followStatus;
    data['notifaction_token'] = this.notifactionToken;
    return data;
  }
}
