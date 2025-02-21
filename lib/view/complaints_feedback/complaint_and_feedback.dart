import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateSupplierScreen extends StatefulWidget {
  final String supplierId;
  final String companyName;

  const RateSupplierScreen({super.key, required this.supplierId, required this.companyName});

  @override
  _RateSupplierScreenState createState() => _RateSupplierScreenState();
}

class _RateSupplierScreenState extends State<RateSupplierScreen> {
  double _rating = 0;
  final TextEditingController _feedbackController = TextEditingController();
  final TextEditingController _complaintDetailsController = TextEditingController();
  bool _isSubmitting = false;

  String? _selectedComplaintType;
  Map<String, List<String>> complaintIssues = {
    'Service Complaint': ['Late delivery', 'Incomplete order', 'Poor packaging'],
    'Behavior Complaint': ['Rude behavior', 'Unprofessional attitude'],
    'Technical Complaint': ['App not responding', 'Payment issue', 'Incorrect order processing'],
  };

  List<String> _currentIssues = [];

  void updateComplaintIssues(String? complaintType) {
    setState(() {
      _selectedComplaintType = complaintType;
      _currentIssues = complaintType != null ? complaintIssues[complaintType]! : [];
      _complaintDetailsController.text = _currentIssues.join(', ');
    });
  }

  Future<void> submitFeedback() async {
    if (_rating == 0 && _feedbackController.text.isEmpty && _selectedComplaintType == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please provide a rating, feedback, or complaint.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      final user = FirebaseAuth.instance.currentUser;
      final userId = user?.uid;
      final userEmail = user?.email;

      if (userId == null || userEmail == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('User not logged in. Please log in to submit feedback.')),
        );
        setState(() {
          _isSubmitting = false;
        });
        return;
      }

      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(widget.supplierId)
          .collection('ratings')
          .add({
        'userId': userId,
        'userEmail': userEmail,
        'rating': _rating,
        'feedback': _feedbackController.text.trim(),
        'complaintType': _selectedComplaintType ?? '',
        'complaintDetails': _complaintDetailsController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Feedback & complaint submitted successfully!')),
      );

      _feedbackController.clear();
      _complaintDetailsController.clear();
      setState(() {
        _rating = 0;
        _selectedComplaintType = null;
        _currentIssues = [];
      });
    } catch (e) {
      print('Error submitting feedback: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to submit. Try again.')),
      );
    }

    setState(() {
      _isSubmitting = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text('Rate ${widget.companyName}', style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.blue.shade100, blurRadius: 10, spreadRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Rate the Supplier',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  const SizedBox(height: 10),

                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => const Icon(Icons.star, color: Colors.blue),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Write Feedback (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your experience...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                        borderSide: const BorderSide(color: Colors.blue, width: 2),
                      ),
                      fillColor: Colors.blue[50],
                      filled: true,
                    ),
                  ),
                  const SizedBox(height: 20),

                  const Text(
                    'Select Complaint Type (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  const SizedBox(height: 10),
                DropdownButtonFormField<String>(
                  value: _selectedComplaintType,
                  hint: const Text('Choose Complaint Type', style: TextStyle(color: CupertinoColors.inactiveGray, fontSize: 16)),
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue, width: 1.5),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Colors.blue, width: 2),
                    ),
                    filled: true,
                    fillColor: Colors.blue[50],
                  ),
                  dropdownColor: Colors.white,
                  icon: const Icon(Icons.arrow_drop_down, color: Colors.blue, size: 28),
                  items: complaintIssues.keys.map((String type) {
                    return DropdownMenuItem<String>(
                      value: type,
                      child: Row(
                        children: [
                          Icon(
                            type == 'Service Complaint' ? Icons.build_circle_outlined :
                            type == 'Behavior Complaint' ? Icons.sentiment_dissatisfied :
                            Icons.report_problem,
                            color: Colors.blueAccent,
                          ),
                          const SizedBox(width: 10),
                          Text(type, style: const TextStyle(fontSize: 16, color: Colors.black87, fontWeight: FontWeight.w500)),
                        ],
                      ),
                    );
                  }).toList(),
                  onChanged: updateComplaintIssues,
                ),
                  const SizedBox(height: 20),

                  if (_selectedComplaintType != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Complaint Details (Editable)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _complaintDetailsController,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: 'Describe your complaint...',
                            border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                            fillColor: Colors.blue[50],
                            filled: true,
                          ),
                        ),
                        const SizedBox(height: 20),
                      ],
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isSubmitting
                          ? const CircularProgressIndicator(color: Colors.white)
                          : const Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
