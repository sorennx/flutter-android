class Phone {
  final int? id;
  final String producent;
  final String model;
  final String osVersion;
  final String website;

  const Phone(
      {this.id,
      required this.producent,
      required this.model,
      required this.osVersion,
      required this.website});

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'producent': producent,
      'model': model,
      'os_version': osVersion,
      'website': website
    };
  }

  factory Phone.fromMap(Map<String, dynamic> json) => Phone(
      id: json['id'],
      producent: json['producent'],
      model: json['model'],
      osVersion: json['os_version'],
      website: json['website']);

  @override
  String toString() {
    return 'Phone(id: $id, producent: $producent, model: $model, os_version: $osVersion, website: $website)';
  }
}
