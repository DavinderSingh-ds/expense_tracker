// ignore_for_file: prefer_typing_uninitialized_variables

import 'dart:developer';

import 'package:expense_tracker/LoginScreen.dart';
import 'package:expense_tracker/database/SessionTable.dart';
import 'package:flutter/material.dart';

import '../database/Database2.dart';

class Profile extends StatefulWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  var _databaseprovider;

  late Future<List<SessionModel>> currentSession;

  @override
  void initState() {
    super.initState();
    _databaseprovider = Databaseprovider.instance;
    refreshData();
  }

  refreshData() {
    setState(() {
      getUserData();
    });
  }

  getUserData() {
    setState(() {
      currentSession = _databaseprovider.getAllSessionDetail();
      log('Data from categoryList $currentSession');
    });
  }

  void _showHeroAnimation(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          body: Center(
            child: Hero(
              tag: 'hero-Animation-on-profile',
              child: Image.asset('images/profile.jpg'),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.lightBlueAccent,
      appBar: AppBar(
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black87, fontSize: 16),
        ),
        leading: const Icon(
          Icons.menu,
          color: Colors.black87,
        ),
        backgroundColor: Colors.white,
      ),
      resizeToAvoidBottomInset: false,
      body: Column(
        children: [
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                        image: const DecorationImage(
                          image: NetworkImage(
                              'https://www.pixelstalk.net/wp-content/uploads/2016/07/Free-Download-3D-HD-Nature-Backgrounds-1.jpg'),
                          fit: BoxFit.cover,
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: FutureBuilder(
                        future: currentSession,
                        builder: (BuildContext context,
                            AsyncSnapshot<List<SessionModel>> snapshot) {
                          if (snapshot.hasData) {
                            log('Length of transaction $snapshot.data?.length');
                            return ListView.builder(
                              itemCount: snapshot.data?.length,
                              itemBuilder: (BuildContext context, int index) {
                                SessionModel dogModel = snapshot.data![index];

                                return Column(
                                  children: [
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    GestureDetector(
                                      child: Hero(
                                        transitionOnUserGestures: mounted,
                                        tag: 'hero-animation_tag',
                                        child: const CircleAvatar(
                                          radius: 50,
                                          backgroundImage:
                                              AssetImage('images/cover.jpg'),
                                        ),
                                      ),
                                      onTap: () => {
                                        _showHeroAnimation(context),
                                      },
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Container(
                                      width: 200,
                                      decoration: const BoxDecoration(
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(4),
                                        ),
                                        color: Colors.white,
                                      ),
                                      child: Column(
                                        children: [
                                          Text(
                                            dogModel.userName,
                                            style: const TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 14,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                );
                              },
                            );
                          } else {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: const [
                                  Text('Please Wait.....'),
                                  SizedBox(height: 30),
                                  CircularProgressIndicator(),
                                ],
                              ),
                            );
                          }
                        },
                      ),
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 10,
                        right: 10,
                        top: 15,
                      ),
                      child: Container(
                        height: MediaQuery.of(context).size.height,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: Colors.blue,
                          borderRadius: BorderRadius.all(
                            Radius.circular(8),
                          ),
                        ),
                        child: SingleChildScrollView(
                          scrollDirection: Axis.vertical,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 10,
                              ),
                              Wrap(
                                children: [
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        MaterialButton(
                                          color: Colors.grey[200],
                                          onPressed: () async {
                                            await _databaseprovider
                                                .clearSession();
                                            Navigator.pushReplacement(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    const LoginScreen(),
                                              ),
                                            );
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content:
                                                    Text('User Logged Out'),
                                                duration: Duration(seconds: 1),
                                              ),
                                            );
                                          },
                                          child: const Icon(
                                            Icons.logout,
                                            color: Colors.red,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
