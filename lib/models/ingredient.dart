import 'dart:ffi';

class Ingredient{
  Int Code;
  String Name;
  Int Quantity;

  Ingredient({
    required this.Code,
    required this.Name,
    required this.Quantity
  });

  Map<String, dynamic> toMap(){
    return {
      'Code': Code,
      'Name': Name,
      'Quantity': Quantity
    };
  }

  factory Ingredient.fromMap(Map<String, dynamic> map){
    return Ingredient(
      Code: map['Code'],
      Name: map['Name'],
      Quantity: map['Quantity']
    );
  }
}