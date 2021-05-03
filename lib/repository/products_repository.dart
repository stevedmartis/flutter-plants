import 'package:chat/models/dispensaries_products_response%20copy.dart';
import 'package:chat/models/products.dart';
import 'package:chat/models/products_dispensary.dart';
import 'package:chat/models/products_profiles_response.dart';
import 'package:chat/providers/products_provider.dart';

class ProductsRepository {
  ProductsApiProvider _apiProvider = ProductsApiProvider();

  Future<ProductsProfilesResponse> getProductsProfiles(String uid) {
    return _apiProvider.getProductsProfiles(uid);
  }

  Future<Product> getProduct(String productId) {
    return _apiProvider.getProduct(productId);
  }

  Future<DispensaryProductsProfileResponse> getProductsDispensary(
      String productId) {
    return _apiProvider.getProductsDispensary(productId);
  }

  Future<DispensariesProductsResponse> getDispensariesProducts(
      String clubId, String subId) {
    return _apiProvider.dispensariesProducts(clubId, subId);
  }
}
