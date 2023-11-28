class Location {
  final String name;
  final String country;
  final String url;
  final bool hasStation;
  const Location(
      {required this.name,
      required this.country,
      required this.url,
      required this.hasStation});

  static Location fromJson(dynamic json, bool hasStation) => Location(
      name: json['name'],
      country: json['country'],
      url: json['url'],
      hasStation: hasStation);
}
