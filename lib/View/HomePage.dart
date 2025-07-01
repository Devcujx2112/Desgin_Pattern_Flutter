import 'package:design_pattern_login/ViewModel/AreaMonitorViewModel.dart';
import 'package:design_pattern_login/ViewModel/HomePageViewModel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isLoading = true;
  Map<String, dynamic> dataCountry = {};
  final MapController _mapController = MapController();
  Future<Map<String, List<LatLng>>> _polygonsFuture = Future.value({});

  @override
  void initState() {
    super.initState();
    LoadAllData();
    MapData();
  }

  void MapData() {
    _mapController.mapEventStream.listen((event) {
      if (event is MapEventMove) {
        final currentLat = _mapController.camera.center.latitude;
        // Nếu vượt quá giới hạn vĩ độ (-85 đến 85)
        if (currentLat < -85 || currentLat > 85) {
          _mapController.move(
            LatLng(
              currentLat.clamp(-85.0, 85.0), // Ép vĩ độ về khoảng an toàn
              _mapController.camera.center.longitude, // Giữ nguyên kinh độ
            ),
            _mapController.camera.zoom,
          );
        }
      }
    });
  }

  void LoadAllData() async {
    final VM_Country = Provider.of<AreaMontitorViewModel>(
      context,
      listen: false,
    );
    final VM_HomePage = Provider.of<HomePageViewModel>(context, listen: false);
    Map<String, dynamic> data = await VM_Country.ShowAllInformation();
    if (data.isNotEmpty) {
      setState(() {
        dataCountry = data;
        _polygonsFuture = VM_HomePage.ColorCountries(data);
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: _isLoading,
      progressIndicator: LoadingAnimationWidget.inkDrop(
        color: Colors.blue,
        size: 40,
      ),
      child: Scaffold(
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
              child: FutureBuilder(
                future: _polygonsFuture,
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return LoadingAnimationWidget.inkDrop(
                      color: Colors.green,
                      size: 50,
                    );
                  }
                  final polygons = snapshot.data ?? {};
                  return FlutterMap(
                    mapController: _mapController,
                    options: MapOptions(
                      initialCenter: LatLng(41.185, 19.638),
                      initialZoom: 3,
                    ),
                    children: [
                      TileLayer(
                        urlTemplate:
                            'https://api.maptiler.com/maps/streets/{z}/{x}/{y}.png?key=erZm4UfkUOKJaSLKD2rP',
                        userAgentPackageName: 'com.example.app',
                        tileSize: 256,
                        maxZoom: 22,
                        minZoom: 0,
                        subdomains: const [],
                      ),
                      PolygonLayer(
                        polygons:
                            polygons.entries
                                .map(
                                  (entry) => Polygon(
                                    points: entry.value,
                                    color: _getColorByCountry(entry.key),
                                    borderStrokeWidth: 1,
                                  ),
                                )
                                .toList(),
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getColorByCountry(String country) {
    return country == "Viet Nam" ? Colors.red : Colors.blue.withOpacity(0.5);
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
