class PlanetModel {
  dynamic status;
  Response response;

  PlanetModel({required this.status, required this.response});

  factory PlanetModel.fromJson(Map<String, dynamic> json) {
    return PlanetModel(
      status: json['status'],
      response: Response.fromJson(json['response']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'status': status,
      'response': response.toJson(),
    };
  }
}

class Response {
  Map<dynamic, Planet> planets;
  dynamic birthDasa;
  dynamic currentDasa;
  dynamic birthDasaTime;
  dynamic currentDasaTime;
  List<dynamic> luckyGem;
  List<dynamic> luckyNum;
  List<dynamic> luckyColors;
  List<dynamic> luckyLetters;
  List<dynamic> luckyNameStart;
  dynamic rasi;
  dynamic nakshatra;
  dynamic nakshatraPada;
  Panchang panchang;
  GhatkaChakra ghatkaChakra;

  Response({
    required this.planets,
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
    required this.panchang,
    required this.ghatkaChakra,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    var planets = <int, Planet>{};
    json.forEach((key, value) {
      if (int.tryParse(key) != null) {
        planets[int.parse(key)] = Planet.fromJson(value);
      }
    });
    return Response(
      planets: planets,
      birthDasa: json['birth_dasa'],
      currentDasa: json['current_dasa'],
      birthDasaTime: json['birth_dasa_time'],
      currentDasaTime: json['current_dasa_time'],
      luckyGem: List<String>.from(json['lucky_gem']),
      luckyNum: List<int>.from(json['lucky_num']),
      luckyColors: List<String>.from(json['lucky_colors']),
      luckyLetters: List<String>.from(json['lucky_letters']),
      luckyNameStart: List<String>.from(json['lucky_name_start']),
      rasi: json['rasi'],
      nakshatra: json['nakshatra'],
      nakshatraPada: json['nakshatra_pada'],
      panchang: Panchang.fromJson(json['panchang']),
      ghatkaChakra: GhatkaChakra.fromJson(json['ghatka_chakra']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      ...planets.map((key, value) => MapEntry(key.toString(), value.toJson())),
      'birth_dasa': birthDasa,
      'current_dasa': currentDasa,
      'birth_dasa_time': birthDasaTime,
      'current_dasa_time': currentDasaTime,
      'lucky_gem': luckyGem,
      'lucky_num': luckyNum,
      'lucky_colors': luckyColors,
      'lucky_letters': luckyLetters,
      'lucky_name_start': luckyNameStart,
      'rasi': rasi,
      'nakshatra': nakshatra,
      'nakshatra_pada': nakshatraPada,
      'panchang': panchang.toJson(),
      'ghatka_chakra': ghatkaChakra.toJson(),
    };
  }
}

class Planet {
  dynamic name;
  dynamic fullName;
  dynamic localDegree;
  dynamic globalDegree;
  dynamic rasiNo;
  dynamic zodiac;
  dynamic house;
  dynamic nakshatra;
  dynamic nakshatraLord;
  dynamic nakshatraPada;
  dynamic nakshatraNo;
  dynamic zodiacLord;
  dynamic? isPlanetSet;
  dynamic basicAvastha;
  dynamic lordStatus;
  dynamic? isCombust;
  dynamic retro;
  dynamic speedRadiansPerDay;

  Planet({
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
    this.isPlanetSet,
    required this.basicAvastha,
    required this.lordStatus,
    this.isCombust,
    this.retro,
    required this.speedRadiansPerDay,
  });

  factory Planet.fromJson(Map<String, dynamic> json) {
    return Planet(
      name: json['name'],
      fullName: json['full_name'],
      localDegree: json['local_degree']?.toDouble() ?? 0.0,
      globalDegree: json['global_degree']?.toDouble() ?? 0.0,
      rasiNo: json['rasi_no'],
      zodiac: json['zodiac'],
      house: json['house'],
      nakshatra: json['nakshatra'],
      nakshatraLord: json['nakshatra_lord'],
      nakshatraPada: json['nakshatra_pada'],
      nakshatraNo: json['nakshatra_no'],
      zodiacLord: json['zodiac_lord'],
      isPlanetSet: json['is_planet_set'] ?? false,
      basicAvastha: json['basic_avastha'],
      lordStatus: json['lord_status'],
      isCombust: json['is_combust'] ?? false,
      retro: json['retro'] ?? false,
      speedRadiansPerDay: json['speed_radians_per_day'] ??
          0.0, // assign 0.0 if 'speed_radians_per_day' is null
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'full_name': fullName,
      'local_degree': localDegree,
      'global_degree': globalDegree,
      'rasi_no': rasiNo,
      'zodiac': zodiac,
      'house': house,
      'nakshatra': nakshatra,
      'nakshatra_lord': nakshatraLord,
      'nakshatra_pada': nakshatraPada,
      'nakshatra_no': nakshatraNo,
      'zodiac_lord': zodiacLord,
      'is_planet_set': isPlanetSet ?? false,
      'basic_avastha': basicAvastha,
      'lord_status': lordStatus,
      'is_combust': isCombust ?? false,
      'retro': retro ?? false,
      'speed_radians_per_day': speedRadiansPerDay,
    };
  }
}

class Panchang {
  dynamic ayanamsa;
  dynamic ayanamsaName;
  dynamic karana;
  dynamic yoga;
  dynamic dayOfBirth;
  dynamic dayLord;
  dynamic horaLord;
  dynamic sunriseAtBirth;
  dynamic sunsetAtBirth;
  dynamic tithi;

  Panchang({
    required this.ayanamsa,
    required this.ayanamsaName,
    required this.karana,
    required this.yoga,
    required this.dayOfBirth,
    required this.dayLord,
    required this.horaLord,
    required this.sunriseAtBirth,
    required this.sunsetAtBirth,
    required this.tithi,
  });

  factory Panchang.fromJson(Map<String, dynamic> json) {
    return Panchang(
      ayanamsa: json['ayanamsa']?.toDouble() ?? 0.0,
      ayanamsaName: json['ayanamsa_name'],
      karana: json['karana'],
      yoga: json['yoga'],
      dayOfBirth: json['day_of_birth'],
      dayLord: json['day_lord'],
      horaLord: json['hora_lord'],
      sunriseAtBirth: json['sunrise_at_birth'],
      sunsetAtBirth: json['sunset_at_birth'],
      tithi: json['tithi'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ayanamsa': ayanamsa,
      'ayanamsa_name': ayanamsaName,
      'karana': karana,
      'yoga': yoga,
      'day_of_birth': dayOfBirth,
      'day_lord': dayLord,
      'hora_lord': horaLord,
      'sunrise_at_birth': sunriseAtBirth,
      'sunset_at_birth': sunsetAtBirth,
      'tithi': tithi,
    };
  }
}

class GhatkaChakra {
  dynamic rasi;
  List<dynamic> tithi;
  dynamic day;
  dynamic nakshatra;
  dynamic tatva;
  dynamic lord;
  dynamic sameSexLagna;
  dynamic oppositeSexLagna;

  GhatkaChakra({
    required this.rasi,
    required this.tithi,
    required this.day,
    required this.nakshatra,
    required this.tatva,
    required this.lord,
    required this.sameSexLagna,
    required this.oppositeSexLagna,
  });

  factory GhatkaChakra.fromJson(Map<String, dynamic> json) {
    return GhatkaChakra(
      rasi: json['rasi'],
      tithi: List<String>.from(json['tithi']),
      day: json['day'],
      nakshatra: json['nakshatra'],
      tatva: json['tatva'],
      lord: json['lord'],
      sameSexLagna: json['same_sex_lagna'],
      oppositeSexLagna: json['opposite_sex_lagna'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'rasi': rasi,
      'tithi': tithi,
      'day': day,
      'nakshatra': nakshatra,
      'tatva': tatva,
      'lord': lord,
      'same_sex_lagna': sameSexLagna,
      'opposite_sex_lagna': oppositeSexLagna,
    };
  }
}
