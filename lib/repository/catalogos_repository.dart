import 'package:leafety/models/catalogo.dart';
import 'package:leafety/models/catalogos_products_response.dart';
import 'package:leafety/models/catalogos_response.dart';
import 'package:leafety/providers/catalogos_provider.dart';

class CatalogosRepository {
  CatalogosApiProvider _apiProvider = CatalogosApiProvider();

  Future<CatalogosProductsResponse> getCatalogosProductsUser(
      String userId, String userAuthId) {
    return _apiProvider.getCatalogosProductsUser(userId, userAuthId);
  }

  Future<CatalogosResponse> getMyCatalogos(String userId) {
    return _apiProvider.getMyCatalogos(userId);
  }

  Future<CatalogosProductsResponse> getMyCatalogosProducts(String userId) {
    return _apiProvider.getMyCatalogosProducts(userId);
  }

  Future<Catalogo> getCatalogo(String catalogoId) {
    return _apiProvider.getCatalogo(catalogoId);
  }
}
