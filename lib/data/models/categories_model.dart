class CategoriesModel {
  bool? status;
  CategoriesDataModel? data;
  CategoriesModel.fromjson(Map<String, dynamic> json) {
    status = json['status'];
    data = CategoriesDataModel.fromjson(json['data']);
  }
}

class CategoriesDataModel {
  List<CategoriesInfo> data = [];
  CategoriesDataModel.fromjson(Map<String, dynamic> json) {
    json['data'].forEach((element) {
      data.add(CategoriesInfo.fromjson(element));
    });
  }
}

class CategoriesInfo {
  String? name;
  String? image;
  CategoriesInfo.fromjson(Map<String, dynamic> json) {
    name = json['name'];
    image = json['image'];
  }
}