import 'package:flutter/material.dart';

import 'package:qr2/providers/db_provider.dart';

class ScanListProvider extends ChangeNotifier {
  List<ScanModel> scans = [];
  String selectedType = 'http';

  Future<ScanModel> newScan(String value) async {
    final newScan = new ScanModel(value: value);
    final id = await DBProvider.db.newScan(newScan);

    newScan.id = id;

    if (this.selectedType == newScan.type) {
      this.scans.add(newScan);

      notifyListeners();
    }

    return newScan;
  }

  chargeScans() async {
    final scans = await DBProvider.db.getScanAll();

    this.scans = [...scans];

    notifyListeners();
  }

  chargeScansByType(String type) async {
    final scans = await DBProvider.db.getScanByType(type);

    this.scans = [...scans];

    notifyListeners();
  }

  deleteScans() async {
    await DBProvider.db.deleteScan();

    this.scans = [];

    notifyListeners();
  }

  deleteScanById(int id) async {
    scans.removeWhere((scan) => scan.id == id);

    await DBProvider.db.deleteScanById(id);
  }
}
