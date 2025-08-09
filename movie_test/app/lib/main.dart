import 'package:app/add_movies.dart';
import 'package:app/firebase_options.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData.dark().copyWith(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddMoviesScreen()),
            );
          },
          icon: Icon(Icons.add, size: 35, color: Colors.lightBlue),
        ),
        title: Center(child: Text('Movies App')),
        elevation: 12.0,
      ),
      body: SingleChildScrollView(child: MoviesInformation()),
    );
  }
}

class MoviesInformation extends StatefulWidget {
  const MoviesInformation({super.key});

  @override
  State<MoviesInformation> createState() => _MoviesInformationState();
}

class _MoviesInformationState extends State<MoviesInformation> {
  final Stream<QuerySnapshot> _moviesStream =
      FirebaseFirestore.instance.collection('Movies').snapshots();

  void addLike(String docID, int likes) {
    var newLiks = likes + 1;
    try {
      FirebaseFirestore.instance
          .collection('Movies')
          .doc(docID)
          .update({'Likes': newLiks})
          .then((value) {
            print('Base Firestore à jour');
          });
    } catch (e) {
      print(e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
      stream: _moviesStream,
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text(
              "Something went wrong:",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: Text(
              "Loading",
              style: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            ),
          );
        }

        return Column(
          children:
              snapshot.data!.docs.map((DocumentSnapshot document) {
                Map<String, dynamic> movie =
                    document.data()! as Map<String, dynamic>;
                return Padding(
                  padding: const EdgeInsets.all(10),
                  child: Row(
                    children: [
                      SizedBox(
                        width: 100,
                        child: Image.network(movie['poster']),
                      ),
                      SizedBox(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                movie['name'],
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const Text('Année de production'),
                              Text(movie['year'].toString()),
                              Row(
                                children: [
                                  for (final categorie in movie['categories'])
                                    Padding(
                                      padding: const EdgeInsets.only(right: 5),
                                      child: Chip(
                                        backgroundColor: Colors.lightBlue,
                                        label: Text(
                                          categorie,
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    padding: EdgeInsets.zero,
                                    constraints: const BoxConstraints(),
                                    iconSize: 20,
                                    onPressed: () {
                                      addLike(document.id, movie['Likes']);
                                    },
                                    icon: const Icon(Icons.favorite),
                                  ),
                                  const SizedBox(width: 10),
                                  Text(movie['Likes'].toString() + ' Likes'),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
        );
      },
    );
  }
}
