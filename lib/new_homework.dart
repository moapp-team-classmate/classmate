import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: NewHomeworkPage(),
    );
  }
}

class NewHomeworkPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('ClassMate'),
      ),
      body: Center(),
      bottomNavigationBar: BottomAppBar(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.home_outlined,
                semanticLabel: 'home',
              ),
            ),
            IconButton(
              onPressed: () {
                GoRouter.of(context).go('/dashboard');
              },
              icon: Icon(
                Icons.dashboard_outlined,
                semanticLabel: 'my class',
              ),
            ),
            IconButton(
              onPressed: () {
                GoRouter.of(context).go('/new_homework');
              },
              icon: Icon(
                Icons.queue,
                semanticLabel: 'new homework',
              ),
            ),
            //TODO if user have profile picture change it
            IconButton(
              onPressed: () {
                GoRouter.of(context).go('/profile');
              },
              icon: Icon(
                Icons.account_circle_outlined,
                semanticLabel: 'profile',
              ),
            ),
          ],
        ),
      )
    );
  }
}
