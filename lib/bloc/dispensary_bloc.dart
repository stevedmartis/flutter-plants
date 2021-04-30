import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/dispensaries_products_response%20copy.dart';
import 'package:chat/models/products.dart';
import 'package:chat/repository/products_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductDispensaryBloc with Validators {
  final ProductsRepository _repository = ProductsRepository();

  final BehaviorSubject<List<Product>> _productDispensary =
      BehaviorSubject<List<Product>>();

  final BehaviorSubject<DispensariesProductsResponse> _dispensariesProducts =
      BehaviorSubject<DispensariesProductsResponse>();

  final _gramsRecipeController = BehaviorSubject<String>();

  Stream<String> get gramsStream => _gramsRecipeController.stream;

  BehaviorSubject<String> get gramsRecipeAdd => _gramsRecipeController.stream;

  getProductsDispensary(String productId) async {
    List<Product> response = await _repository.getProductsDispensary(productId);

    if (!_productDispensary.isClosed) _productDispensary.sink.add(response);
  }

  getDispensariesProducts(String clubId, String subId) async {
    DispensariesProductsResponse response =
        await _repository.getDispensariesProducts(clubId, subId);

    _dispensariesProducts.sink.add(response);
  }

  String get gramsRecipe => _gramsRecipeController.value;

  BehaviorSubject<DispensariesProductsResponse> get dispensariesProducts =>
      _dispensariesProducts.stream;

  Function(String) get changeGrams => _gramsRecipeController.sink.add;

  BehaviorSubject<List<Product>> get productDispensary =>
      _productDispensary.stream;

  dispose() {
    _productDispensary?.close();
    _gramsRecipeController?.close();
    _dispensariesProducts?.close();

    //  _roomsController?.close();
  }
}

final productDispensaryBloc = ProductDispensaryBloc();
