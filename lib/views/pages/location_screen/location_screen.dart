import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:goodealz/core/constants/app_colors.dart';
import 'package:goodealz/core/helper/extensions/assetss_widgets.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

const String kGoogleApiKey = 'AIzaSyBLelj-m_yNs9NZTYfyo7aN7oVAJTugkHs';

class LocationScreen extends StatefulWidget {
  const LocationScreen({Key? key, required this.latLng}) : super(key: key);

  final LatLng latLng;
  @override
  State<LocationScreen> createState() => _LocationScreenState();
}

class _LocationScreenState extends State<LocationScreen> {
  GoogleMapController? mapController;
  LatLng? _currentPosition;
  LatLng? _pickedPosition;
  Marker? _marker;
  bool _selectLoader = false;
  String _currentAddress = '';

  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _suggestions = [];
  Timer? _debounce;
  bool _showSuggestions = false;
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _setMarker(_currentPosition!);
    });

    mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

  void _setMarker(LatLng position) {
    setState(() {
      _pickedPosition = position;
      _marker = Marker(
        markerId: const MarkerId('selected'),
        position: position,
        infoWindow: const InfoWindow(title: 'Selected Location'),
      );
    });
    _updateAddress(position);
  }

  void _onMapTap(LatLng position) {
    _setMarker(position);
    _searchController.clear();
    setState(() {
      _showSuggestions = false;
      _isSearching = false;
    });
  }

  Future<void> _updateAddress(LatLng position) async {
    String address = await _getAddressFromLatLng(position);
    setState(() {
      _currentAddress = address;
    });
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;

        List<String> addressOptions = [];

        if (place.name != null &&
            place.name!.isNotEmpty &&
            _isReadableText(place.name!)) {
          if (place.locality != null && _isReadableText(place.locality!)) {
            addressOptions.add('${place.name!}, ${place.locality!}');
          } else if (place.subLocality != null &&
              _isReadableText(place.subLocality!)) {
            addressOptions.add('${place.name!}, ${place.subLocality!}');
          } else {
            addressOptions.add(place.name!);
          }
        }

        if (place.thoroughfare != null &&
            place.thoroughfare!.isNotEmpty &&
            _isReadableText(place.thoroughfare!)) {
          if (place.locality != null && _isReadableText(place.locality!)) {
            addressOptions.add('${place.thoroughfare!}, ${place.locality!}');
          }
        }

        if (place.subAdministrativeArea != null &&
            _isReadableText(place.subAdministrativeArea!)) {
          if (place.administrativeArea != null &&
              _isReadableText(place.administrativeArea!)) {
            addressOptions.add(
                '${place.subAdministrativeArea!}, ${place.administrativeArea!}');
          } else {
            addressOptions.add(place.subAdministrativeArea!);
          }
        }

        if (place.locality != null &&
            place.locality!.isNotEmpty &&
            _isReadableText(place.locality!)) {
          addressOptions.add(place.locality!);
        } else if (place.subLocality != null &&
            place.subLocality!.isNotEmpty &&
            _isReadableText(place.subLocality!)) {
          addressOptions.add(place.subLocality!);
        }

        if (addressOptions.isNotEmpty) {
          return addressOptions.first;
        }

        if (place.country != null && place.country!.isNotEmpty) {
          return place.country!;
        }
      }
    } catch (e) {
      print('Error in reverse geocoding: $e');
    }
    return 'Unknown Location';
  }

  bool _isReadableText(String text) {
    if (text.isEmpty) return false;

    if (RegExp(r'^[A-Z0-9]{4}\+[A-Z0-9]{2,3}$').hasMatch(text.trim())) {
      return false;
    }

    if (RegExp(r'^[A-Z0-9\+]{3,15}$').hasMatch(text.trim())) {
      return false;
    }

    if (!text.contains(RegExp(r'[a-z]')) && text.length < 4) {
      return false;
    }

    if (text.length < 3 &&
        !['NY', 'LA', 'SF', 'DC'].contains(text.toUpperCase())) {
      return false;
    }

    return true;
  }

  void _confirmSelection() async {
    if (_pickedPosition != null) {
      setState(() {
        _selectLoader = true;
      });

      String address = await _getAddressFromLatLng(_pickedPosition!);

      Navigator.pop(context, {
        'address': address,
        'lat': _pickedPosition!.latitude,
        'lng': _pickedPosition!.longitude,
      });
    }
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();

    setState(() {
      _isSearching = query.isNotEmpty && query.length > 2;
      _showSuggestions = false;
    });

    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.isNotEmpty && query.length > 2) {
        await _searchPlaces(query);
      } else {
        setState(() {
          _suggestions.clear();
          _showSuggestions = false;
          _isSearching = false;
        });
      }
    });
  }

  Future<void> _searchPlaces(String query) async {
    final locale = Provider.of<YsLocalizationsProvider>(context);
    bool isArabicLocale = locale.languageCode == 'ar';

    try {
      final String url =
          'https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&language=${locale.languageCode}&key=$kGoogleApiKey';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final predictions = data['predictions'] as List;

        setState(() {
          _suggestions = predictions
              .map<Map<String, dynamic>>((prediction) => {
                    'place_id': prediction['place_id'],
                    'description': prediction['description'],
                    'main_text': prediction['structured_formatting']
                        ['main_text'],
                    'secondary_text': prediction['structured_formatting']
                            ['secondary_text'] ??
                        '',
                  })
              .toList();
          _showSuggestions = true;
          _isSearching = false;
        });
      }
    } catch (e) {
      print('Error searching places: $e');
      setState(() {
        _isSearching = false;
        _showSuggestions = false;
      });
    }
  }

  Future<void> _selectSuggestion(Map<String, dynamic> suggestion) async {
    final locale = Provider.of<YsLocalizationsProvider>(context);

    try {
      final String placeId = suggestion['place_id'];
      final String url =
          'https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&language=${locale.languageCode}&key=$kGoogleApiKey&fields=geometry';

      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final location = data['result']['geometry']['location'];
        final LatLng pos = LatLng(location['lat'], location['lng']);

        _searchController.text = suggestion['main_text'];
        setState(() {
          _showSuggestions = false;
          _isSearching = false;
        });

        mapController?.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(target: pos, zoom: 16),
          ),
        );
        _setMarker(pos);
      }
    } catch (e) {
      print('Error getting place details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: MainText(
          'pick_location'.tr,
          fontSize: 18,
          fontWeight: FontWeight.w600,
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: _currentPosition == null
          ? const Center(child: CircularProgressIndicator())
          : Stack(
              children: [
                GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: _currentPosition!,
                    zoom: 15,
                  ),
                  onMapCreated: (controller) => mapController = controller,
                  onTap: _onMapTap,
                  markers: _marker != null ? {_marker!} : {},
                  myLocationEnabled: true,
                  myLocationButtonEnabled: false,
                  zoomControlsEnabled: false,
                  mapToolbarEnabled: false,
                  style: '''[
                    {
                      "featureType": "poi",
                      "elementType": "labels.text",
                      "stylers": [{"visibility": "off"}]
                    }
                  ]''',
                ),
                Positioned(
                  top: 16,
                  left: 16,
                  right: 16,
                  child: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: _onSearchChanged,
                          decoration: InputDecoration(
                            hintText: 'search_location'.tr,
                            hintStyle: TextStyle(color: Colors.grey[500]),
                            prefixIcon:
                                Icon(Icons.search, color: Colors.grey[600]),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear,
                                        color: Colors.grey[600]),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _showSuggestions = false;
                                        _isSearching = false;
                                      });
                                    },
                                  )
                                : null,
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 16),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: BorderSide.none,
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12),
                              borderSide: const BorderSide(
                                  color: AppColors.yOrangeColor, width: 2),
                            ),
                          ),
                        ),
                      ),

                      // Loading indicator or Suggestions List
                      if (_showSuggestions && _suggestions.isNotEmpty)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          constraints: const BoxConstraints(maxHeight: 250),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: ListView.separated(
                            shrinkWrap: true,
                            itemCount: _suggestions.length,
                            separatorBuilder: (context, index) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final suggestion = _suggestions[index];
                              return ListTile(
                                leading: const Icon(Icons.location_on,
                                    color: AppColors.yOrangeColor),
                                title: Text(
                                  suggestion['main_text'],
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 16,
                                  ),
                                ),
                                subtitle:
                                    suggestion['secondary_text'].isNotEmpty
                                        ? Text(
                                            suggestion['secondary_text'],
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 14,
                                            ),
                                          )
                                        : null,
                                onTap: () => _selectSuggestion(suggestion),
                              );
                            },
                          ),
                        )
                      else if (_isSearching)
                        Container(
                          margin: const EdgeInsets.only(top: 8),
                          height: 60,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        AppColors.yOrangeColor),
                                  ),
                                ),
                                12.wSize,
                                Text(
                                  'Searching'.tr,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                if (_currentAddress.isNotEmpty)
                  Positioned(
                    bottom: 20,
                    left: 16,
                    right: 16,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        FloatingActionButton(
                          onPressed: _getCurrentLocation,
                          backgroundColor: Colors.white,
                          child: const Icon(Icons.my_location,
                              color: AppColors.yOrangeColor),
                        ),
                        12.hSize,
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.1),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.location_on,
                                color: AppColors.yOrangeColor,
                                size: 24,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Text(
                                      'selected_location'.tr,
                                      style: TextStyle(
                                        color: Colors.grey[600],
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      _currentAddress,
                                      style: const TextStyle(
                                        color: Colors.black87,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w500,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),

      // Confirm Button
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 8,
                offset: Offset(0, -2),
              ),
            ],
          ),
          child: SizedBox(
            width: double.infinity,
            height: 56,
            child: _selectLoader
                ? Container(
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Center(child: CircularProgressIndicator()),
                  )
                : ElevatedButton.icon(
                    onPressed:
                        _pickedPosition != null ? _confirmSelection : null,
                    icon: const Icon(Icons.check, color: Colors.white),
                    label: Text(
                      'select_location'.tr,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _pickedPosition != null
                          ? AppColors.yOrangeColor
                          : Colors.grey[400],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 0,
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }
}
