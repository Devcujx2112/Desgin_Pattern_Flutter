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

  Future<Map<String, List<LatLng>>> ColorCountries(
    Map<String, dynamic> data,
  ) async {
    await CountryCodes.init();

    final geoJson = await _loadGeoJSON();
    final countryPolygons = <String, List<LatLng>>{};

    for (final rawName in _extractCountries(data)) {
      try {
        final country = CountryCodes.countryCodes().firstWhere(
          (c) => _matchesCountry(c, rawName),
        );

        final polygon = _findPolygonByISO(geoJson, country.alpha3Code!);
        if (polygon != null) countryPolygons[rawName] = polygon;
      } catch (e) {
        print('Không tìm thấy đất nước cho "$rawName"');
      }
    }

    return countryPolygons;
  }

  List<LatLng>? _findPolygonByISO(GeoJSONFeatureCollection geoJson, String isoCode) {
    for (final feature in geoJson.features) {
      final props = feature?.properties;
      final geoJsonIso3 = props?['iso_a3']?.toString().toUpperCase();

      if (geoJsonIso3 == isoCode) {
        final geometry = feature?.geometry;

        if (geometry is GeoJSONPolygon) {
          try {
            final coordinates = geometry.coordinates.first;
            return coordinates.map((coord) => LatLng(coord[1], coord[0])).toList();
          } catch (e) {
            print('Lỗi khi xử lý Polygon: $e');
          }
        }
        else if (geometry is GeoJSONMultiPolygon) {
          try {
            final firstPolygon = geometry.coordinates.first.first;
            return firstPolygon.map((coord) => LatLng(coord[1], coord[0])).toList();
          } catch (e) {
            print('Lỗi khi xử lý MultiPolygon: $e');
          }
        }
      }
    }
    return null;
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
