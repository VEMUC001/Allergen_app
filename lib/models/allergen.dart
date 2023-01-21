import '../net/firestore.dart';

class Allergen {
  late String id;
  late String name;
  late bool isChecked;
  late bool isSaved;

  Allergen(String id, String name, bool value, bool isSaved) {
    this.id = id;
    this.name = name;
    this.isChecked = false;
    this.isSaved = false;
  }

  getName() {
    return this.name;
  }

  toJson() {
    return {'name': this.name};
  }

  void save() {
    if (this.id == "")
      addDocToUser('Allergen', this.toJson()).then((value) {
        this.id = value;
        print(this.id);
      });
    else
      updateDocToUser('Allergen', this.id, this.toJson());
    isSaved = true;
  }
}