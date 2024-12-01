import 'package:flutter/material.dart';

class ReviewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Review Ratings'),
        backgroundColor: Colors.pink.shade100,
        centerTitle: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {},
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () {},
          )
        ],
      ),
      body: Container(
        color: Colors.pink.shade50,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              UserHeader(),
              SizedBox(height: 10),
              RatingFilter(),
              SizedBox(height: 10),
              Expanded(child: ReviewList()),
            ],
          ),
        ),
      ),
    );
  }
}

class UserHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.pink.shade100,
        borderRadius: BorderRadius.circular(10),
      ),
      padding: EdgeInsets.all(16),
      child: Row(
        children: [
          CircleAvatar(
            backgroundImage:
                AssetImage('assets/photo_female_1.jpg'), // Add a local image
            radius: 30,
          ),
          SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Maricris Dela Cerna',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text('Ratings and Reviews for Babysitter'),
            ],
          )
        ],
      ),
    );
  }
}

class RatingFilter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        FilterButton('All', true),
        FilterButton('5', false),
        FilterButton('4', false),
        FilterButton('3', false),
        FilterButton('2', false),
        FilterButton('1', false),
      ],
    );
  }
}

class FilterButton extends StatelessWidget {
  final String label;
  final bool selected;

  FilterButton(this.label, this.selected);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: selected ? Colors.pink.shade300 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.pink.shade300),
      ),
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.pink.shade300,
        ),
      ),
    );
  }
}

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: 2, // Add the number of reviews you want
      itemBuilder: (context, index) {
        return ReviewItem();
      },
    );
  }
}

class ReviewItem extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                CircleAvatar(
                  backgroundImage:
                      AssetImage('assets/ajimboy.jpeg'), // Add a local image
                  radius: 30,
                ),
                SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'James Boy Boliwag',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Row(
                      children: [
                        Icon(Icons.star, color: Colors.pink),
                        Icon(Icons.star, color: Colors.pink),
                        Icon(Icons.star, color: Colors.pink),
                        Icon(Icons.star, color: Colors.pink),
                        Icon(Icons.star_half, color: Colors.pink),
                        SizedBox(width: 5),
                        Text('4.5'),
                      ],
                    ),
                  ],
                )
              ],
            ),
            SizedBox(height: 10),
            Text(
              'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
              'Magna nisi sem in ut adipiscing egestas. Dolor posuere '
              'vel lacus facilisi non. Lorem ultrices mi orci sed...',
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                Expanded(
                  child: Image.asset(
                      'assets/babysitter1.jpg'), // Add a local image
                ),
                SizedBox(width: 10),
                Expanded(
                  child: Image.asset(
                      'assets/babysitter2.jpg'), // Add a local image
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
