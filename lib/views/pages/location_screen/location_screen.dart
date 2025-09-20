// import 'package:flutter/material.dart';
// import 'package:geolocator/geolocator.dart';
// import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
// import 'package:goodealz/core/ys_localizations/ys_localizations_provider.dart';
// import 'package:goodealz/providers/checkout/checkout_provider.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:location_picker_flutter_map/location_picker_flutter_map.dart';
// import 'package:map_location_picker/map_location_picker.dart';
//
// class LocationScreen extends StatefulWidget {
//   const LocationScreen({super.key, required this.latLng,});
//
//   final LatLng latLng;
//
//   @override
//   State<LocationScreen> createState() => _LocationScreenState();
// }
//
// class _LocationScreenState extends State<LocationScreen> {
//
//   LatLong _currentPosition = LatLong(23, 89);
//
//   @override
//   void initState() {
//     super.initState();
//
//     // Geolocator.requestPermission();
//     _determinePosition();
//   }
//
//   Future<Position> _determinePosition() async {
//     bool serviceEnabled;
//     LocationPermission permission;
//
//     // Test if location services are enabled.
//     serviceEnabled = await Geolocator.isLocationServiceEnabled();
//     if (!serviceEnabled) {
//       // Location services are not enabled don't continue
//       // accessing the position and request users of the
//       // App to enable the location services.
//       return Future.error('Location services are disabled.');
//     }
//
//     permission = await Geolocator.checkPermission();
//     if (permission == LocationPermission.denied) {
//       permission = await Geolocator.requestPermission();
//       if (permission == LocationPermission.denied) {
//         // Permissions are denied, next time you could try
//         // requesting permissions again (this is also where
//         // Android's shouldShowRequestPermissionRationale
//         // returned true. According to Android guidelines
//         // your App should show an explanatory UI now.
//         return Future.error('Location permissions are denied');
//       }
//     }
//
//     if (permission == LocationPermission.deniedForever) {
//       // Permissions are denied forever, handle appropriately.
//       return Future.error(
//           'Location permissions are permanently denied, we cannot request permissions.');
//     }
//
//     // When we reach here, permissions are granted and we can
//     // continue accessing the position of the device.
//     print('/////////////////////////////////');
//     final position = await Geolocator.getCurrentPosition();
//     // _currentPosition = LatLong(position.latitude, position.longitude);
//     setState(() {});
//     return await Geolocator.getCurrentPosition();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     print('----------------');
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Colors.transparent,
//         elevation: 0,
//       ),
//       body: FlutterLocationPicker(
//         // apiKey: 'AIzaSyDCO8coEcKKsPii7hx-bw6GBuMxdpBsl5E',
//           initPosition: LatLong(widget.latLng.latitude, widget.latLng.longitude),
//           selectLocationButtonStyle: ButtonStyle(
//             backgroundColor: MaterialStateProperty.all(Colors.blue),
//           ),
//           mapLanguage: 'en',
//           selectedLocationButtonTextstyle: const TextStyle(fontSize: 18),
//           selectLocationButtonText: 'select_location'.tr,
//           selectLocationButtonLeadingIcon: const Icon(Icons.check),
//           initZoom: 11,
//           minZoomLevel: 5,
//           maxZoomLevel: 20,
//           trackMyPosition: true,
//           onError: (e) => print(e),
//           onPicked: (pickedData) {
//             print('--------------------------');
//             // print(pickedData?.addressComponents[1].shortName);
//             print(pickedData.latLong.longitude);
//             print(pickedData.address);
//             print(pickedData.addressData);
//             final city = pickedData.addressData['city']?? pickedData.addressData['state'];
//             print(pickedData.addressData['country']);
//             Provider.of<CheckoutProvider>(context, listen: false).setAddress(address: pickedData.address, city: city);
//             Navigator.pop(context, {
//               'address': pickedData.address,
//               'lat': pickedData.latLong.latitude,
//               'lng': pickedData.latLong.longitude
//             });
//           },
//           onChanged: (pickedData) {
//             print('0000000000000000000');
//             print(pickedData.latLong.latitude);
//             print(pickedData.latLong.longitude);
//             print(pickedData.address);
//             print(pickedData.addressData);
//           }
//           ),
//     );
//   }
// }

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:goodealz/core/ys_localizations/ys_localizations.dart';
import 'package:goodealz/views/widgets/main_text.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
// import 'package:google_maps_webservice/places.dart';

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

  final TextEditingController _searchController = TextEditingController();
  // final GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
  // List<Prediction> _suggestions = [];
  var _suggestions = [];
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) return;

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;
    }

    Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      _currentPosition = LatLng(position.latitude, position.longitude);
      _setMarker(_currentPosition!);
    });

    mapController?.animateCamera(CameraUpdate.newLatLng(_currentPosition!));
  }

  void _setMarker(LatLng position) {
    setState(() {
      _pickedPosition = position;
      _marker = Marker(markerId: const MarkerId('selected'), position: position);
    });
  }

  void _onMapTap(LatLng position) {
    _setMarker(position);
  }

  Future<String> _getAddressFromLatLng(LatLng position) async {
    try {
      _selectLoader = true;
      setState(() {});
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks.first;
        String address = '${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}';
        return address;
      }
      _selectLoader = false;
      setState(() {});
    } catch (e) {
      _selectLoader = false;
      setState(() {});
      print('Error in reverse geocoding: $e');
    }
    return '';
  }

  void _confirmSelection() async{
    if (_pickedPosition != null) {
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
    _debounce = Timer(const Duration(milliseconds: 300), () async {
      if (query.isNotEmpty) {
        // final response = await _places.autocomplete(query,
        //     language: 'en',
        //     components: [Component(Component.country, 'eg')]); // 🇪🇬 Limit to Egypt if you like
        // setState(() {
        //   _suggestions = response.predictions;
        // });
      } else {
        setState(() {
          _suggestions.clear();
        });
      }
    });
  }

  // Future<void> _selectSuggestion(Prediction p) async {
  //   _searchController.text = p.description!;
  //   _suggestions.clear();
  //
  //   final detail = await _places.getDetailsByPlaceId(p.placeId!);
  //   final location = detail.result.geometry!.location;
  //   final pos = LatLng(location.lat, location.lng);
  //   mapController?.animateCamera(CameraUpdate.newLatLng(pos));
  //   _setMarker(pos);
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(backgroundColor: Colors.transparent,
        elevation: 0,title: MainText('pick_location'.tr),),
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
          ),

          /// 🔍 Custom Search Bar
          Positioned(
            top: 20,
            left: 16,
            right: 16,
            child: Column(
              children: [
                Material(
                  elevation: 5,
                  borderRadius: BorderRadius.circular(8),
                  child: TextField(
                    controller: _searchController,
                    onChanged: _onSearchChanged,
                    decoration: InputDecoration(
                      hintText: 'search_location'.tr,
                      prefixIcon: const Icon(Icons.search),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: const EdgeInsets.all(15),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),

                /// 🧠 Suggestions
                if (_suggestions.isNotEmpty)
                  Container(
                    margin: const EdgeInsets.only(top: 4),
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: ListView.builder(
                      itemCount: _suggestions.length,
                      itemBuilder: (context, index) {
                        final p = _suggestions[index];
                        return ListTile(
                          title: Text(p.description ?? ''),
                          // onTap: () => _selectSuggestion(p),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),

          /// 📍 My Location Button
          Positioned(
            bottom: 100,
            right: 16,
            child: FloatingActionButton(
              onPressed: _getCurrentLocation,
              child: const Icon(Icons.my_location),
            ),
          ),
        ],
      ),

      /// ✅ Confirm Button
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: SizedBox(
            width: double.infinity,
            height: 50,
            child: _selectLoader ? const Center(child: CircularProgressIndicator(),) : ElevatedButton.icon(
              onPressed: _confirmSelection,
              icon: const Icon(Icons.check),
              label: Text('select_location'.tr),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue[500],
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
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