import 'package:country_codes/country_codes.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:geojson_vi/geojson_vi.dart';
import 'package:latlong2/latlong.dart';

class HomePageViewModel extends ChangeNotifier {
  final String aPIRealTime =
      "https://flutter-api-2f232-default-rtdb.firebaseio.com";
  final String geoJsonFile = "assets/customMap.json";
  TextEditingController searchCountry = TextEditingController();

  Future<Map<String, List<List<LatLng>>>> ColorCountries(
    Map<String, dynamic> data,
  ) async {
    await CountryCodes.init();

    final geoJson = await _loadGeoJSON();
    final countryPolygons = <String, List<List<LatLng>>>{};

    for (final rawName in _extractCountries(data)) {
      try {
        final country = CountryCodes.countryCodes().firstWhere(
          (c) => _matchesCountry(c, rawName),
        );

        final polygons = _findPolygonsByISO(geoJson, country.alpha3Code!);
        if (polygons.isNotEmpty) countryPolygons[rawName] = polygons;
      } catch (e) {
        print('Không tìm thấy đất nước cho "$rawName"');
      }
    }

    return countryPolygons;
  }

  Future<Map<String, LatLng>> CalculateCountryCenters(Map<String, dynamic> data) async {
    final Map<String, LatLng> centers = {};

    data.forEach((country, countryData) {
      try {
        final coordinates = countryData['coordinates'] as List<dynamic>? ?? []; // Thêm null check

        double totalLat = 0;
        double totalLng = 0;
        int pointCount = 0;

        for (var polygon in coordinates) {
          if (polygon is List) { // Thêm kiểm tra kiểu
            for (var point in polygon) {
              if (point is List && point.length >= 2) { // Đảm bảo point có đủ 2 phần tử
                totalLat += point[1]; // latitude
                totalLng += point[0]; // longitude
                pointCount++;
              }
            }
          }
        }

        if (pointCount > 0) {
          centers[country] = LatLng(
            totalLat / pointCount,
            totalLng / pointCount,
          );
        }
      } catch (e) {
        print('Error calculating center for $country: $e');
      }
    });

    return centers;
  }
  List<List<LatLng>> _findPolygonsByISO(
    GeoJSONFeatureCollection geoJson,
    String isoCode,
  ) {
    final polygons = <List<LatLng>>[];
    for (final feature in geoJson.features) {
      final props = feature?.properties;
      final geoJsonIso3 = props?['iso_a3']?.toString().toUpperCase();

      if (geoJsonIso3 == isoCode) {
        final geometry = feature?.geometry;

        if (geometry is GeoJSONPolygon) {
          try {
            for (final coordinates in geometry.coordinates) {
              polygons.add(
                coordinates.map((coord) => LatLng(coord[1], coord[0])).toList(),
              );
            }
          } catch (e) {
            print('Lỗi khi xử lý Polygon: $e');
          }
        } else if (geometry is GeoJSONMultiPolygon) {
          try {
            for (final polygon in geometry.coordinates) {
              for (final coordinates in polygon) {
                polygons.add(
                  coordinates
                      .map((coord) => LatLng(coord[1], coord[0]))
                      .toList(),
                );
              }
            }
          } catch (e) {
            print('Lỗi khi xử lý MultiPolygon: $e');
          }
        }
      }
    }
    return polygons;
  }

  bool _matchesCountry(CountryDetails country, String inputName) {
    final input = inputName.trim().toLowerCase();
    final countryName = country.name?.trim().toLowerCase() ?? '';

    if (countryName == input) return true;

    if (country.alpha3Code?.toLowerCase() == input) return true;
    if (country.alpha2Code?.toLowerCase() == input) return true;

    return false;
  }

  Future<GeoJSONFeatureCollection> _loadGeoJSON() async {
    final geoJsonString = await rootBundle.loadString('assets/customMap.json');
    return GeoJSONFeatureCollection.fromJSON(geoJsonString);
  }

  Set<String> _extractCountries(Map<String, dynamic> firebaseData) {
    return firebaseData.values
        .map((event) => event['NameCountry']?.toString())
        .whereType<String>()
        .toSet();
  }
}
