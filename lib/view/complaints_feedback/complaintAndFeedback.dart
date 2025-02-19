import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class RateSupplierScreen extends StatefulWidget {
  final String supplierId;
  final String companyName;

  RateSupplierScreen({required this.supplierId, required this.companyName});

  @override
  _RateSupplierScreenState createState() => _RateSupplierScreenState();
}

class _RateSupplierScreenState extends State<RateSupplierScreen> {
  double _rating = 0;
  TextEditingController _feedbackController = TextEditingController();
  TextEditingController _complaintDetailsController = TextEditingController();
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
        SnackBar(content: Text('Please provide a rating, feedback, or complaint.')),
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
          SnackBar(content: Text('User not logged in. Please log in to submit feedback.')),
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
        SnackBar(content: Text('Feedback & complaint submitted successfully!')),
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
        SnackBar(content: Text('Failed to submit. Try again.')),
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
        title: Text('Rate ${widget.companyName}', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.blue.shade100, blurRadius: 10, spreadRadius: 2)],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rate the Supplier',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 10),

                  RatingBar.builder(
                    initialRating: _rating,
                    minRating: 1,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                    itemBuilder: (context, _) => Icon(Icons.star, color: Colors.blue),
                    onRatingUpdate: (rating) {
                      setState(() {
                        _rating = rating;
                      });
                    },
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Write Feedback (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _feedbackController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your experience...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Colors.blue[50],
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),

                  Text(
                    'Select Complaint Type (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  DropdownButtonFormField<String>(
                    value: _selectedComplaintType,
                    hint: Text('Choose Complaint Type'),
                    items: complaintIssues.keys.map((String type) {
                      return DropdownMenuItem<String>(
                        value: type,
                        child: Text(type),
                      );
                    }).toList(),
                    onChanged: updateComplaintIssues,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Colors.blue[50],
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),

                  if (_selectedComplaintType != null)
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Complaint Details (Editable)',
                          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                        ),
                        SizedBox(height: 10),
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
                        SizedBox(height: 20),
                      ],
                    ),

                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isSubmitting ? null : submitFeedback,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                      ),
                      child: _isSubmitting
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text('Submit', style: TextStyle(color: Colors.white, fontSize: 16)),
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
