class Kp_Planet_Model {
  Kp_Planet_Model({
    this.status,
    this.response,
  });

  final int? status;
  final Response? response;

  factory Kp_Planet_Model.fromJson(Map<String, dynamic> json) {
    return Kp_Planet_Model(
      status: json["status"],
      response:
          json["response"] == null ? null : Response.fromJson(json["response"]),
    );
  }
}

class Response {
  Response({
    required this.the0,
    required this.the1,
    required this.the2,
    required this.the3,
    required this.the4,
    required this.the5,
    required this.the6,
    required this.the7,
    required this.the8,
    required this.the9,
    required this.midheaven,
    required this.ascendant,
  });

  final The0? the0;
  final The0? the1;
  final The0? the2;
  final The0? the3;
  final The0? the4;
  final The0? the5;
  final The0? the6;
  final The0? the7;
  final The0? the8;
  final The0? the9;
  final double? midheaven;
  final double? ascendant;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      the0: json["0"] == null ? null : The0.fromJson(json["0"]),
      the1: json["1"] == null ? null : The0.fromJson(json["1"]),
      the2: json["2"] == null ? null : The0.fromJson(json["2"]),
      the3: json["3"] == null ? null : The0.fromJson(json["3"]),
      the4: json["4"] == null ? null : The0.fromJson(json["4"]),
      the5: json["5"] == null ? null : The0.fromJson(json["5"]),
      the6: json["6"] == null ? null : The0.fromJson(json["6"]),
      the7: json["7"] == null ? null : The0.fromJson(json["7"]),
      the8: json["8"] == null ? null : The0.fromJson(json["8"]),
      the9: json["9"] == null ? null : The0.fromJson(json["9"]),
      midheaven: json["midheaven"],
      ascendant: json["ascendant"],
    );
  }
}

class The0 {
  The0({
    required this.rasiNo,
    required this.zodiac,
    required this.retro,
    required this.name,
    required this.house,
    required this.globalDegree,
    required this.localDegree,
    required this.pseudoRasiNo,
    required this.pseudoRasi,
    required this.pseudoRasiLord,
    required this.pseudoNakshatra,
    required this.pseudoNakshatraNo,
    required this.pseudoNakshatraPada,
    required this.pseudoNakshatraLord,
    required this.subLord,
    required this.subSubLord,
    required this.fullName,
  });

  final int? rasiNo;
  final String? zodiac;
  final bool? retro;
  final String? name;
  final int? house;
  final double? globalDegree;
  final double? localDegree;
  final int? pseudoRasiNo;
  final String? pseudoRasi;
  final String? pseudoRasiLord;
  final String? pseudoNakshatra;
  final int? pseudoNakshatraNo;
  final int? pseudoNakshatraPada;
  final String? pseudoNakshatraLord;
  final String? subLord;
  final String? subSubLord;
  final String? fullName;

  factory The0.fromJson(Map<String, dynamic> json) {
    return The0(
      rasiNo: json["rasi_no"],
      zodiac: json["zodiac"],
      retro: json["retro"],
      name: json["name"],
      house: json["house"],
      globalDegree: json["global_degree"],
      localDegree: json["local_degree"],
      pseudoRasiNo: json["pseudo_rasi_no"],
      pseudoRasi: json["pseudo_rasi"],
      pseudoRasiLord: json["pseudo_rasi_lord"],
      pseudoNakshatra: json["pseudo_nakshatra"],
      pseudoNakshatraNo: json["pseudo_nakshatra_no"],
      pseudoNakshatraPada: json["pseudo_nakshatra_pada"],
      pseudoNakshatraLord: json["pseudo_nakshatra_lord"],
      subLord: json["sub_lord"],
      subSubLord: json["sub_sub_lord"],
      fullName: json["full_name"],
    );
  }
}
