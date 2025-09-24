import '../models/packages_response.dart';

abstract class PackagesRepository {
  Future<PackagesResponse> getActivePackages({int perPage = 10, int page = 1});
}
