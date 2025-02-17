import 'package:flutter/material.dart';
import '../../config/utils/permitions.dart';

class AddressScreen extends StatefulWidget {
  @override
  _AddressScreenState createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  TextEditingController _addressController = TextEditingController();
  bool _isLoading = false; // To track the loading state

  Future<void> _fetchCurrentLocation() async {
    setState(() {
      _isLoading = true; // Show loader when fetching location
    });

    String? address = await LocationUtils.getCurrentLocation();

    setState(() {
      _isLoading = false; // Hide loader when the location is fetched
      if (address != null && address.isNotEmpty) {
        _addressController.text = address;  // Update the text field with the fetched address
      }
    });
  }

  void _saveAddress() async {
    String newAddress = _addressController.text;
    if (newAddress.isNotEmpty) {
      setState(() {
        _isLoading = true; // Show loader when saving the address
      });

      await LocationUtils.updateSupplierAddress(newAddress);

      setState(() {
        _isLoading = false; // Hide loader after saving the address
      });

      Navigator.pop(context, newAddress);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(color: Colors.white),
        title: Text("Edit Address", style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue, // Blue theme for app bar
        elevation: 0,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Your Address",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.black87,
              ),
            ),
            const SizedBox(height: 20),

            // Address TextField with rounded borders and better styling
            TextField(
              controller: _addressController,
              decoration: InputDecoration(
                labelText: "Enter your address",
                labelStyle: TextStyle(color: Colors.black54),
                hintText: "e.g., 123 Main St",
                hintStyle: TextStyle(color: Colors.black38),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue.shade400),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.blue),
                ),
                prefixIcon: Icon(Icons.location_on, color: Colors.blue),
              ),
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),

            // Show loading indicator if _isLoading is true
            if (_isLoading)
              Center(
                child: CircularProgressIndicator(),
              )
            else
            // Buttons arranged in rows with blue and white theme
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Online Location" Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _fetchCurrentLocation,
                    child: Text(
                      "Online Location",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
                    ),
                  ),
                  // "Save Address" Button
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14, horizontal: 30),
                      backgroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                        side: BorderSide(color: Colors.blue),
                      ),
                      elevation: 5,
                    ),
                    onPressed: _saveAddress,
                    child: Text(
                      "Save Address",
                      style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: Colors.blue),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}
