import 'dart:async';
import 'package:chat/bloc/validators.dart';
import 'package:chat/models/products.dart';
import 'package:chat/repository/products_repository.dart';
import 'package:rxdart/rxdart.dart';

class ProductDispensaryBloc with Validators {
  final ProductsRepository _repository = ProductsRepository();

  final BehaviorSubject<List<Product>> _productDispensary =
      BehaviorSubject<List<Product>>();
  final _gramsRecipeController = BehaviorSubject<String>();

  Stream<String> get gramsStream => _gramsRecipeController.stream;

  BehaviorSubject<String> get gramsRecipeAdd => _gramsRecipeController.stream;
  getProductsDispensary(String productId) async {
    List<Product> response = await _repository.getProductsDispensary(productId);

    if (!_productDispensary.isClosed) _productDispensary.sink.add(response);
  }

  String get gramsRecipe => _gramsRecipeController.value;

  Function(String) get changeGrams => _gramsRecipeController.sink.add;

  BehaviorSubject<List<Product>> get productDispensary =>
      _productDispensary.stream;

  dispose() {
    _productDispensary?.close();
    _gramsRecipeController?.close();

    //  _roomsController?.close();
  }
}

final productDispensaryBloc = ProductDispensaryBloc();
