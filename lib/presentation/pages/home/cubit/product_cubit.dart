import 'package:bloc/bloc.dart';
import 'package:waffarha/data/models/product_model.dart';
import 'package:waffarha/presentation/pages/home/cubit/product_state.dart';
import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;

class ProductCubit extends Cubit<ProductStates> {
  ProductCubit() : super(ProductInitialState());

  int _currentPage = 1;
  final int _pageSize = 10;
  String _sortBy = 'title';
  int? _filterAlbumId;
  List<Product> productList = [];

  Future<List<Product>> fetchPhotos({
    required int page,
    required int pageSize,
    String? sortBy,
    int? filterAlbumId,
  }) async {
    try {
      final allProducts = await readJsonFile('assets/file/photos.json');

      List<Product> products = productList;

      // filtering
      if (filterAlbumId != null) {
        products = products
            .where((product) => product.albumId == filterAlbumId)
            .toList();
      }

      // Apply sorting
      if (sortBy == 'albumId') {
        products.sort((a, b) => a.albumId!.compareTo(b.albumId!));
      } else if (sortBy == 'title') {
        products.sort((a, b) => a.title!.compareTo(b.title!));
      }

      // Pagination
      final startIndex = (page - 1) * pageSize;
      final endIndex = startIndex + pageSize;
      final pagedProducts = products.sublist(
        startIndex,
        endIndex > products.length ? products.length : endIndex,
      );

      return pagedProducts;
    } catch (e) {
      throw Exception('Failed to fetch photos: $e');
    }
  }

  Future<List<Product>> readJsonFile(String filePath) async {
    try {
      final input = await rootBundle.loadString(filePath);
      final jsonData = jsonDecode(input);

      jsonData.forEach((item) {
        productList.add(Product.fromJson(item));
        // print(productList);
      });

      return productList;
    } catch (e) {
      throw Exception('Failed to read JSON file: $e');
    }
  }

  Future<void> fetchProducts({
    required int page,
    required int pageSize,
    String? sortBy,
    int? filterAlbumId,
  }) async {
    emit(ProductLoadingState());
    try {
      final products = await fetchPhotos(
        page: page,
        pageSize: pageSize,
        sortBy: sortBy,
        filterAlbumId: filterAlbumId,
      );
      emit(ProductLoadedState(
        products: products,
        page: page,
        sortBy: sortBy,
        filterAlbumId: filterAlbumId,
      ));
    } catch (e) {
      emit(ProductErrorState(error: e.toString()));
    }
  }

  void loadMore() {
    _currentPage++;
    fetchProducts(
      page: _currentPage,
      pageSize: _pageSize,
      sortBy: _sortBy,
      filterAlbumId: _filterAlbumId,
    );
  }

  void updateSortOrder(String newSortBy) {
    _sortBy = newSortBy;
    _currentPage = 1;
    fetchProducts(
      page: _currentPage,
      pageSize: _pageSize,
      sortBy: _sortBy,
      filterAlbumId: _filterAlbumId,
    );
  }

  void updateFilter(int? newFilterAlbumId) {
    _filterAlbumId = newFilterAlbumId;
    _currentPage = 1;
    fetchProducts(
      page: _currentPage,
      pageSize: _pageSize,
      sortBy: _sortBy,
      filterAlbumId: _filterAlbumId,
    );
  }
}
