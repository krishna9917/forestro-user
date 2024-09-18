class SouthKundaliModel {
  SouthKundaliModel({
    this.status,
    this.response,
  });

  final dynamic status;
  final Response? response;

  factory SouthKundaliModel.fromJson(Map<String, dynamic> json) {
    return SouthKundaliModel(
      status: json["status"],
      response:
          json["response"] == null ? null : Response.fromJson(json["response"]),
    );
  }
}

class Response {
  Response({
    required this.dina,
    required this.gana,
    required this.mahendra,
    required this.sthree,
    required this.yoni,
    required this.rasi,
    required this.rasiathi,
    required this.vasya,
    required this.rajju,
    required this.vedha,
    required this.score,
    required this.botResponse,
    required this.boyPlanetaryDetails,
    required this.girlPlanetaryDetails,
    required this.boyAstroDetails,
    required this.girlAstroDetails,
  });

  final Dina? dina;
  final Gana? gana;
  final Dina? mahendra;
  final Dina? sthree;
  final Yoni? yoni;
  final Rasi? rasi;
  final Rasiathi? rasiathi;
  final Rasi? vasya;
  final Rajju? rajju;
  final Dina? vedha;
  final int? score;
  final String? botResponse;
  final Map<String, PlanetarySouthDetail> boyPlanetaryDetails;
  final Map<String, PlanetarySouthDetail> girlPlanetaryDetails;
  final AstroSouthDetails? boyAstroDetails;
  final AstroSouthDetails? girlAstroDetails;

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      dina: json["dina"] == null ? null : Dina.fromJson(json["dina"]),
      gana: json["gana"] == null ? null : Gana.fromJson(json["gana"]),
      mahendra:
          json["mahendra"] == null ? null : Dina.fromJson(json["mahendra"]),
      sthree: json["sthree"] == null ? null : Dina.fromJson(json["sthree"]),
      yoni: json["yoni"] == null ? null : Yoni.fromJson(json["yoni"]),
      rasi: json["rasi"] == null ? null : Rasi.fromJson(json["rasi"]),
      rasiathi:
          json["rasiathi"] == null ? null : Rasiathi.fromJson(json["rasiathi"]),
      vasya: json["vasya"] == null ? null : Rasi.fromJson(json["vasya"]),
      rajju: json["rajju"] == null ? null : Rajju.fromJson(json["rajju"]),
      vedha: json["vedha"] == null ? null : Dina.fromJson(json["vedha"]),
      score: json["score"],
      botResponse: json["bot_response"],
      boyPlanetaryDetails: Map.from(json["boy_planetary_details"]).map((k, v) =>
          MapEntry<String, PlanetarySouthDetail>(
              k, PlanetarySouthDetail.fromJson(v))),
      girlPlanetaryDetails: Map.from(json["girl_planetary_details"]).map(
          (k, v) => MapEntry<String, PlanetarySouthDetail>(
              k, PlanetarySouthDetail.fromJson(v))),
      boyAstroDetails: json["boy_astro_details"] == null
          ? null
          : AstroSouthDetails.fromJson(json["boy_astro_details"]),
      girlAstroDetails: json["girl_astro_details"] == null
          ? null
          : AstroSouthDetails.fromJson(json["girl_astro_details"]),
    );
  }
}

class AstroSouthDetails {
  AstroSouthDetails({
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

  factory AstroSouthDetails.fromJson(Map<String, dynamic> json) {
    return AstroSouthDetails(
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

class PlanetarySouthDetail {
  PlanetarySouthDetail({
    required this.name,
    required this.fullName,
    required this.localDegree,
    required this.globalDegree,
    required this.progressInPercentage,
    required this.rasiNo,
    required this.zodiac,
    required this.house,
    required this.nakshatra,
    required this.nakshatraLord,
    required this.nakshatraPada,
    required this.nakshatraNo,
    required this.zodiacLord,
    required this.isPlanetSet,
    required this.lordStatus,
    required this.basicAvastha,
    required this.isCombust,
    required this.tithiNo,
    required this.speedRadiansPerDay,
    required this.retro,
  });

  final dynamic name;
  final dynamic fullName;
  final dynamic localDegree;
  final dynamic globalDegree;
  final dynamic progressInPercentage;
  final dynamic rasiNo;
  final dynamic zodiac;
  final dynamic house;
  final dynamic nakshatra;
  final dynamic nakshatraLord;
  final dynamic nakshatraPada;
  final dynamic nakshatraNo;
  final dynamic zodiacLord;
  final dynamic isPlanetSet;
  final dynamic lordStatus;
  final dynamic basicAvastha;
  final dynamic isCombust;
  final dynamic tithiNo;
  final dynamic speedRadiansPerDay;
  final dynamic retro;

  factory PlanetarySouthDetail.fromJson(Map<String, dynamic> json) {
    return PlanetarySouthDetail(
      name: json["name"],
      fullName: json["full_name"],
      localDegree: json["local_degree"],
      globalDegree: json["global_degree"],
      progressInPercentage: json["progress_in_percentage"],
      rasiNo: json["rasi_no"],
      zodiac: json["zodiac"],
      house: json["house"],
      nakshatra: json["nakshatra"],
      nakshatraLord: json["nakshatra_lord"],
      nakshatraPada: json["nakshatra_pada"],
      nakshatraNo: json["nakshatra_no"],
      zodiacLord: json["zodiac_lord"],
      isPlanetSet: json["is_planet_set"],
      lordStatus: json["lord_status"],
      basicAvastha: json["basic_avastha"],
      isCombust: json["is_combust"],
      tithiNo: json["tithi_no"],
      speedRadiansPerDay: json["speed_radians_per_day"],
      retro: json["retro"],
    );
  }
}

class Dina {
  Dina({
    required this.boyStar,
    required this.girlStar,
    required this.dina,
    required this.description,
    required this.name,
    required this.fullScore,
    required this.mahendra,
    required this.sthree,
    required this.vedha,
  });

  final dynamic boyStar;
  final dynamic girlStar;
  final dynamic dina;
  final dynamic description;
  final dynamic name;
  final dynamic fullScore;
  final dynamic mahendra;
  final dynamic sthree;
  final dynamic vedha;

  factory Dina.fromJson(Map<String, dynamic> json) {
    return Dina(
      boyStar: json["boy_star"],
      girlStar: json["girl_star"],
      dina: json["dina"],
      description: json["description"],
      name: json["name"],
      fullScore: json["full_score"],
      mahendra: json["mahendra"],
      sthree: json["sthree"],
      vedha: json["vedha"],
    );
  }
}

class Gana {
  Gana({
    required this.boyGana,
    required this.girlGana,
    required this.gana,
    required this.description,
    required this.name,
    required this.fullScore,
  });

  final dynamic boyGana;
  final dynamic girlGana;
  final dynamic gana;
  final dynamic description;
  final dynamic name;
  final dynamic fullScore;

  factory Gana.fromJson(Map<String, dynamic> json) {
    return Gana(
      boyGana: json["boy_gana"],
      girlGana: json["girl_gana"],
      gana: json["gana"],
      description: json["description"],
      name: json["name"],
      fullScore: json["full_score"],
    );
  }
}

class Rajju {
  Rajju({
    required this.boyRajju,
    required this.girlRajju,
    required this.rajju,
    required this.description,
    required this.name,
    required this.fullScore,
  });

  final dynamic boyRajju;
  final dynamic girlRajju;
  final dynamic rajju;
  final dynamic description;
  final dynamic name;
  final dynamic fullScore;

  factory Rajju.fromJson(Map<String, dynamic> json) {
    return Rajju(
      boyRajju: json["boy_rajju"],
      girlRajju: json["girl_rajju"],
      rajju: json["rajju"],
      description: json["description"],
      name: json["name"],
      fullScore: json["full_score"],
    );
  }
}

class Rasi {
  Rasi({
    required this.boyRasi,
    required this.girlRasi,
    required this.rasi,
    required this.description,
    required this.name,
    required this.fullScore,
    required this.vasya,
  });

  final dynamic boyRasi;
  final dynamic girlRasi;
  final dynamic rasi;
  final dynamic description;
  final dynamic name;
  final dynamic fullScore;
  final dynamic vasya;

  factory Rasi.fromJson(Map<String, dynamic> json) {
    return Rasi(
      boyRasi: json["boy_rasi"],
      girlRasi: json["girl_rasi"],
      rasi: json["rasi"],
      description: json["description"],
      name: json["name"],
      fullScore: json["full_score"],
      vasya: json["vasya"],
    );
  }
}

class Rasiathi {
  Rasiathi({
    required this.boyLord,
    required this.girlLord,
    required this.rasiathi,
    required this.description,
    required this.name,
    required this.fullScore,
  });

  final dynamic boyLord;
  final dynamic girlLord;
  final dynamic rasiathi;
  final dynamic description;
  final dynamic name;
  final dynamic fullScore;

  factory Rasiathi.fromJson(Map<String, dynamic> json) {
    return Rasiathi(
      boyLord: json["boy_lord"],
      girlLord: json["girl_lord"],
      rasiathi: json["rasiathi"],
      description: json["description"],
      name: json["name"],
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
    required this.name,
    required this.fullScore,
  });

  final dynamic boyYoni;
  final dynamic girlYoni;
  final dynamic yoni;
  final dynamic description;
  final dynamic name;
  final dynamic fullScore;

  factory Yoni.fromJson(Map<String, dynamic> json) {
    return Yoni(
      boyYoni: json["boy_yoni"],
      girlYoni: json["girl_yoni"],
      yoni: json["yoni"],
      description: json["description"],
      name: json["name"],
      fullScore: json["full_score"],
    );
  }
}
