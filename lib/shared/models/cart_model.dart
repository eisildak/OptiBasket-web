import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:optibasket/shared/models/product_model.dart';

part 'cart_model.freezed.dart';
part 'cart_model.g.dart';

@freezed
class CartItem with _$CartItem {
  const factory CartItem({
    required String id,
    required Product product,
    required int quantity,
    double? supplierPrice,
  }) = _CartItem;

  factory CartItem.fromJson(Map<String, dynamic> json) =>
      _$CartItemFromJson(json);
}

@freezed
class Cart with _$Cart {
  const factory Cart({
    required String id,
    required String userId,
    @Default([]) List<CartItem> items,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) = _Cart;

  factory Cart.fromJson(Map<String, dynamic> json) => _$CartFromJson(json);
}

extension CartExtension on Cart {
  double get yourTotal {
    return items.fold(
      0.0,
      (sum, item) => sum + (item.product.price * item.quantity),
    );
  }

  double get supplierTotal {
    return items.fold(
      0.0,
      (sum, item) =>
          sum + ((item.supplierPrice ?? 0) * item.quantity),
    );
  }

  double get totalSavings {
    return supplierTotal - yourTotal;
  }

  double get savingsPercentage {
    if (supplierTotal == 0) return 0;
    return (totalSavings / supplierTotal) * 100;
  }

  int get itemCount {
    return items.fold(0, (sum, item) => sum + item.quantity);
  }
}
