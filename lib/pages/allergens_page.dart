import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';


class AllergensPage extends StatefulWidget {
  const AllergensPage({Key? key}) : super(key: key);

  @override
  State<AllergensPage> createState() => _AllergensPageState();
}

class _AllergensPageState extends State<AllergensPage> {

  @override
  Widget build(BuildContext context) {
    Stream<QuerySnapshot> allergens = FirebaseFirestore.instance.collection(
        'allergens').snapshots();
    return Scaffold(
      appBar: AppBar(
        title: Text('Wybór alergenów'),
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
                    value: data['value'],
                    onChanged: (bool? value) {
                      FirebaseFirestore.instance.collection('allergens').doc(
                          document.id).update(
                        {'value': value!},
                      );
                    }
                );
              },
            );
          }
      ),
    );
  }
}


