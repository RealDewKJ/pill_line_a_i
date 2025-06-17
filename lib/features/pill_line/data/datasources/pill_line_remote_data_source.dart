import '../../domain/entities/pill_line.dart';

abstract class PillLineRemoteDataSource {
  Future<List<PillLine>> getPillLines();
  Future<PillLine> getPillLineById(String id);
  Future<void> updatePillLineStatus(String id, String status);
}

class PillLineRemoteDataSourceImpl implements PillLineRemoteDataSource {
  // TODO: Implement the actual API calls here
  @override
  Future<List<PillLine>> getPillLines() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<PillLine> getPillLineById(String id) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> updatePillLineStatus(String id, String status) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
