// To parse this JSON data, do
//
//     final welcome = welcomeFromJson(jsonString);

import 'dart:convert';

Welcome welcomeFromJson(String str) => Welcome.fromJson(json.decode(str));

String welcomeToJson(Welcome data) => json.encode(data.toJson());

class Welcome {
  Welcome({
    this.id,
    this.customId,
    this.metaData,
    this.uploadedDatetime,
    this.finishedDatetime,
    this.images,
    this.suggestions,
    this.modifiers,
    this.secret,
    this.failCause,
    this.countable,
    this.feedback,
    this.isPlantProbability,
    this.isPlant,
  });

  int? id;
  dynamic customId;
  MetaData? metaData;
  double? uploadedDatetime;
  double? finishedDatetime;
  List<Image>? images;
  List<Suggestion>? suggestions;
  List<dynamic>? modifiers;
  String? secret;
  dynamic failCause;
  bool? countable;
  dynamic feedback;
  double? isPlantProbability;
  bool? isPlant;

  factory Welcome.fromJson(Map<String, dynamic> json) => Welcome(
        id: json["id"],
        customId: json["custom_id"],
        metaData: json["meta_data"] == null
            ? null
            : MetaData.fromJson(json["meta_data"]),
        uploadedDatetime: json["uploaded_datetime"] == null
            ? null
            : json["uploaded_datetime"].toDouble(),
        finishedDatetime: json["finished_datetime"] == null
            ? null
            : json["finished_datetime"].toDouble(),
        images: json["images"] == null
            ? null
            : List<Image>.from(json["images"].map((x) => Image.fromJson(x))),
        suggestions: json["suggestions"] == null
            ? null
            : List<Suggestion>.from(
                json["suggestions"].map((x) => Suggestion.fromJson(x))),
        modifiers: json["modifiers"] == null
            ? null
            : List<dynamic>.from(json["modifiers"].map((x) => x)),
        secret: json["secret"],
        failCause: json["fail_cause"],
        countable: json["countable"],
        feedback: json["feedback"],
        isPlantProbability: json["is_plant_probability"] == null
            ? null
            : json["is_plant_probability"].toDouble(),
        isPlant: json["is_plant"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "custom_id": customId,
        "meta_data": metaData == null ? null : metaData!.toJson(),
        "uploaded_datetime": uploadedDatetime,
        "finished_datetime": finishedDatetime,
        "images": images == null
            ? null
            : List<dynamic>.from(images!.map((x) => x.toJson())),
        "suggestions": suggestions == null
            ? null
            : List<dynamic>.from(suggestions!.map((x) => x.toJson())),
        "modifiers": modifiers == null
            ? null
            : List<dynamic>.from(modifiers!.map((x) => x)),
        "secret": secret,
        "fail_cause": failCause,
        "countable": countable,
        "feedback": feedback,
        "is_plant_probability": isPlantProbability,
        "is_plant": isPlant,
      };
}

class Image {
  Image({
    this.fileName,
    this.url,
  });

  String? fileName;
  String? url;

  factory Image.fromJson(Map<String, dynamic> json) => Image(
        fileName: json["file_name"],
        url: json["url"],
      );

  Map<String, dynamic> toJson() => {
        "file_name": fileName,
        "url": url,
      };
}

class MetaData {
  MetaData({
    this.latitude,
    this.longitude,
    this.date,
    this.datetime,
  });

  dynamic latitude;
  dynamic longitude;
  DateTime? date;
  DateTime? datetime;

  factory MetaData.fromJson(Map<String, dynamic> json) => MetaData(
        latitude: json["latitude"],
        longitude: json["longitude"],
        date: json["date"] == null ? null : DateTime.parse(json["date"]),
        datetime:
            json["datetime"] == null ? null : DateTime.parse(json["datetime"]),
      );

  Map<String, dynamic> toJson() => {
        "latitude": latitude,
        "longitude": longitude,
        "date": date == null
            ? null
            : "${date!.year.toString().padLeft(4, '0')}-${date!.month.toString().padLeft(2, '0')}-${date!.day.toString().padLeft(2, '0')}",
        "datetime": datetime == null
            ? null
            : "${datetime!.year.toString().padLeft(4, '0')}-${datetime!.month.toString().padLeft(2, '0')}-${datetime!.day.toString().padLeft(2, '0')}",
      };
}

class Taxonomy {
  Taxonomy({
    this.taxonomyClass,
    this.family,
    this.genus,
    this.kingdom,
    this.order,
    this.phylum,
  });

  String? taxonomyClass;
  String? family;
  String? genus;
  String? kingdom;
  String? order;
  String? phylum;

  factory Taxonomy.fromJson(Map<String, dynamic> json) => Taxonomy(
        taxonomyClass: json["class"],
        family: json["family"],
        genus: json["genus"],
        kingdom: json["kingdom"],
        order: json["order"],
        phylum: json["phylum"],
      );

  Map<String, dynamic> toJson() => {
        "class": taxonomyClass,
        "family": family,
        "genus": genus,
        "kingdom": kingdom,
        "order": order,
        "phylum": phylum,
      };
}

class Suggestion {
  Suggestion({
    this.id,
    this.plantName,
    this.plantDetails,
    this.probability,
    this.confirmed,
    this.similarImages,
  });

  int? id;
  String? plantName;
  PlantDetails? plantDetails;
  double? probability;
  bool? confirmed;
  List<SimilarImage>? similarImages;

  factory Suggestion.fromJson(Map<String, dynamic> json) => Suggestion(
        id: json["id"],
        plantName: json["plant_name"],
        plantDetails: json["plant_details"] == null
            ? null
            : PlantDetails.fromJson(json["plant_details"]),
        probability:
            json["probability"] == null ? null : json["probability"].toDouble(),
        confirmed: json["confirmed"],
        similarImages: json["similar_images"] == null
            ? null
            : List<SimilarImage>.from(
                json["similar_images"].map((x) => SimilarImage.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "plant_name": plantName,
        "plant_details": plantDetails == null ? null : plantDetails!.toJson(),
        "probability": probability,
        "confirmed": confirmed,
        "similar_images": similarImages == null
            ? null
            : List<dynamic>.from(similarImages!.map((x) => x.toJson())),
      };
}

class PlantDetails {
  PlantDetails({
    this.commonNames,
    this.url,
    this.wikiDescription,
    this.synonyms,
    this.taxonomy,
    this.language,
    this.scientificName,
    this.structuredName,
  });

  List<String>? commonNames;
  String? url;
  WikiDescription? wikiDescription;
  List<String>? synonyms;
  Taxonomy? taxonomy;
  String? language;
  String? scientificName;
  StructuredName? structuredName;

  factory PlantDetails.fromJson(Map<String, dynamic> json) => PlantDetails(
        commonNames: json["common_names"] == null
            ? null
            : List<String>.from(json["common_names"].map((x) => x)),
        url: json["url"],
        wikiDescription: json["wiki_description"] == null
            ? null
            : WikiDescription.fromJson(json["wiki_description"]),
        synonyms: json["synonyms"] == null
            ? null
            : List<String>.from(json["synonyms"].map((x) => x)),
        taxonomy: json["taxonomy"] == null
            ? null
            : Taxonomy.fromJson(json["taxonomy"]),
        language: json["language"],
        scientificName: json["scientific_name"],
        structuredName: json["structured_name"] == null
            ? null
            : StructuredName.fromJson(json["structured_name"]),
      );

  Map<String, dynamic> toJson() => {
        "common_names": commonNames == null
            ? null
            : List<dynamic>.from(commonNames!.map((x) => x)),
        "url": url,
        "wiki_description":
            wikiDescription == null ? null : wikiDescription?.toJson(),
        "synonyms": synonyms == null
            ? null
            : List<dynamic>.from(synonyms!.map((x) => x)),
        "taxonomy": taxonomy == null ? null : taxonomy!.toJson(),
        "language": language,
        "scientific_name": scientificName,
        "structured_name":
            structuredName == null ? null : structuredName!.toJson(),
      };
}

enum Language { EN }

final languageValues = EnumValues({"en": Language.EN});

class StructuredName {
  StructuredName({
    this.genus,
    this.species,
  });

  String? genus;
  String? species;

  factory StructuredName.fromJson(Map<String, dynamic> json) => StructuredName(
        genus: json["genus"],
        species: json["species"],
      );

  Map<String, dynamic> toJson() => {
        "genus": genus,
        "species": species,
      };
}

class WikiDescription {
  WikiDescription({
    this.value,
    this.citation,
    this.licenseName,
    this.licenseUrl,
  });

  String? value;
  String? citation;
  LicenseName? licenseName;
  String? licenseUrl;

  factory WikiDescription.fromJson(Map<String, dynamic> json) =>
      WikiDescription(
        value: json["value"],
        citation: json["citation"],
        licenseName: json["license_name"] == null
            ? null
            : licenseNameValues.map![json["license_name"]],
        licenseUrl: json["license_url"],
      );

  Map<String, dynamic> toJson() => {
        "value": value,
        "citation": citation,
        "license_name": licenseName == null
            ? null
            : licenseNameValues.reverse![licenseName],
        "license_url": licenseUrl,
      };
}

enum LicenseName { CC_BY_SA_30 }

final licenseNameValues = EnumValues({"CC BY-SA 3.0": LicenseName.CC_BY_SA_30});

class SimilarImage {
  SimilarImage({
    this.id,
    this.similarity,
    this.url,
    this.urlSmall,
    this.citation,
    this.licenseName,
    this.licenseUrl,
  });

  String? id;
  double? similarity;
  String? url;
  String? urlSmall;
  String? citation;
  String? licenseName;
  String? licenseUrl;

  factory SimilarImage.fromJson(Map<String, dynamic> json) => SimilarImage(
        id: json["id"],
        similarity:
            json["similarity"] == null ? null : json["similarity"].toDouble(),
        url: json["url"],
        urlSmall: json["url_small"],
        citation: json["citation"],
        licenseName: json["license_name"],
        licenseUrl: json["license_url"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "similarity": similarity,
        "url": url,
        "url_small": urlSmall,
        "citation": citation,
        "license_name": licenseName,
        "license_url": licenseUrl,
      };
}

class EnumValues<T> {
  Map<String, T>? map;
  Map<T, String>? reverseMap;

  EnumValues(this.map);

  Map<T, String>? get reverse {
    reverseMap ??= map?.map((k, v) => MapEntry(v, k));
    return reverseMap;
  }
}
