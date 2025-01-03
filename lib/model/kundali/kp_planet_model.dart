class Kp_Planet_Model {
  dynamic? status;
  List<Response>? response;

  Kp_Planet_Model({this.status, this.response});

  factory Kp_Planet_Model.fromJson(Map<String, dynamic> json) {
    return Kp_Planet_Model(
      status: json['status'],
      response:
          (json['response'] as Map<String, dynamic>?)?.entries.map((entry) {
        // Ensure each entry value is passed as a Map and then add the 'id' key
        final valueMap = Map<String, dynamic>.from(entry.value);
        valueMap['id'] = entry.key;
        return Response.fromJson(valueMap);
      }).toList(),
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['status'] = status;
    if (response != null) {
      data['response'] = {
        for (var responseItem in response!)
          responseItem.id: responseItem.toJson()
      };
    }
    return data;
  }
}

class Response {
  dynamic? id;
  dynamic? rasiNo;
  dynamic? zodiac;
  dynamic? retro;
  dynamic? name;
  dynamic? house;
  dynamic? globalDegree;
  dynamic? localDegree;
  dynamic? pseudoRasiNo;
  dynamic? pseudoRasi;
  dynamic? pseudoRasiLord;
  dynamic? pseudoNakshatra;
  dynamic? pseudoNakshatraNo;
  dynamic? pseudoNakshatraPada;
  dynamic? pseudoNakshatraLord;
  dynamic? subLord;
  dynamic? subSubLord;

  Response({
    this.id,
    this.rasiNo,
    this.zodiac,
    this.retro,
    this.name,
    this.house,
    this.globalDegree,
    this.localDegree,
    this.pseudoRasiNo,
    this.pseudoRasi,
    this.pseudoRasiLord,
    this.pseudoNakshatra,
    this.pseudoNakshatraNo,
    this.pseudoNakshatraPada,
    this.pseudoNakshatraLord,
    this.subLord,
    this.subSubLord,
  });

  factory Response.fromJson(Map<String, dynamic> json) {
    return Response(
      id: json['id'],
      rasiNo: json['rasi_no'],
      zodiac: json['zodiac'],
      retro: json['retro'],
      name: json['name'],
      house: json['house'],
      globalDegree: (json['global_degree'] as num?)?.toDouble(),
      localDegree: (json['local_degree'] as num?)?.toDouble(),
      pseudoRasiNo: json['pseudo_rasi_no'],
      pseudoRasi: json['pseudo_rasi'],
      pseudoRasiLord: json['pseudo_rasi_lord'],
      pseudoNakshatra: json['pseudo_nakshatra'],
      pseudoNakshatraNo: json['pseudo_nakshatra_no'],
      pseudoNakshatraPada: json['pseudo_nakshatra_pada'],
      pseudoNakshatraLord: json['pseudo_nakshatra_lord'],
      subLord: json['sub_lord'],
      subSubLord: json['sub_sub_lord'],
    );
  }

  Map<dynamic, dynamic> toJson() {
    final Map<dynamic, dynamic> data = <dynamic, dynamic>{};
    data['id'] = id;
    data['rasi_no'] = rasiNo;
    data['zodiac'] = zodiac;
    data['retro'] = retro;
    data['name'] = name;
    data['house'] = house;
    data['global_degree'] = globalDegree;
    data['local_degree'] = localDegree;
    data['pseudo_rasi_no'] = pseudoRasiNo;
    data['pseudo_rasi'] = pseudoRasi;
    data['pseudo_rasi_lord'] = pseudoRasiLord;
    data['pseudo_nakshatra'] = pseudoNakshatra;
    data['pseudo_nakshatra_no'] = pseudoNakshatraNo;
    data['pseudo_nakshatra_pada'] = pseudoNakshatraPada;
    data['pseudo_nakshatra_lord'] = pseudoNakshatraLord;
    data['sub_lord'] = subLord;
    data['sub_sub_lord'] = subSubLord;
    return data;
  }
}
