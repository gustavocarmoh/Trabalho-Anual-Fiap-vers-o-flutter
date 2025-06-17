import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
  @override
  _MapPageState createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  GoogleMapController? _mapController;
  LatLng? _currentPosition;
  String? _error;

  @override
  void initState() {
    super.initState();
    _checkPermissionAndGetLocation();
  }

  Future<void> _checkPermissionAndGetLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        setState(() {
          _error = 'Serviço de localização está desativado. Ative para continuar.';
        });
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        setState(() {
          _error = 'Permissão de localização permanentemente negada. Altere nas configurações do dispositivo.';
        });
        return;
      }
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        Position position = await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
        setState(() {
          _currentPosition = LatLng(position.latitude, position.longitude);
          _error = null;
        });
      } else {
        setState(() {
          _error = 'Permissão de localização negada. Por favor, permita o acesso à localização.';
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Erro ao obter localização: $e';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mapa')),
        body: Center(child: Text(_error!)),
      );
    }
    if (_currentPosition == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Mapa')),
        body: Center(child: CircularProgressIndicator()),
      );
    }
    return Scaffold(
      appBar: AppBar(title: Text('Mapa')),
      body: GoogleMap(
        initialCameraPosition: CameraPosition(
          target: _currentPosition!,
          zoom: 16,
        ),
        myLocationEnabled: true,
        myLocationButtonEnabled: true,
        markers: {
          Marker(
            markerId: MarkerId('current_location'),
            position: _currentPosition!,
            infoWindow: InfoWindow(title: 'Você está aqui'),
          ),
        },
        onMapCreated: (controller) => _mapController = controller,
      ),
    );
  }
}
