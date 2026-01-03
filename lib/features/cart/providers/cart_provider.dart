import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:optibasket/features/auth/providers/auth_provider.dart';
import 'package:optibasket/shared/models/cart_model.dart';
import 'package:optibasket/shared/models/product_model.dart';

// Cart State
class CartState {
  final Cart? cart;
  final bool isLoading;
  final String? error;

  CartState({
    this.cart,
    this.isLoading = false,
    this.error,
  });

  CartState copyWith({
    Cart? cart,
    bool? isLoading,
    String? error,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}

// Cart Notifier
class CartNotifier extends StateNotifier<CartState> {
  CartNotifier() : super(CartState()) {
    _initializeCart();
  }

  void _initializeCart() {
    // Initialize with empty cart
    state = CartState(
      cart: Cart(
        id: 'temp_cart_${DateTime.now().millisecondsSinceEpoch}',
        userId: 'current_user',
        items: [],
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> addToCart(Product product, {int quantity = 1, double? supplierPrice}) async {
    if (state.cart == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Check if product already exists in cart
      final existingIndex = state.cart!.items.indexWhere(
        (item) => item.product.id == product.id,
      );

      List<CartItem> updatedItems;

      if (existingIndex >= 0) {
        // Update quantity if product exists
        updatedItems = List.from(state.cart!.items);
        final existingItem = updatedItems[existingIndex];
        updatedItems[existingIndex] = CartItem(
          id: existingItem.id,
          product: product,
          quantity: existingItem.quantity + quantity,
          supplierPrice: supplierPrice ?? existingItem.supplierPrice,
        );
      } else {
        // Add new item
        updatedItems = [
          ...state.cart!.items,
          CartItem(
            id: 'item_${DateTime.now().millisecondsSinceEpoch}',
            product: product,
            quantity: quantity,
            supplierPrice: supplierPrice,
          ),
        ];
      }

      final updatedCart = Cart(
        id: state.cart!.id,
        userId: state.cart!.userId,
        items: updatedItems,
        createdAt: state.cart!.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        cart: updatedCart,
        isLoading: false,
      );

      // TODO: Sync with backend API
      // await _cartService.updateCart(updatedCart);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to add to cart: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> updateQuantity(String itemId, int newQuantity) async {
    if (state.cart == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      if (newQuantity <= 0) {
        await removeFromCart(itemId);
        return;
      }

      final updatedItems = state.cart!.items.map((item) {
        if (item.id == itemId) {
          return CartItem(
            id: item.id,
            product: item.product,
            quantity: newQuantity,
            supplierPrice: item.supplierPrice,
          );
        }
        return item;
      }).toList();

      final updatedCart = Cart(
        id: state.cart!.id,
        userId: state.cart!.userId,
        items: updatedItems,
        createdAt: state.cart!.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        cart: updatedCart,
        isLoading: false,
      );

      // TODO: Sync with backend
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update quantity: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> updateSupplierPrice(String itemId, double supplierPrice) async {
    if (state.cart == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedItems = state.cart!.items.map((item) {
        if (item.id == itemId) {
          return CartItem(
            id: item.id,
            product: item.product,
            quantity: item.quantity,
            supplierPrice: supplierPrice,
          );
        }
        return item;
      }).toList();

      final updatedCart = Cart(
        id: state.cart!.id,
        userId: state.cart!.userId,
        items: updatedItems,
        createdAt: state.cart!.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        cart: updatedCart,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to update supplier price: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> removeFromCart(String itemId) async {
    if (state.cart == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final updatedItems = state.cart!.items
          .where((item) => item.id != itemId)
          .toList();

      final updatedCart = Cart(
        id: state.cart!.id,
        userId: state.cart!.userId,
        items: updatedItems,
        createdAt: state.cart!.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        cart: updatedCart,
        isLoading: false,
      );

      // TODO: Sync with backend
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to remove from cart: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> clearCart() async {
    if (state.cart == null) return;

    state = state.copyWith(isLoading: true, error: null);

    try {
      final clearedCart = Cart(
        id: state.cart!.id,
        userId: state.cart!.userId,
        items: [],
        createdAt: state.cart!.createdAt,
        updatedAt: DateTime.now(),
      );

      state = state.copyWith(
        cart: clearedCart,
        isLoading: false,
      );

      // TODO: Sync with backend
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to clear cart: ${e.toString()}',
        isLoading: false,
      );
    }
  }

  Future<void> fetchCart() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      // TODO: Fetch from backend API
      // final response = await _cartService.getCart();
      // state = state.copyWith(cart: response.data, isLoading: false);
      
      state = state.copyWith(isLoading: false);
    } catch (e) {
      state = state.copyWith(
        error: 'Failed to fetch cart: ${e.toString()}',
        isLoading: false,
      );
    }
  }
}

// Cart Provider
final cartProvider = StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier();
});

// Cart Items Count Provider
final cartItemsCountProvider = Provider<int>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.itemCount ?? 0;
});

// Cart Total Provider
final cartTotalProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.yourTotal ?? 0.0;
});

// Cart Savings Provider
final cartSavingsProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.totalSavings ?? 0.0;
});

// Cart Savings Percentage Provider
final cartSavingsPercentageProvider = Provider<double>((ref) {
  final cart = ref.watch(cartProvider).cart;
  return cart?.savingsPercentage ?? 0.0;
});
