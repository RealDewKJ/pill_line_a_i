import '../../domain/entities/ex_notdata.dart';

abstract class ExNotDataRemoteDataSource {
  Future<ExNotData> getExNotData();
  Future<void> updateExNotData(ExNotData data);
}

class ExNotDataRemoteDataSourceImpl implements ExNotDataRemoteDataSource {
  // TODO: Implement the actual API calls here
  @override
  Future<ExNotData> getExNotData() async {
    // TODO: Implement API call
    throw UnimplementedError();
  }

  @override
  Future<void> updateExNotData(ExNotData data) async {
    // TODO: Implement API call
    throw UnimplementedError();
  }
}
