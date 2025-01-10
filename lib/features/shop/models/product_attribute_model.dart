// ignore_for_file: public_member_api_docs, sort_constructors_first
class ProductAttributeModel {
  String ma;
  String ten;
  List<String> giaTriList;
  
  ProductAttributeModel({
    this.ma = '',
    this.ten = '',
    List<String>? giaTriList,
  }) : giaTriList = giaTriList ?? [];

  Map<String, dynamic> toJson() {
    return {
      "Name": ten,
      "Values": giaTriList,
    };
  }

  factory ProductAttributeModel.fromJson(Map<String, dynamic> document) {
    final data = document;
    if (data.isEmpty) {
      return ProductAttributeModel();
    }
    
    return ProductAttributeModel(
      ten: data["Name"] ?? "",
      giaTriList: data.containsKey("Values") 
          ? List<String>.from(data["Values"]) 
          : [],
    );
  }

  // Helper method to update values from comma-separated string
  void capNhatGiaTriTuChuoi(String chuoiGiaTri) {
    if (chuoiGiaTri.isEmpty) {
      giaTriList = [];
      return;
    }
    giaTriList = chuoiGiaTri
        .split(',')
        .map((e) => e.trim())
        .where((e) => e.isNotEmpty)
        .toList();
  }
}
