import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SupplierRatingsScreen extends StatelessWidget {
  final String supplierId;

  SupplierRatingsScreen({required this.supplierId});

  Future<String> _getUserName(String userId) async {
    try {
      final userDoc = await FirebaseFirestore.instance.collection('Users').doc(userId).get();
      if (userDoc.exists) {
        return userDoc.data()?['name'] ?? 'Unknown User';
      } else {
        return 'Unknown User';
      }
    } catch (e) {
      print('Error fetching user name: $e');
      return 'Unknown User';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        title: Text(
          'Ratings & Feedback',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue,
        iconTheme: IconThemeData(color: Colors.white),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('suppliers')
            .doc(supplierId)
            .collection('ratings')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading ratings.',
                style: TextStyle(color: Colors.red, fontSize: 16),
              ),
            );
          }

          if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
            return Center(
              child: Text(
                'No ratings or feedback available.',
                style: TextStyle(color: Colors.grey[700], fontSize: 16),
              ),
            );
          }

          final ratings = snapshot.data!.docs;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: ratings.length,
            itemBuilder: (context, index) {
              final ratingData = ratings[index].data() as Map<String, dynamic>;
              final rating = ratingData['rating'] ?? 0.0;
              final feedback = ratingData['feedback'] ?? 'No feedback provided.';
              final complaint = ratingData['complaint'] ?? 'No complaint submitted.';
              final userId = ratingData['userId'] ?? '';
              final timestamp = ratingData['timestamp'] != null
                  ? (ratingData['timestamp'] as Timestamp).toDate()
                  : null;

              return FutureBuilder<String>(
                future: _getUserName(userId),
                builder: (context, userSnapshot) {
                  final userName = userSnapshot.data ?? 'Fetching user...';

                  return Card(
                    margin: EdgeInsets.only(bottom: 16.0),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 4,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.person, color: Colors.blue),
                              SizedBox(width: 8),
                              Text(
                                userName,
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.star, color: Colors.yellow[700]),
                              SizedBox(width: 8),
                              Text(
                                'Rating: ${rating.toStringAsFixed(1)}',
                                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          if (feedback.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Feedback:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  feedback,
                                  style: TextStyle(color: Colors.black87, fontSize: 14),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          if (complaint.isNotEmpty)
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Complaint:',
                                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  complaint,
                                  style: TextStyle(color: Colors.red[800], fontSize: 14),
                                ),
                                SizedBox(height: 8),
                              ],
                            ),
                          if (timestamp != null)
                            Text(
                              'Date: ${timestamp.toLocal()}'.split('.')[0],
                              style: TextStyle(color: Colors.grey[600], fontSize: 12),
                            ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}
