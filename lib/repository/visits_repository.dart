import 'package:leafety/models/visits_response.dart';

import 'package:leafety/providers/visit_provider.dart';

class VisitRepository {
  VisitApiProvider _apiProvider = VisitApiProvider();

  Future<VisitsResponse> getVisits(String userId) {
    return _apiProvider.getLastVisitsByUser(userId);
  }
}
