import 'package:design_pattern_login/ViewModel/HomePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1F1F1F),
      appBar: AppBar(
        backgroundColor: const Color(0xFF1F1F1F),
        centerTitle: true,
        title: const Text(
          "Map",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        automaticallyImplyLeading: false,
      ),
      body: Column(
        children: [
          _buildSearchBar(),
          const SizedBox(height: 10),
          Expanded(
            child: FlutterMap(
              mapController: MapController(),
              options: MapOptions(
                initialCenter: LatLng(34.0479, 100.6197),
                initialZoom: 4,
                minZoom: 2,
                maxZoom: 18,
              ),
              children: [
                TileLayer(
                  urlTemplate: 'https://{s}.basemaps.cartocdn.com/dark_all/{z}/{x}/{y}{r}.png',
                  userAgentPackageName: 'com.yourapp.package',
                )
              ],
            )
          ),
        ],
      ),
    );
  }

  Widget _buildSearchBar() {
    final VM_HomePage = Provider.of<HomePageViewModel>(context, listen: false);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: TextField(
            controller: VM_HomePage.searchCountry,
            style: TextStyle(fontSize: 13),
            // onChanged: (value) => ShowAllData(),
            decoration: InputDecoration(
              hintText: "Bạn đang tìm kiếm gì?",
              hintStyle: TextStyle(fontSize: 13),
              prefixIcon: const Icon(
                Icons.search,
                color: Colors.green,
                size: 28,
              ),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
              contentPadding: const EdgeInsets.symmetric(
                vertical: 18,
                horizontal: 12,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
