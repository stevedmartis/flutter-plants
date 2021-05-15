import 'dart:async';
import 'package:leafety/bloc/validators.dart';
import 'package:leafety/models/dispensaries_products_response%20copy.dart';
import 'package:leafety/models/product_principal.dart';
import 'package:leafety/models/products.dart';
import 'package:leafety/models/products_dispensary.dart';
import 'package:leafety/repository/products_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductDispensaryBloc with Validators {
  final ProductsRepository _repository = ProductsRepository();

  final BehaviorSubject<DispensaryProductsProfileResponse> _productDispensary =
      BehaviorSubject<DispensaryProductsProfileResponse>();

  final BehaviorSubject<DispensariesProductsResponse> _dispensariesProducts =
      BehaviorSubject<DispensariesProductsResponse>();

  final BehaviorSubject<List<ProductProfile>> _productsProfilesDispensary =
      BehaviorSubject<List<ProductProfile>>();

  final BehaviorSubject<List<Product>> _productsDispensary =
      BehaviorSubject<List<Product>>();

  final _gramsRecipeController = BehaviorSubject<String>();

  Stream<String> get gramsStream => _gramsRecipeController.stream;

  BehaviorSubject<String> get gramsRecipeAdd => _gramsRecipeController.stream;

  getProductsDispensary(String productId) async {
    DispensaryProductsProfileResponse response =
        await _repository.getProductsDispensary(productId);

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

  BehaviorSubject<List<ProductProfile>> get productsProfileDispensary =>
      _productsProfilesDispensary.stream;

  BehaviorSubject<List<Product>> get productsDispensary =>
      _productsDispensary.stream;

  dispose() {
    _productsProfilesDispensary?.close();
    _productDispensary?.close();
    _productsDispensary?.close();
    _gramsRecipeController?.close();
    _dispensariesProducts?.close();

    //  _roomsController?.close();
  }
}

final productDispensaryBloc = ProductDispensaryBloc();
