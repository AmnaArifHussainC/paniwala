import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../config/services/order_add_service.dart';
import '../../../config/utils/validators.dart';

class CustomerDetailsForOrder extends StatefulWidget {
  const CustomerDetailsForOrder({Key? key}) : super(key: key);

  @override
  State<CustomerDetailsForOrder> createState() => _CustomerDetailsForOrderState();
}

class _CustomerDetailsForOrderState extends State<CustomerDetailsForOrder> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _dailyDelivery = false;
  String _deliveryTime = 'Morning';
  bool _refillOnly = false;

  _showOrderPlacedDialog() async {
    await showDialog<void>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Order Booked'),
          content: const Text('Your order has been successfully booked.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text(
                'OK',
                style: TextStyle(color: Colors.blue),
              ),
            ),
          ],
        );
      },
    );
  }

  final OrderService _orderService = OrderService();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Customer Details',
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const Text(
                'Fill in your details below to complete your order:',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 24),
              _buildTextField(
                controller: _nameController,
                label: 'Name',
                icon: Icons.person,
                validator: ValidationUtils.validateFullName,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _phoneController,
                label: 'Phone Number',
                icon: Icons.phone,
                inputType: TextInputType.phone,
                validator: ValidationUtils.validatePhoneNumber,
              ),
              const SizedBox(height: 16),
              _buildTextField(
                controller: _addressController,
                label: 'Address',
                icon: Icons.location_on,
                validator: ValidationUtils.validateDeliveryArea,
              ),
              const SizedBox(height: 16),
              SwitchListTile(
                activeColor: Colors.blue,
                title: const Text(
                  'Daily Delivery',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                value: _dailyDelivery,
                onChanged: (value) {
                  setState(() {
                    _dailyDelivery = value;
                  });
                },
              ),
              if (_dailyDelivery)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 16.0),
                  child: DropdownButtonFormField<String>(
                    value: _deliveryTime,
                    items: const [
                      DropdownMenuItem(
                        value: 'Morning',
                        child: Text('Morning'),
                      ),
                      DropdownMenuItem(
                        value: 'Afternoon',
                        child: Text('Afternoon'),
                      ),
                      DropdownMenuItem(
                        value: 'Evening',
                        child: Text('Evening'),
                      ),
                    ],
                    onChanged: (value) {
                      setState(() {
                        _deliveryTime = value ?? 'Morning';
                      });
                    },
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: CupertinoColors.inactiveGray,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 16),
              CheckboxListTile(
                activeColor: Colors.blue,
                title: const Text(
                  'Refill Only',
                  style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
                ),
                value: _refillOnly,
                onChanged: (value) {
                  setState(() {
                    _refillOnly = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState?.validate() ?? false) {
                    final customerDetails = {
                      'name': _nameController.text,
                      'phone': _phoneController.text,
                      'address': _addressController.text,
                      'dailyDelivery': _dailyDelivery,
                      'deliveryTime': _deliveryTime,
                      'refillOnly': _refillOnly,
                    };
                    print('Customer Details: $customerDetails');
                    _showOrderPlacedDialog();
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    TextInputType inputType = TextInputType.text,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      keyboardType: inputType,
      validator: validator,
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.blue),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Colors.blue,
            width: 2,
          ),
        ),
      ),
    );
  }
}
