import 'package:flutter/material.dart';

class UserProfilePage extends StatelessWidget {
  final String userName = 'Demian Foliush';
  final String userEmail = 'IoT@gmail.com';
  final String userImageUrl = 'https://via.placeholder.com/150';

  const UserProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isTablet = screenWidth >= 600;

    final titleStyle = TextStyle(
      fontSize: isTablet ? 26 : 24,
      fontWeight: FontWeight.bold,
    );
    final emailStyle = TextStyle(
      fontSize: isTablet ? 18 : 16,
      color: Colors.grey[600],
    );

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        backgroundColor: Colors.deepOrange,
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
            },
          ),
        ],
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: isTablet ?
          screenWidth * 0.1 : 16,),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              CircleAvatar(
                radius: isTablet ? 80 : 50,
                backgroundImage: NetworkImage(userImageUrl),
                backgroundColor: Colors.transparent,
              ),
              SizedBox(height: isTablet ? 30 : 20),
              Text(
                userName,
                style: titleStyle,
              ),
              SizedBox(height: isTablet ? 15 : 10),
              Text(
                userEmail,
                style: emailStyle,
              ),
              SizedBox(height: isTablet ? 30 : 20),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepOrange,
                  padding: isTablet
                      ? const EdgeInsets.symmetric(horizontal: 64, vertical: 20)
                      : null,
                ),
                child: const Text('Log Out'),
                onPressed: () {
                  // Implement log out functionality
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
