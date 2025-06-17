import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:geolocator/geolocator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class SupermarketListPage extends StatefulWidget {
  @override
  _SupermarketListPageState createState() => _SupermarketListPageState();
}

class _SupermarketListPageState extends State<SupermarketListPage> {
  final Color primaryColor = const Color(0xFF8D6CD1);

  final List<Map<String, dynamic>> supermarkets = [
    {
      'name': 'Supermercado Central',
      'address': 'Av. Paulista, 1000, São Paulo - SP',
      'hours': '08:00 - 22:00',
      'phone': '(11) 1234-5678',
      'latitude': -23.561684,
      'longitude': -46.655981
    },
    {
      'name': 'Supermercado Econômico',
      'address': 'Rua das Flores, 250, São Paulo - SP',
      'hours': '07:00 - 21:00',
      'phone': '(11) 9876-5432',
      'latitude': -23.564372,
      'longitude': -46.654514
    },
    {
      'name': 'Supermercado Popular',
      'address': 'Rua Verde, 75, São Paulo - SP',
      'hours': '09:00 - 20:00',
      'phone': '(11) 3456-7890',
      'latitude': -23.562730,
      'longitude': -46.657309
    },
  ];

  LatLng? selectedLocation;
  LatLng? userLocation;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: primaryColor.withOpacity(0.6),
        elevation: 0,
        title: const Text(
          'Supermercados Próximos',
          style: TextStyle(color: Colors.white),
        ),
        iconTheme: IconThemeData(color: Colors.white),
        automaticallyImplyLeading: true,
        leading: selectedLocation != null
            ? IconButton(
                icon: Icon(Icons.arrow_back),
                onPressed: () {
                  setState(() {
                    selectedLocation = null;
                    userLocation = null;
                  });
                },
              )
            : null,
      ),
      body: selectedLocation == null ? buildListView() : buildMapView(),
    );
  }

  Widget buildListView() {
    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: supermarkets.length,
      itemBuilder: (context, index) {
        final market = supermarkets[index];
        return Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 6,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(Icons.store, color: primaryColor, size: 32),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      market['name'],
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      market['address'],
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Horário: ${market['hours']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Tel: ${market['phone']}',
                      style: const TextStyle(color: Colors.black54),
                    ),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(Icons.map_outlined, color: primaryColor, size: 28),
                onPressed: () async {
                  var status = await Permission.location.status;
                  if (!status.isGranted) {
                    status = await Permission.location.request();
                  }
                  if (status.isGranted) {
                    Position position = await Geolocator.getCurrentPosition();
                    setState(() {
                      userLocation = LatLng(position.latitude, position.longitude);
                      selectedLocation = LatLng(
                        market['latitude'],
                        market['longitude'],
                      );
                    });
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Permissão de localização necessária para visualizar o mapa.')),
                    );
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  Widget buildMapView() {
    if (userLocation == null || selectedLocation == null) {
      return Center(child: CircularProgressIndicator());
    }

    final markers = <Marker>[
      Marker(
        point: userLocation!,
        width: 80,
        height: 80,
        builder: (ctx) => Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
      ),
      Marker(
        point: selectedLocation!,
        width: 80,
        height: 80,
        builder: (ctx) => Icon(Icons.location_pin, color: primaryColor, size: 40),
      ),
    ];

    return Stack(
      children: [
        FlutterMap(
          options: MapOptions(
            center: selectedLocation,
            zoom: 15,
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
              subdomains: ['a', 'b', 'c'],
            ),
            MarkerLayer(markers: markers),
          ],
        ),
        if (userLocation != null && selectedLocation != null)
          Positioned(
            bottom: 40,
            left: 40,
            right: 40,
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: primaryColor,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              icon: Icon(Icons.directions, color: Colors.white),
              label: Text(
                'Traçar rota',
                style: TextStyle(color: Colors.white, fontSize: 16),
              ),
              onPressed: () async {
                final origin = '${userLocation!.latitude},${userLocation!.longitude}';
                final dest = '${selectedLocation!.latitude},${selectedLocation!.longitude}';
                final url = Uri.parse('https://www.google.com/maps/dir/?api=1&origin=$origin&destination=$dest&travelmode=driving');
                if (await canLaunchUrl(url)) {
                  await launchUrl(url, mode: LaunchMode.externalApplication);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Não foi possível abrir o aplicativo de mapas.')),
                  );
                }
              },
            ),
          ),
      ],
    );
  }
}