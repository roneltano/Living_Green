import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:living_plant/user/home/PlantRecognitions/module/plantModule.dart';

class imageDetials with ChangeNotifier {
  String? _imagePath;
  String? _ImageName;
  String? _probaility;
  String? _description;
  String? _kingdom;
  String? _phylum;
  String? _plantClass;
  String? _plantOrder;
  String? _family;
  String? _genus;

  String? get imagePath => _imagePath;
  String? get imageName => _ImageName;
  String? get probaility => _probaility;
  String? get description => _description;
  String? get kingdom => _kingdom;
  String? get phylum => _phylum;
  String? get plantClass => _plantClass;
  String? get plantOrder => _plantOrder;
  String? get fiamly => _family;
  String? get gunes => _genus;

  updateImagePath(String? imagePath) {
    _imagePath = imagePath;
    notifyListeners();
  }

  updateImageName(String? imageName) {
    _ImageName = imageName;
    notifyListeners();
  }

  updateProbaility(String? probality) {
    _probaility = probality;
    notifyListeners();
  }

  updateDescription(String? description) {
    _description = description;
    notifyListeners();
  }

  updateKingdom(String? kingdom) {
    _kingdom = kingdom;
    notifyListeners();
  }

  updatePhylum(String? phylum) {
    _phylum = phylum;
    notifyListeners();
  }

  updatePlantClass(String? plantClass) {
    _plantClass = plantClass;
    notifyListeners();
  }

  updatePlantOrder(String? plantOrder) {
    _plantOrder = plantOrder;
    notifyListeners();
  }

  updateFamily(String? family) {
    _family = family;
    notifyListeners();
  }

  updateGenues(String? genus) {
    _genus = genus;
    notifyListeners();
  }
}
