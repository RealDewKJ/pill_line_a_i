import '../../domain/entities/ex_notdata.dart';

abstract class ExNotDataRemoteDataSource {
  Future<ExNotData> getExNotData();
  Future<void> updateExNotData(ExNotData data);
}

class ExNotDataRemoteDataSourceImpl implements ExNotDataRemoteDataSource {
  @override
  Future<ExNotData> getExNotData() async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 500));

    // Return mock data for now
    // TODO: Replace with actual API call
    return ExNotData(
      message: 'Initial data loaded',
      type: 'initial',
      details: {
        'timestamp': DateTime.now().toIso8601String(),
        'status': 'connected',
      },
    );
  }

  @override
  Future<void> updateExNotData(ExNotData data) async {
    // Simulate API call delay
    await Future.delayed(Duration(milliseconds: 300));

    // TODO: Replace with actual API call
    // For now, just simulate successful update
    print('Updating ExNotData: ${data.message}');
  }
}
