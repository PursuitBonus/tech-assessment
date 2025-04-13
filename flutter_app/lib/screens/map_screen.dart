import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';

import '../cubits/marketplace_cubit.dart';
import '../cubits/user_cubit.dart';
import '../dialogs/buy_dialog.dart';
import '../models/marketplace_item.dart';

class MapScreen extends StatefulWidget {
  const MapScreen({super.key});

  @override
  State<MapScreen> createState() => _MapScreenState();
}

class _MapScreenState extends State<MapScreen> {
  final MapController _mapController = MapController();
  LatLng? userLocation;
  String? selectedItemId;

  @override
  void initState() {
    super.initState();
    _getLocation();
  }

  Future<void> _getLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    final pos = await Geolocator.getCurrentPosition();
    final latLng = LatLng(pos.latitude, pos.longitude);

    setState(() => userLocation = latLng);

    // Move map AFTER FlutterMap is rendered
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await Future.delayed(const Duration(milliseconds: 50));
      _mapController.move(latLng, 12);
    });
  }

  void _showItemDetails(MarketplaceItem item) {
    setState(() => selectedItemId = item.id);

    showModalBottomSheet(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: item.imageUrl.startsWith('/')
                  ? Image.file(File(item.imageUrl), height: 120, width: double.infinity, fit: BoxFit.cover)
                  : Image.asset(item.imageUrl, height: 120, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 12),
            Text(item.name, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 4),
            Text("€${item.price.toStringAsFixed(2)}"),
            const SizedBox(height: 8),
            Text(item.description, style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context); // Close the bottom sheet first
                showDialog(
                  context: context,
                  builder: (_) => BuyDialog(item: item),
                );
              },
              child: const Text("Buy"),
            )
          ],
        ),
      ),
    ).whenComplete(() {
      setState(() => selectedItemId = null);
    });
  }

  @override
  Widget build(BuildContext context) {
    final items = context.watch<MarketplaceCubit>().state.availableItems;

    if (userLocation == null) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: const Text("Item Map")),
      body: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          initialZoom: 12,
          onTap: (_, __) => setState(() => selectedItemId = null), // deselect if user taps the map
        ),
        children: [
          TileLayer(
            urlTemplate: 'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
            subdomains: const ['a', 'b', 'c'],
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: userLocation!,
                width: 40,
                height: 40,
                child: const Icon(Icons.person_pin_circle, color: Colors.blue, size: 40),
              ),
              ...items.where((item) => item.hasCoordinates).map((item) {
                final isSelected = item.id == selectedItemId;

                return Marker(
                  point: LatLng(item.latitude!, item.longitude!),
                  width: 30,
                  height: 30,
                  child: GestureDetector(
                    onTap: () => _showItemDetails(item),
                    child: Icon(
                      Icons.location_on,
                      color: isSelected ? Colors.green : Colors.red,
                      size: 30,
                    ),
                  ),
                );
              }).toList(),
            ],
          ),
        ],
      ),
    );
  }
}

