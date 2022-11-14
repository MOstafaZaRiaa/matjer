class FavoriteModel {
  bool? status;
  FavoriteData? data;
  String? message;

  FavoriteModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? FavoriteData.fromJson(json['data']) : null;
  }
}

class FavoriteData {
  int? currentPage;
  List<FavoriteInfo>? data = [];
  int? total;

  FavoriteData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null)
    {
      json['data'].forEach((element) {
        data!.add(FavoriteInfo.fromJson(element));
      });
    }
    total = json['total'];
  }
}

class FavoriteInfo {
  int? id;
  FavoriteProduct? product;

  FavoriteInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    product = json['product'] != null ? FavoriteProduct.fromJson(json['product']) : null;
  }
}

class FavoriteProduct {
  int?  id;
  var price;
  var oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  FavoriteProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}