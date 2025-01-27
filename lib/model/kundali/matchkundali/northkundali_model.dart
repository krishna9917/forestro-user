class NorthModel {
  NorthModel({
    this.status,
    this.response,
  });

  final dynamic status;
  final Response? response;

  factory NorthModel.fromJson(Map<String, dynamic> json) {
    return NorthModel(
      status: json["status"],
      response:
          json["response"] == null ? null : Response.fromJson(json["response"]),
    );
  }
}

class Response {
  Response({
    required this.tara,
    required this.gana,
    required this.yoni,
    required this.bhakoot,
    required this.grahamaitri,
    required this.vasya,
    required this.nadi,
    required this.varna,
    required this.score,
    required this.botResponse,
    required this.boyPlanetaryDetails,
    required this.girlPlanetaryDetails,
    required this.boyAstroDetails,
    required this.girlAstroDetails,
  });

  final Tara? tara;
  final Gana? gana;
  final Yoni? yoni;
  final Bhakoot? bhakoot;
  final Grahamaitri? grahamaitri;
  final Vasya? vasya;
  final Nadi? nadi;
  final Varna? varna;
  final dynamic? score;
  final String? botResponse;
  final Map<String, PlanetaryDetail> boyPlanetaryDetails;
  final Map<String, PlanetaryDetail> girlPlanetaryDetails;
  final AstroDetails? boyAstroDetails;
  final AstroDetails? girlAstroDetails;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      tara: json["tara"] == null ? null : Tara.fromJson(json["tara"]),
      gana: json["gana"] == null ? null : Gana.fromJson(json["gana"]),
      yoni: json["yoni"] == null ? null : Yoni.fromJson(json["yoni"]),
      bhakoot:
          json["bhakoot"] == null ? null : Bhakoot.fromJson(json["bhakoot"]),
      grahamaitri: json["grahamaitri"] == null
          ? null
          : Grahamaitri.fromJson(json["grahamaitri"]),
      vasya: json["vasya"] == null ? null : Vasya.fromJson(json["vasya"]),
      nadi: json["nadi"] == null ? null : Nadi.fromJson(json["nadi"]),
      varna: json["varna"] == null ? null : Varna.fromJson(json["varna"]),
      score: json["score"] ?? 0, // Default to 0 if null
      botResponse:
          json["bot_response"] ?? '', // Default to empty string if null
      boyPlanetaryDetails:
          (json["boy_planetary_details"] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry<String, PlanetaryDetail>(
                    k, PlanetaryDetail.fromJson(v as Map<String, dynamic>)),
              ) ??
              {},
      girlPlanetaryDetails:
          (json["girl_planetary_details"] as Map<String, dynamic>?)?.map(
                (k, v) => MapEntry<String, PlanetaryDetail>(
                    k, PlanetaryDetail.fromJson(v as Map<String, dynamic>)),
              ) ??
              {},
      boyAstroDetails: json["boy_astro_details"] == null
          ? null
          : AstroDetails.fromJson(json["boy_astro_details"]),
      girlAstroDetails: json["girl_astro_details"] == null
          ? null
          : AstroDetails.fromJson(json["girl_astro_details"]),
    );
  }
}

class Bhakoot {
  Bhakoot({
    required this.boyRasi,
    required this.girlRasi,
    required this.boyRasiName,
    required this.girlRasiName,
    required this.bhakoot,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyRasi;
  final dynamic girlRasi;
  final dynamic boyRasiName;
  final dynamic girlRasiName;
  final dynamic bhakoot;
  final dynamic description;
  final dynamic fullScore;

  factory Bhakoot.fromJson(Map<String, dynamic> json) {
    return Bhakoot(
      boyRasi: json["boy_rasi"],
      girlRasi: json["girl_rasi"],
      boyRasiName: json["boy_rasi_name"],
      girlRasiName: json["girl_rasi_name"],
      bhakoot: json["bhakoot"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class AstroDetails {
  AstroDetails({
    required this.gana,
    required this.yoni,
    required this.vasya,
    required this.nadi,
    required this.varna,
    required this.paya,
    required this.tatva,
    required this.birthDasa,
    required this.currentDasa,
    required this.birthDasaTime,
    required this.currentDasaTime,
    required this.luckyGem,
    required this.luckyNum,
    required this.luckyColors,
    required this.luckyLetters,
    required this.luckyNameStart,
    required this.rasi,
    required this.nakshatra,
    required this.nakshatraPada,
    required this.ascendantSign,
  });

  final dynamic gana;
  final dynamic yoni;
  final dynamic vasya;
  final dynamic nadi;
  final dynamic varna;
  final dynamic paya;
  final dynamic tatva;
  final dynamic birthDasa;
  final dynamic currentDasa;
  final dynamic birthDasaTime;
  final dynamic currentDasaTime;
  final List<dynamic> luckyGem;
  final List<dynamic> luckyNum;
  final List<dynamic> luckyColors;
  final List<dynamic> luckyLetters;
  final List<dynamic> luckyNameStart;
  final dynamic rasi;
  final dynamic nakshatra;
  final dynamic nakshatraPada;
  final dynamic ascendantSign;

  factory AstroDetails.fromJson(Map<String, dynamic> json) {
    return AstroDetails(
      gana: json["gana"],
      yoni: json["yoni"],
      vasya: json["vasya"],
      nadi: json["nadi"],
      varna: json["varna"],
      paya: json["paya"],
      tatva: json["tatva"],
      birthDasa: json["birth_dasa"],
      currentDasa: json["current_dasa"],
      birthDasaTime: json["birth_dasa_time"],
      currentDasaTime: json["current_dasa_time"],
      luckyGem: json["lucky_gem"] == null
          ? []
          : List<String>.from(json["lucky_gem"]!.map((x) => x)),
      luckyNum: json["lucky_num"] == null
          ? []
          : List<int>.from(json["lucky_num"]!.map((x) => x)),
      luckyColors: json["lucky_colors"] == null
          ? []
          : List<String>.from(json["lucky_colors"]!.map((x) => x)),
      luckyLetters: json["lucky_letters"] == null
          ? []
          : List<String>.from(json["lucky_letters"]!.map((x) => x)),
      luckyNameStart: json["lucky_name_start"] == null
          ? []
          : List<String>.from(json["lucky_name_start"]!.map((x) => x)),
      rasi: json["rasi"],
      nakshatra: json["nakshatra"],
      nakshatraPada: json["nakshatra_pada"],
      ascendantSign: json["ascendant_sign"],
    );
  }
}

class PlanetaryDetail {
  PlanetaryDetail({
    required this.name,
    required this.fullName,
    required this.localDegree,
    required this.globalDegree,
    required this.rasiNo,
    required this.zodiac,
    required this.house,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.nakshatraPada,
    required this.nakshatraNo,
    required this.zodiacLord,
    required this.retro,
  });

  final dynamic name;
  final dynamic fullName;
  final dynamic localDegree;
  final dynamic globalDegree;
  final dynamic rasiNo;
  final dynamic zodiac;
  final dynamic house;
  final dynamic nakshatra;
  final dynamic nakshatraLord;
  final dynamic nakshatraPada;
  final dynamic nakshatraNo;
  final dynamic zodiacLord;
  final dynamic retro;

  factory PlanetaryDetail.fromJson(Map<String, dynamic> json) {
    return PlanetaryDetail(
      name: json["name"],
      fullName: json["full_name"],
      localDegree: json["local_degree"],
      globalDegree: json["global_degree"],
      rasiNo: json["rasi_no"],
      zodiac: json["zodiac"],
      house: json["house"],
      nakshatra: json["nakshatra"],
      nakshatraLord: json["nakshatra_lord"],
      nakshatraPada: json["nakshatra_pada"],
      nakshatraNo: json["nakshatra_no"],
      zodiacLord: json["zodiac_lord"],
      retro: json["retro"],
    );
  }
}

class Gana {
  Gana({
    required this.boyGana,
    required this.girlGana,
    required this.gana,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyGana;
  final dynamic girlGana;
  final dynamic gana;
  final dynamic description;
  final dynamic fullScore;

  factory Gana.fromJson(Map<String, dynamic> json) {
    return Gana(
      boyGana: json["boy_gana"],
      girlGana: json["girl_gana"],
      gana: json["gana"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class Grahamaitri {
  Grahamaitri({
    required this.boyLord,
    required this.girlLord,
    required this.grahamaitri,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyLord;
  final dynamic girlLord;
  final dynamic grahamaitri;
  final dynamic description;
  final dynamic fullScore;

  factory Grahamaitri.fromJson(Map<String, dynamic> json) {
    return Grahamaitri(
      boyLord: json["boy_lord"],
      girlLord: json["girl_lord"],
      grahamaitri: json["grahamaitri"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class Nadi {
  Nadi({
    required this.boyNadi,
    required this.girlNadi,
    required this.nadi,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyNadi;
  final dynamic girlNadi;
  final dynamic nadi;
  final dynamic description;
  final dynamic fullScore;

  factory Nadi.fromJson(Map<String, dynamic> json) {
    return Nadi(
      boyNadi: json["boy_nadi"],
      girlNadi: json["girl_nadi"],
      nadi: json["nadi"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class Tara {
  Tara({
    required this.boyTara,
    required this.girlTara,
    required this.tara,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyTara;
  final dynamic girlTara;
  final dynamic tara;
  final dynamic description;
  final dynamic fullScore;

  factory Tara.fromJson(Map<String, dynamic> json) {
    return Tara(
      boyTara: json["boy_tara"],
      girlTara: json["girl_tara"],
      tara: json["tara"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class Varna {
  Varna({
    required this.boyVarna,
    required this.girlVarna,
    required this.varna,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyVarna;
  final dynamic girlVarna;
  final dynamic varna;
  final dynamic description;
  final dynamic fullScore;

  factory Varna.fromJson(Map<String, dynamic> json) {
    return Varna(
      boyVarna: json["boy_varna"],
      girlVarna: json["girl_varna"],
      varna: json["varna"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class Vasya {
  Vasya({
    required this.boyVasya,
    required this.girlVasya,
    required this.vasya,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyVasya;
  final dynamic girlVasya;
  final dynamic vasya;
  final dynamic description;
  final dynamic fullScore;

  factory Vasya.fromJson(Map<String, dynamic> json) {
    return Vasya(
      boyVasya: json["boy_vasya"],
      girlVasya: json["girl_vasya"],
      vasya: json["vasya"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}

class Yoni {
  Yoni({
    required this.boyYoni,
    required this.girlYoni,
    required this.yoni,
    required this.description,
    required this.fullScore,
  });

  final dynamic boyYoni;
  final dynamic girlYoni;
  final dynamic yoni;
  final dynamic description;
  final dynamic fullScore;

  factory Yoni.fromJson(Map<String, dynamic> json) {
    return Yoni(
      boyYoni: json["boy_yoni"],
      girlYoni: json["girl_yoni"],
      yoni: json["yoni"],
      description: json["description"],
      fullScore: json["full_score"],
    );
  }
}
