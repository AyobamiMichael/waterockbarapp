import 'dart:convert';

Address addressFromJson(String str) => Address.fromJson(json.decode(str));

String addressToJson(Address data) => json.encode(data);

class Address {
  final List<dynamic> destination_addresses;
  final List<dynamic> origin_addresses;
  final List<dynamic> rows;
  final String status;

  Address(
      {required this.destination_addresses,
      required this.origin_addresses,
      required this.rows,
      required this.status});

  factory Address.fromJson(Map<String, dynamic> parsedJson) {
    var destinationAddressesfromjson = parsedJson['destination_addresses'];
    var originAddressesfromjson = parsedJson['origin_addresses'];
    //  var rowsFromJson = parsedJson['rows'];

    List<String> destinationAddresseslist =
        destinationAddressesfromjson.cast<String>();

    List<String> originAddresseslist = originAddressesfromjson.cast<String>();

    //List<String> rowsList = rowsFromJson.cast<String>();

    return Address(
        destination_addresses: parsedJson['destination_addresses'],
        origin_addresses: parsedJson['origin_addresses'],
        rows: parsedJson['rows'],
        status: parsedJson['status']);
  }
}

class Row {
  final List<Element> elements;
  Row({required this.elements});

  factory Row.fromJson(Map<String, dynamic> parsedJson) {
    return Row(elements: parsedJson['elements']);
  }
}

class Element {
  Distance distance;
  Duration duration;

  Element({required this.distance, required this.duration});
  factory Element.fromJson(Map<String, dynamic> parsedJson) {
    return Element(
        distance: parsedJson['distance'], duration: parsedJson['duration']);
  }
}

class Distance {
  final String text;
  final String value;

  Distance({required this.text, required this.value});

  factory Distance.fromJson(Map<String, dynamic> parsedJson) {
    return Distance(text: parsedJson['text'], value: parsedJson['value']);
  }
}

class Duration {
  final String text;
  final String value;

  Duration({required this.text, required this.value});

  factory Duration.fromJson(Map<String, dynamic> parsedJson) {
    return Duration(text: parsedJson['text'], value: parsedJson['value']);
  }
}
