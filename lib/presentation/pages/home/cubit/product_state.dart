import 'package:waffarha/data/models/product_model.dart';

abstract class ProductStates {}

class ProductInitialState extends ProductStates {}

class ProductLoadingState extends ProductStates {}

class ProductLoadedState extends ProductStates {
  final List<Product> products;
  final int? page;
  final String? sortBy;
  final int? filterAlbumId;

  ProductLoadedState({
    required this.products,
    required this.page,
    this.sortBy,
    this.filterAlbumId,
  });
}

class ProductErrorState extends ProductStates {
  final String? error;

  ProductErrorState({required this.error});
}
