class VcInfoJson {
  VcInfoJson({
    required this.code,
    required this.msg,
    required this.data,
  });

  final int? code;
  final String? msg;
  final List<VcInfoData> data;

  VcInfoJson copyWith({
    int? code,
    String? msg,
    List<VcInfoData>? data,
  }) {
    return VcInfoJson(
      code: code ?? this.code,
      msg: msg ?? this.msg,
      data: data ?? this.data,
    );
  }

  factory VcInfoJson.fromJson(Map<String, dynamic> json) {
    return VcInfoJson(
      code: json["code"],
      msg: json["msg"],
      data: json["data"] == null
          ? []
          : List<VcInfoData>.from(
              json["data"]!.map((x) => VcInfoData.fromJson(x))),
    );
  }

  Map<String, dynamic> toJson() => {
        "code": code,
        "msg": msg,
        "data": data.map((x) => x.toJson()).toList(),
      };

  @override
  String toString() {
    return "$code, $msg, $data, ";
  }
}

class VcInfoData {
  VcInfoData({
    required this.bestWayToGetInTouch,
    required this.vcAvatar,
    required this.vcHref,
    required this.detail,
    required this.location,
    required this.checkSizeRanges,
    required this.roundsTheyInvestIn,
    required this.roundsTheyLead,
    required this.sectorsTheyInvestIn,
    required this.geographiesTheyInvestIn,
    required this.unicornInvestments,
    required this.top3Verticals,
    required this.vcFileName,
    required this.ventureCapitalName,
    required this.description,
    required this.website,
    required this.twitter,
    required this.linkedin,
    required this.crunchbase,
    required this.fullSheetLink,
    required this.id,
  });

  final String? bestWayToGetInTouch;
  final String? vcAvatar;
  final String? vcHref;
  final String? detail;
  final String? location;
  final String? checkSizeRanges;
  final String? roundsTheyInvestIn;
  final String? roundsTheyLead;
  final String? sectorsTheyInvestIn;
  final String? geographiesTheyInvestIn;
  final String? unicornInvestments;
  final String? top3Verticals;
  final String? vcFileName;
  final String? ventureCapitalName;
  final String? description;
  final String? website;
  final String? twitter;
  final String? linkedin;
  final String? crunchbase;
  final String? fullSheetLink;
  final int? id;

  VcInfoData copyWith({
    String? bestWayToGetInTouch,
    String? vcAvatar,
    String? vcHref,
    String? detail,
    String? location,
    String? checkSizeRanges,
    String? roundsTheyInvestIn,
    String? roundsTheyLead,
    String? sectorsTheyInvestIn,
    String? geographiesTheyInvestIn,
    String? unicornInvestments,
    String? top3Verticals,
    String? vcFileName,
    String? ventureCapitalName,
    String? description,
    String? website,
    String? twitter,
    String? linkedin,
    String? crunchbase,
    String? fullSheetLink,
    int? id,
  }) {
    return VcInfoData(
      bestWayToGetInTouch: bestWayToGetInTouch ?? this.bestWayToGetInTouch,
      vcAvatar: vcAvatar ?? this.vcAvatar,
      vcHref: vcHref ?? this.vcHref,
      detail: detail ?? this.detail,
      location: location ?? this.location,
      checkSizeRanges: checkSizeRanges ?? this.checkSizeRanges,
      roundsTheyInvestIn: roundsTheyInvestIn ?? this.roundsTheyInvestIn,
      roundsTheyLead: roundsTheyLead ?? this.roundsTheyLead,
      sectorsTheyInvestIn: sectorsTheyInvestIn ?? this.sectorsTheyInvestIn,
      geographiesTheyInvestIn:
          geographiesTheyInvestIn ?? this.geographiesTheyInvestIn,
      unicornInvestments: unicornInvestments ?? this.unicornInvestments,
      top3Verticals: top3Verticals ?? this.top3Verticals,
      vcFileName: vcFileName ?? this.vcFileName,
      ventureCapitalName: ventureCapitalName ?? this.ventureCapitalName,
      description: description ?? this.description,
      website: website ?? this.website,
      twitter: twitter ?? this.twitter,
      linkedin: linkedin ?? this.linkedin,
      crunchbase: crunchbase ?? this.crunchbase,
      fullSheetLink: fullSheetLink ?? this.fullSheetLink,
      id: id ?? this.id,
    );
  }

  factory VcInfoData.fromJson(Map<String, dynamic> json) {
    return VcInfoData(
      bestWayToGetInTouch: json["best_way_to_get_in_touch"],
      vcAvatar: json["vc_avatar"],
      vcHref: json["vc_href"],
      detail: json["detail"],
      location: json["location"],
      checkSizeRanges: json["check_size_ranges"],
      roundsTheyInvestIn: json["rounds_they_invest_in"],
      roundsTheyLead: json["rounds_they_lead"],
      sectorsTheyInvestIn: json["sectors_they_invest_in"],
      geographiesTheyInvestIn: json["geographies_they_invest_in"],
      unicornInvestments: json["unicorn_investments"],
      top3Verticals: json["top_3_verticals"],
      vcFileName: json["vc_file_name"],
      ventureCapitalName: json["venture_capital_name"],
      description: json["description"],
      website: json["website"],
      twitter: json["twitter"],
      linkedin: json["linkedin"],
      crunchbase: json["crunchbase"],
      fullSheetLink: json["full_sheet_link"],
      id: json["id"],
    );
  }

  Map<String, dynamic> toJson() => {
        "best_way_to_get_in_touch": bestWayToGetInTouch,
        "vc_avatar": vcAvatar,
        "vc_href": vcHref,
        "detail": detail,
        "location": location,
        "check_size_ranges": checkSizeRanges,
        "rounds_they_invest_in": roundsTheyInvestIn,
        "rounds_they_lead": roundsTheyLead,
        "sectors_they_invest_in": sectorsTheyInvestIn,
        "geographies_they_invest_in": geographiesTheyInvestIn,
        "unicorn_investments": unicornInvestments,
        "top_3_verticals": top3Verticals,
        "vc_file_name": vcFileName,
        "venture_capital_name": ventureCapitalName,
        "description": description,
        "website": website,
        "twitter": twitter,
        "linkedin": linkedin,
        "crunchbase": crunchbase,
        "full_sheet_link": fullSheetLink,
        "id": id,
      };

  @override
  String toString() {
    return "$bestWayToGetInTouch, $vcAvatar, $vcHref, $detail, $location, $checkSizeRanges, $roundsTheyInvestIn, $roundsTheyLead, $sectorsTheyInvestIn, $geographiesTheyInvestIn, $unicornInvestments, $top3Verticals, $vcFileName, $ventureCapitalName, $description, $website, $twitter, $linkedin, $crunchbase, $fullSheetLink, $id, ";
  }
}
