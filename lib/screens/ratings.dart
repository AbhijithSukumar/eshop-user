import 'package:flutter/material.dart';

class Ratings extends StatelessWidget {
  

  const Ratings({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final ratingsList=ModalRoute.of(context)?.settings.arguments as List<Map<String,dynamic>>;
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text("Rating and feedbacks"),
        ),
        body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.0),
          color: const Color(0xFFF5F5F5),
        ),
        child: Column(
          children: [
            _buildTitleRow(ratingsList),
            const Divider(thickness: 1.0),
            Expanded(child: _buildRatingList(context,ratingsList)),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildTitleRow(List<Map<String,dynamic>> list) {
    return Row(
      children: [
        const Text(
          "Ratings",
          style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
        ),
        const Spacer(),
        Text(
          "${calculateOverallRating(list)}", // Reuse calculateOverallRating function
          style: const TextStyle(fontSize: 16.0),
        ),
        const Icon(Icons.star, color: Colors.amber),
      ],
    );
  }
  double calculateOverallRating(List<Map<String, dynamic>> dataList) {
  if (dataList.isEmpty) {
    return 0.0; // Handle empty list case (optional)
  }

  // Check if all elements have a 'rating' key
  if (!dataList.every((item) => item.containsKey('rating'))) {
    throw Exception("Error: Not all elements have a 'rating' key");
  }

  // Extract ratings and calculate the average
  List<double> ratings = dataList.map((item) => item['rating'] as double).toList();
  double overallRating = ratings.reduce((a, b) => a + b) / ratings.length;

  return overallRating;
}


  Widget _buildRatingList(BuildContext context,List<Map<String,dynamic>> list) {
    return ListView.builder(
      itemCount: list.length,
      itemBuilder: (context, index) {
        final rating = list[index];
        return _buildRatingItem(context, rating);
      },
    );
  }

  Widget _buildRatingItem(BuildContext context, Map<String, dynamic> rating) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            backgroundColor: Colors.grey,
            child: Text(rating['username'][0].toUpperCase()),
          ),
          const SizedBox(width: 8.0),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  rating['username'],
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Row(
                  children: [
                    for (int i = 0; i < rating['rating'].toInt(); i++)
                      const Icon(Icons.star, color: Colors.amber),
                    for (int i = rating['rating'].toInt(); i < 5; i++)
                      const Icon(Icons.star_outline, color: Colors.amber),
                  ],
                ),
                Text(rating['feedback']),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
