/* --
      LIST OF Enums
      They cannot be created inside a class.
-- */

/// Switch of Custom Brand-Text-Size Widget
enum AppRole { admin, user }

enum TransactionType { buy, sell }

enum ProductType { single, variable }

enum ProductVisibility { published, hidden }

enum TextSizes { small, medium, large }

enum ImageType { asset, network, memory, file }

enum MediaCategory { folders, banners, brands, categories, products, users }


enum OrderStatus {
  dangXuLi,
  xacNhanDon,    
  chuanBiHang,    
  dangGiaoHang,    
  daGiaoHang,    
  huyDon         
}

extension OrderStatusExtension on OrderStatus {
  String toText() {
    switch (this) {
      case OrderStatus.dangXuLi:
        return 'Đang xử lí';
      case OrderStatus.xacNhanDon:
        return 'Chờ xác nhận';
      case OrderStatus.chuanBiHang:
        return 'Chuẩn bị hàng';
      case OrderStatus.dangGiaoHang:
        return 'Đang giao hàng';
      case OrderStatus.daGiaoHang:
        return 'Đã giao hàng';
      case OrderStatus.huyDon:
        return 'Đã hủy';
    }
  }
}

 
enum PaymentMethods { paypal, googlePay, applePay, visa, masterCard, creditCard, paystack, razorPay, paytm }
