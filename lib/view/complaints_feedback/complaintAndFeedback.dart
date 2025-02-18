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
  TextEditingController _complaintController = TextEditingController();
  bool _isSubmitting = false;

  Future<void> submitFeedback() async {
    if (_rating == 0 && _feedbackController.text.isEmpty && _complaintController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please provide a rating, feedback, or complaint.')),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    try {
      // Get current user's details
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

      // Add rating to Firestore
      await FirebaseFirestore.instance
          .collection('suppliers')
          .doc(widget.supplierId)
          .collection('ratings')
          .add({
        'userId': userId,
        'userEmail': userEmail,
        'rating': _rating,
        'feedback': _feedbackController.text.trim(),
        'complaint': _complaintController.text.trim(),
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Feedback & complaint submitted successfully!')),
      );

      // Clear input fields
      _feedbackController.clear();
      _complaintController.clear();
      setState(() {
        _rating = 0;
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
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Rate the Supplier',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.blue),
                  ),
                  SizedBox(height: 10),

                  // Rating Bar
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

                  // Feedback Section
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

                  // Complaint Section
                  Text(
                    'Write a Complaint (Optional)',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.black87),
                  ),
                  SizedBox(height: 10),
                  TextField(
                    controller: _complaintController,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Describe your complaint...',
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                      fillColor: Colors.blue[50],
                      filled: true,
                    ),
                  ),
                  SizedBox(height: 20),

                  // Submit Button
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
