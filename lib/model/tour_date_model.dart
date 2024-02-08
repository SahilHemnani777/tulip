
class TourPlanItem {
  String? id;
  DateTime? date;
  bool isHoliday;
  String? holidayDescription;
  bool isLeave;
  bool isWeekoff;
  List<TourPlanDummy>? tourPlan;

  TourPlanItem({
    this.id,
    this.date,
    required this.isHoliday,
    this.holidayDescription,
    required this.isLeave,
    required this.isWeekoff,
    this.tourPlan,
  });

  factory TourPlanItem.fromJson(Map<String, dynamic> json) => TourPlanItem(
      id: json["id"],
      date: json["date"] == null ? null : DateTime.parse(json["date"]),
      isHoliday: json["is_holiday"],
      holidayDescription: json["holiday_description"],
      isLeave: json["is_leave"],
      isWeekoff: json["is_weekoff"],
      tourPlan: json["tour_plan"] == null ? [] : List<TourPlanDummy>.from(json["tour_plan"]!.map((x) => TourPlanDummy.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
  "id": id,
  "date": date?.toIso8601String(),
  "is_holiday": isHoliday,
  "holiday_description": holidayDescription,
  "is_leave": isLeave,
  "is_weekoff": isWeekoff,
  "tour_plan": tourPlan == null ? [] : List<dynamic>.from(tourPlan!.map((x) => x.toJson())),
};
}

class TourPlanDummy {
  String? id;
  String? tourPlanId;
  String? note;
  String? status;

  TourPlanDummy({
    this.id,
    this.tourPlanId,
    this.note,
    this.status,
  });

  factory TourPlanDummy.fromJson(Map<String, dynamic> json) => TourPlanDummy(
    id: json["_id"],
    tourPlanId: json["tourPlanId"],
    status: json["status"],
    // isDeviation: json["isDeviation"],
    note: json["note"],
  );

  Map<String, dynamic> toJson() => {
    "_id": id,
    "tourPlanId": tourPlanId,
    "note": note,
    "status": status,
  };

  Map<String, dynamic> toKeyJson() => {
    "tourPlanVisitId": null,
    "tourPlanId": tourPlanId,
    "note": note,
    "status": status,
  };

}


