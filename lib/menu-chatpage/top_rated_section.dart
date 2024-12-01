import 'package:flutter/material.dart';

import 'chat_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Babysitter App',
      home: Scaffold(
        appBar: AppBar(
          title: Text('Babysitter App'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TopRatedSection(),
        ),
      ),
    );
  }
}

class TopRatedSection extends StatelessWidget {
  final List<String> avatars = ['1.jpg', '2.jpg', '3.jpg', '4.jpg', '5.jpg'];

  final List<Map<String, String>> babysitters = [
    {'name': 'Babysitter 1', 'location': '1 km away', 'rating': '4.0'},
    {'name': 'Babysitter 2', 'location': '2 km away', 'rating': '4.7'},
    {'name': 'Babysitter 3', 'location': '1.5 km away', 'rating': '4.2'},
    {'name': 'Babysitter 4', 'location': '3 km away', 'rating': '5.0'},
    {'name': 'Babysitter 5', 'location': '2.5 km away', 'rating': '4.9'},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Top Rated',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
            TextButton(
              onPressed: () {
                List<Map<String, String>> sortedBabysitters =
                    List.from(babysitters);
                sortedBabysitters.sort((a, b) {
                  double ratingA = double.parse(a['rating']!);
                  double ratingB = double.parse(b['rating']!);
                  return ratingB
                      .compareTo(ratingA); // Sort by rating in descending order
                });

                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BabysitterListPage(sortedBabysitters),
                  ),
                );
              },
              child: Text('View All'),
            ),
          ],
        ),
        SizedBox(height: 12),
        SizedBox(
          height: 80,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: avatars.length,
            separatorBuilder: (context, index) => SizedBox(width: 12),
            itemBuilder: (context, index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BabysitterDetailsPage(
                        babysitter: babysitters[index],
                      ),
                    ),
                  );
                },
                child: CircleAvatar(
                  radius: 32,
                  backgroundImage: AssetImage(avatars[index]),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class BabysitterListPage extends StatelessWidget {
  final List<Map<String, String>> babysitters;

  BabysitterListPage(this.babysitters);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Babysitters'),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list),
            onPressed: () {
              _showFilterDialog(context);
            },
          ),
        ],
      ),
      body: ListView.builder(
        itemCount: babysitters.length,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
            elevation: 2,
            margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
            child: ListTile(
              contentPadding: EdgeInsets.all(16.0),
              title: Text(
                babysitters[index]['name']!,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Location: ${babysitters[index]['location']}'),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Text('Rating:'),
                      SizedBox(width: 4),
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i <
                                  double.parse(babysitters[index]['rating']!)
                                      .floor()
                              ? Icons.star
                              : Icons.star_border,
                          color: Colors.amber,
                          size: 16,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              trailing: Icon(Icons.arrow_forward_ios, color: Colors.pink),
              leading: CircleAvatar(
                backgroundColor: Colors.purple[100],
                child: Text(
                  babysitters[index]['name']![0],
                  style: TextStyle(color: Colors.black),
                ),
              ),
              onTap: () {
                // Navigate to BabysitterDetailsPage with selected babysitter's data
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        BabysitterDetailsPage(babysitter: babysitters[index]),
                  ),
                );
              },
            ),
          );
        },
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: CircleAvatar(
        radius: 30,
        backgroundColor: Colors.pink,
        child: IconButton(
          icon: Icon(Icons.public, color: Colors.white),
          onPressed: () {},
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        shape: CircularNotchedRectangle(),
        notchMargin: 8.0,
        color: Colors.pink.shade100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: IconButton(
                icon: Icon(Icons.home, size: 30),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.chat_bubble_outline, size: 30),
                onPressed: () {
                  // Navigate to the Chat Page
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChatPage1()),
                  );
                },
              ),
            ),
            Expanded(
              child: SizedBox(),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.notifications_none, size: 30),
                onPressed: () {},
              ),
            ),
            Expanded(
              child: IconButton(
                icon: Icon(Icons.person_outline, size: 30),
                onPressed: () {},
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Filter Babysitters"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text("Top Rated Near You"),
                onTap: () {
                  Navigator.pop(context);

                  List<Map<String, String>> sortedByDistance =
                      List.from(babysitters);
                  sortedByDistance.sort((a, b) {
                    double distanceA =
                        double.parse(a['location']!.split(' ')[0]);
                    double distanceB =
                        double.parse(b['location']!.split(' ')[0]);
                    return distanceA.compareTo(distanceB);
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          BabysitterListPage(sortedByDistance),
                    ),
                  );
                },
              ),
              ListTile(
                title: Text("Entire Top Rated Babysitters"),
                onTap: () {
                  Navigator.pop(context);

                  List<Map<String, String>> sortedByRating =
                      List.from(babysitters);
                  sortedByRating.sort((a, b) {
                    double ratingA = double.parse(a['rating']!);
                    double ratingB = double.parse(b['rating']!);
                    return ratingB.compareTo(ratingA);
                  });

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => BabysitterListPage(sortedByRating),
                    ),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class BabysitterDetailsPage extends StatelessWidget {
  final Map<String, String> babysitter;

  BabysitterDetailsPage({required this.babysitter});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(babysitter['name']!),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 40,
              backgroundColor: Colors.purple[100],
              child: Text(
                babysitter['name']![0],
                style: TextStyle(fontSize: 40, color: Colors.black),
              ),
            ),
            SizedBox(height: 16),
            Text('Name: ${babysitter['name']}', style: TextStyle(fontSize: 24)),
            Text('Location: ${babysitter['location']}',
                style: TextStyle(fontSize: 18)),
            Text('Rating: ${babysitter['rating']} ⭐',
                style: TextStyle(fontSize: 18)),
            Spacer(),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Booking logic
                    },
                    child: Text("Book"),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Navigate to ChatPage
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ChatPage1(), // Open ChatPage
                        ),
                      );
                    },
                    child: Text("Chat"),
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
