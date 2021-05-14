import 'package:flutter_plants/models/visits_response.dart';

import 'package:flutter_plants/providers/visit_provider.dart';

class VisitRepository {
  VisitApiProvider _apiProvider = VisitApiProvider();

  Future<VisitsResponse> getVisits(String userId) {
    return _apiProvider.getLastVisitsByUser(userId);
  }
}
