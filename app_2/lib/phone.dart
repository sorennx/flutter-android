class Phone {
  final int id;
  final String producent;
  final String model;
  final String osVersion;
  final String website;

  const Phone(
      {required this.id,
      required this.producent,
      required this.model,
      required this.osVersion,
      required this.website});
  
  Map<String, dynamic> toMap(){
    return {
      'id' : id,
      'producent': producent,
      'model' : model,
      'os_version': osVersion,
      'website': website
    };
  }

  @override
  String toString() {
    return 'Phone(id: $id, producent: $producent, model: $model, os_version: $osVersion, website: $website)';
  }
}
