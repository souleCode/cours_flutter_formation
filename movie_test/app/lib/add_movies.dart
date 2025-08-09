import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:multiselect/multiselect.dart';

class AddMoviesScreen extends StatefulWidget {
  const AddMoviesScreen({super.key});

  @override
  State<AddMoviesScreen> createState() => _AddMoviesScreenState();
}

class _AddMoviesScreenState extends State<AddMoviesScreen> {
  final nameController = TextEditingController();
  final directorController = TextEditingController();
  final yearController = TextEditingController();
  final posterController = TextEditingController();
  List<String> categories = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Center(child: Text('Add Movie'))),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Nom: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: nameController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Année: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: yearController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ListTile(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(4),
                side: const BorderSide(color: Colors.white30, width: 1.5),
              ),
              title: Row(
                children: [
                  const Text('Poster: '),
                  Expanded(
                    child: TextField(
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                      ),
                      controller: posterController,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            DropDownMultiSelect(
              onChanged: (List<String> x) {
                setState(() {
                  categories = x;
                });
              },
              options: const [
                'Action',
                'Science-fition',
                'Aventure',
                'Comédie',
              ],
              selectedValues: categories,
              whenEmpty: 'Categorie',
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                backgroundColor: Colors.lightBlue,
              ),
              onPressed: () {
                FirebaseFirestore.instance.collection('Movies').add({
                  'name': nameController.value.text,
                  'year': yearController.value.text,
                  'poster': posterController.value.text,
                  'categories': categories,
                  'Likes': 0,
                });
                Navigator.pop(context);
              },
              child: const Text('Ajouter', style: TextStyle(fontSize: 25)),
            ),
          ],
        ),
      ),
    );
  }
}
