import 'package:flutter/material.dart';

import '../models/checkbox_state.dart';

class UserAllergensPage extends StatefulWidget {
  const UserAllergensPage({Key? key}) : super(key: key);

  @override
  State<UserAllergensPage> createState() => _UserAllergensPageState();
}

class _UserAllergensPageState extends State<UserAllergensPage> {

  final allergens = [
    CheckBoxState(title: 'Gluten'),
    CheckBoxState(title: 'Milk'),
    CheckBoxState(title: 'Fish'),
    CheckBoxState(title: 'Crustaceans'),
    CheckBoxState(title: 'Nuts'),
    CheckBoxState(title: 'Peanuts'),
    CheckBoxState(title: 'Eggs'),
    CheckBoxState(title: 'Soybeans'),
    CheckBoxState(title: 'Celery'),
    CheckBoxState(title: 'Mustard'),
    CheckBoxState(title: 'Sesame seeds'),
    CheckBoxState(title: 'Lupin'),
    CheckBoxState(title: 'Molluscs'),
    CheckBoxState(title: 'Sulphites'),
    CheckBoxState(title: 'Corn'),
    CheckBoxState(title: 'Buckwheat'),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text('Wybór alergenów'),
    ),
    body: ListView(
      padding: EdgeInsets.all(12),
      children: [
        ...allergens.map(buildSingleCheckbox).toList(),
      ],
    ),
  );

  Widget buildSingleCheckbox(CheckBoxState checkbox) => CheckboxListTile(
    controlAffinity: ListTileControlAffinity.leading,
    activeColor: Colors.white,
    value: checkbox.value,
    title: Text(
      checkbox.title,
      style: TextStyle(fontSize: 20),
    ),
    onChanged: (value) => setState(() => checkbox.value = value!),
  );
}


