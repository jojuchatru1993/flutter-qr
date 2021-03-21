import 'package:flutter/material.dart';

import 'package:provider/provider.dart';

import 'package:qr2/providers/scan_list_provider.dart';
import 'package:qr2/providers/ui_provider.dart';

import 'package:qr2/pages/addresses_page.dart';
import 'package:qr2/pages/maps_page.dart';

import 'package:qr2/widgets/custom_navigation_bar.dart';
import 'package:qr2/widgets/scan_button.dart';

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text('Records'),
        actions: [
          IconButton(
              icon: Icon(Icons.delete_forever),
              onPressed: () {
                Provider.of<ScanListProvider>(context, listen: false)
                    .deleteScans();
              }),
        ],
      ),
      body: _HomePageBody(),
      bottomNavigationBar: CustomNavigationBar(),
      floatingActionButton: ScanButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

class _HomePageBody extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final uiProvider = Provider.of<UiProvider>(context);
    final currentIndex = uiProvider.selectedMenuOpt;

    final scanListProvider =
        Provider.of<ScanListProvider>(context, listen: false);

    switch (currentIndex) {
      case 0:
        scanListProvider.chargeScansByType('geo');
        return MapsPage();
      case 1:
        scanListProvider.chargeScansByType('http');
        return AddressesPage();
      default:
        return MapsPage();
    }
  }
}
