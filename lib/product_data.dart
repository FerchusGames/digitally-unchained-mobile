class Product_Data{

  String? id;
  String? name;
  String? price;
  String? description;
  String? image;

  Product_Data(this.id, this.name, this.price, this.description, this.image);

  Product_Data.fromJson(Map<String, dynamic> json){
    id = json['id'].toString();
    name = json['name'];
    price = json['price'].toString();
    description = json['description'];
    image = json['image'];
  }
}