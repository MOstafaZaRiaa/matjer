class SearchModel {
  bool? status;
  SearchData? data;
  String? message;

  SearchModel.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? SearchData.fromJson(json['data']) : null;
  }
}

class SearchData {
  int? currentPage;
  List<SearchProduct>? data = [];
  int? total;

  SearchData.fromJson(Map<String, dynamic> json) {
    currentPage = json['current_page'];
    if (json['data'] != null)
    {
      json['data'].forEach((element) {
        data!.add(SearchProduct.fromJson(element));
      });
    }
    total = json['total'];
  }
}


class SearchProduct {
  int?  id;
  var price;
  int? oldPrice;
  int? discount;
  String? image;
  String? name;
  String? description;

  SearchProduct.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    price = json['price'];
    oldPrice = json['old_price'];
    discount = json['discount'];
    image = json['image'];
    name = json['name'];
    description = json['description'];
  }
}