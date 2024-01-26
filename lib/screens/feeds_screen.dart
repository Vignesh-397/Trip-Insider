import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:tripinsider/resources/auth_methods.dart';
import 'package:tripinsider/screens/hotels/hotels_screen.dart';
import 'package:tripinsider/screens/login_screen.dart';
import 'package:tripinsider/utils/colorsScheme.dart';
import 'package:tripinsider/widgets/post_card.dart';
import 'package:google_fonts/google_fonts.dart';

class FeedsScreen extends StatefulWidget {
  const FeedsScreen({super.key});

  @override
  State<FeedsScreen> createState() => _FeedsScreenState();
}

class _FeedsScreenState extends State<FeedsScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(
            Icons.menu,
            color: mobileBackgroundColor,
          ),
          onPressed: () {
            _scaffoldKey.currentState!.openDrawer();
          },
        ),
        title: Text(
          'TRIPINSIDER',
          style: GoogleFonts.pacifico(
            color: mobileBackgroundColor,
            fontWeight: FontWeight.bold,
          ),
          // style: TextStyle(
          //   color: mobileBackgroundColor,
          //   fontWeight: FontWeight.bold,
          // ),
        ),
        backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => HotelListScreen()),
          );
        },
        child: const Icon(Icons.hotel),
      ),
      backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
      drawer: Drawer(
        backgroundColor: const Color.fromARGB(255, 208, 220, 253),
        child: Column(
          children: [
            DrawerHeader(
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: mobileBackgroundColor,
              ),
              child: Container(
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 150,
                      decoration: const BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage(
                              'assets/images/TripInsiderLogo.png',
                            ),
                            fit: BoxFit.contain),
                      ),
                    ),
                    // const Text(
                    //   'TRIPINSIDER',
                    //   style: TextStyle(
                    //     fontSize: 24,
                    //     color: Colors.white, // Replace with your desired color
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: const Icon(
                Icons.hotel,
                size: 26,
                color: Colors.black,
              ),
              title: const Text(
                'Hotels',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => HotelListScreen()));
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.description,
                size: 26,
                color: Colors.black,
              ),
              title: const Text(
                'About Us',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
                      title: const Text(
                        'TRIPINSIDER',
                        style: TextStyle(
                            color: mobileBackgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'TRIPINSIDER is a travel mate app that helps the other user to visualize and able to make choice on  the tourist spot they want to visit.',
                        style: TextStyle(
                          color: mobileBackgroundColor,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            ListTile(
              leading: const Icon(
                Icons.call,
                size: 26,
                color: Colors.black,
              ),
              title: const Text(
                'Contact Us',
                style: TextStyle(
                  fontSize: 24,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialog(
                      backgroundColor: const Color.fromRGBO(225, 232, 252, 1),
                      title: const Text(
                        'Contact Us',
                        style: TextStyle(
                            color: mobileBackgroundColor,
                            fontWeight: FontWeight.bold),
                      ),
                      content: const Text(
                        'contact us @ tripinsider@gmail.com',
                        style: TextStyle(
                          color: mobileBackgroundColor,
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('OK'),
                        ),
                      ],
                    );
                  },
                );
              },
            ),
            Expanded(
              child: Container(), // Spacer to push Log Out to the bottom
            ),
            ListTile(
              leading: const Icon(
                Icons.logout_outlined,
                size: 18,
                color: Colors.black,
              ),
              title: const Text(
                'Log Out',
                style: TextStyle(
                  fontSize: 17,
                  color: Colors.black,
                ),
              ),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text('Log Out'),
                      content: const Text('Are you sure you want to log out?'),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () async {
                            await AuthMethods().signOut();
                            if (context.mounted) {
                              Navigator.of(context).pushReplacement(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            }
                          },
                          child: const Text(
                            'Log Out',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                      ],
                    );
                  },
                );
              },
            )
          ],
        ),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('posts')
            .orderBy('datePublished', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (!snapshot.hasData || (snapshot.data?.docs ?? []).isEmpty) {
            return const Center(
              child: Text('No posts found!'),
            );
          }

          if (snapshot.hasError) {
            return const Center(
              child: Text('Something went wrong.'),
            );
          }

          return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                return Container(
                  child: PostCard(
                    snap: snapshot.data!.docs[index].data(),
                  ),
                );
              });
        },
      ),
    );
  }
}
