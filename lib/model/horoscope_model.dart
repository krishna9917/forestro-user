class HoroscopeModel {
  int? status;
  Response? response;

  HoroscopeModel({this.status, this.response});

  factory HoroscopeModel.fromJson(Map<String, dynamic> json) {
    return HoroscopeModel(
      status: json['status'],
      response:
          json['response'] != null ? Response.fromJson(json['response']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = response!.toJson();
    }
    return data;
  }
}

class Response {
  int? totalScore;
  String? luckyColor;
  String? luckyColorCode;
  List<int>? luckyNumber;
  int? physique;
  int? status;
  int? finances;
  int? relationship;
  int? career;
  int? travel;
  int? family;
  int? friends;
  int? health;
  String? botResponse;
  String? zodiac;

  Response(
      {this.totalScore,
      this.luckyColor,
      this.luckyColorCode,
      this.luckyNumber,
      this.physique,
      this.status,
      this.finances,
      this.relationship,
      this.career,
      this.travel,
      this.family,
      this.friends,
      this.health,
      this.botResponse,
      this.zodiac});

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      totalScore: json['total_score'],
      luckyColor: json['lucky_color'],
      luckyColorCode: json['lucky_color_code'],
      luckyNumber: json['lucky_number'].cast<int>(),
      physique: json['physique'],
      status: json['status'],
      finances: json['finances'],
      relationship: json['relationship'],
      career: json['career'],
      travel: json['travel'],
      family: json['family'],
      friends: json['friends'],
      health: json['health'],
      botResponse: json['bot_response'],
      zodiac: json['zodiac'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['total_score'] = totalScore;
    data['lucky_color'] = luckyColor;
    data['lucky_color_code'] = luckyColorCode;
    data['lucky_number'] = luckyNumber;
    data['physique'] = physique;
    data['status'] = status;
    data['finances'] = finances;
    data['relationship'] = relationship;
    data['career'] = career;
    data['travel'] = travel;
    data['family'] = family;
    data['friends'] = friends;
    data['health'] = health;
    data['bot_response'] = botResponse;
    data['zodiac'] = zodiac;
    return data;
  }
}
