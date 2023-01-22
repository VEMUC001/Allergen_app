import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllergensPage extends StatefulWidget {
  const AllergensPage({Key? key}) : super(key: key);

  @override
  State<AllergensPage> createState() => _AllergensPageState();
}

class _AllergensPageState extends State<AllergensPage> {

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser!;
    final uid = user.uid;
    Stream<QuerySnapshot> allergens = FirebaseFirestore.instance.collection(
        'Users').doc(user.uid).collection('Allergens').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybór alergenów'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final user = FirebaseAuth.instance.currentUser!;
          final uid = user.uid;
          final allergensExist = await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Allergens").get().then((snapshot) => snapshot.docs.length > 0);
          if (allergensExist) {
            print("Allergens collection already exists!");
          } else {
            final allergens = [
              {"name": "Gluten", "isChecked": false},
              {"name": "Mleko", "isChecked": false},
              {"name": "Ryby", "isChecked": false},
              {"name": "Skorupiaki", "isChecked": false},
              {"name": "Orzechy", "isChecked": false},
              {"name": "Orzeszki ziemne", "isChecked": false},
              {"name": "Jajka", "isChecked": false},
              {"name": "Soja", "isChecked": false},
              {"name": "Seler", "isChecked": false},
              {"name": "Musztarda", "isChecked": false},
              {"name": "Sezam", "isChecked": false},
              {"name": "Łubin", "isChecked": false},
              {"name": "Małże", "isChecked": false},
              {"name": "Siarczyny", "isChecked": false},
              {"name": "Kukurydza", "isChecked": false},
              {"name": "Gryka", "isChecked": false}
            ];
            for (var i = 0; i < allergens.length; i++) {
              await FirebaseFirestore.instance.collection("Users").doc(uid).collection("Allergens").add({
                "name": allergens[i]["name"],
                "isChecked": allergens[i]["isChecked"]
              });
            }
            print("Allergens collection created successfully!");
          }
        },
        child: const Icon(Icons.add),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: allergens,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text("Coś poszło nie tak!");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Text('Ładowanie...');
            }
            return ListView.builder(
              itemCount: snapshot.data!.docs.length,
              itemBuilder: (context, index) {
                DocumentSnapshot document = snapshot.data!.docs[index];
                Map<String, dynamic> data = document.data() as Map<
                    String,
                    dynamic>;
                return CheckboxListTile(
                    controlAffinity: ListTileControlAffinity.leading,
                    activeColor: Colors.white,
                    title: Text(
                      data['name'],
                      style: TextStyle(fontSize: 20),
                    ),
                    value: data['isChecked'],
                    onChanged: (bool? value) {
                      FirebaseFirestore.instance.collection('Users').doc(
                          document.id).update(
                        {'isChecked': value!},
                      );
                    }
                );
              },
            );
          },
      ),
    );
  }
}


