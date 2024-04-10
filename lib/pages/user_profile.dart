import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_project/bloc/events/user_events.dart';
import 'package:my_project/bloc/states/user_states.dart';
import 'package:my_project/bloc/user_bloc.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({super.key});

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Log out'),
          content: const Text('Are you sure you want to log out?'),
          actions: [
            TextButton(
              child: const Text('Cancel'),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: const Text('Log Out'),
              onPressed: () {
                context.read<UserBloc>().add(Logout());
                Navigator.of(context).pop();
                Navigator.of(context).pushReplacementNamed('/login');
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    context.read<UserBloc>().add(LoadUser());

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pushReplacementNamed('/main'),
        ),
        actions: [
          TextButton(
            onPressed: () => _showLogoutConfirmationDialog(context),
            child: const Text('Log Out', style: TextStyle(color: Colors.blue)),
          ),
        ],
      ),
      body: BlocBuilder<UserBloc, UserState>(
        builder: (context, state) {
          if (state is UserLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is UserLoaded) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const CircleAvatar(
                      radius: 50,
                      backgroundImage: NetworkImage(
                        'https://via.placeholder.com/150',),
                      backgroundColor: Colors.transparent,
                    ),
                    Text(
                      'Name: ${state.user.name}',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Email: ${state.user.email}',
                      style: const TextStyle(),
                    ),
                  ],
                ),
              ),
            );
          } else if (state is UserError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: Text('No user data available'));
        },
      ),
    );
  }
}
