import 'dart:io';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../cubits/auth_cubit.dart';
import '../cubits/marketplace_cubit.dart';
import '../cubits/user_cubit.dart';

class SellItemScreen extends StatefulWidget {
  const SellItemScreen({super.key});

  @override
  State<SellItemScreen> createState() => _SellItemScreenState();
}

class _SellItemScreenState extends State<SellItemScreen> {
  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  final nameController = TextEditingController();
  final locationController = TextEditingController();
  final priceController = TextEditingController();

  Position? currentPosition;
  Future<void> _getCurrentLocation() async {
    final permission = await Geolocator.requestPermission();
    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) return;

    final position = await Geolocator.getCurrentPosition();
    setState(() {
      currentPosition = position;
    });
  }

  File? image;
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      setState(() => image = File(picked.path));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Sell Item")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            GestureDetector(
              onTap: _pickImage,
              child: image == null
                  ? Container(
                height: 160,
                width: double.infinity,
                color: Colors.grey.shade200,
                child: const Icon(Icons.camera_alt, size: 40),
              )
                  : Image.file(image!, height: 160, width: double.infinity, fit: BoxFit.cover),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Item Name"),
            ),
            TextField(
              controller: locationController,
              decoration: const InputDecoration(labelText: "Location"),
            ),
            TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: "Price"),
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                final name = nameController.text.trim();
                final location = locationController.text.trim();
                final price = double.tryParse(priceController.text.trim());
                final sellerId = context.read<UserCubit>().state.userId;


                if (name.isEmpty || location.isEmpty || price == null || image == null || currentPosition == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text("Please fill all fields and allow location")),
                  );
                  return;
                }

                context.read<MarketplaceCubit>().addItem(
                  name: name,
                  location: location,
                  price: price,
                  imagePath: image!.path,
                  sellerId: sellerId,
                  latitude: currentPosition!.latitude,
                  longitude: currentPosition!.longitude,
                );

                Navigator.pop(context);
              },

              child: const Text("Publish"),
            )
          ],
        ),
      ),
    );
  }
}
