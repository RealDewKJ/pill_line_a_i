import 'dart:developer';
import '../../domain/entities/ex_notdata.dart';
import 'ex_notdata_navigation_service.dart';

class ExNotDataMessageHandler {
  final ExNotDataNavigationService _navigationService;

  ExNotDataMessageHandler(this._navigationService);

  ExNotData? handleMessage(Map<String, dynamic> message) {
    try {
      final action = message['action'] as String?;

      if (action != null) {
        return _handleAction(action, message);
      } else {
        // Handle regular data updates
        return ExNotData(
          message: message['message'] ?? '',
          type: message['type'] ?? '',
          details: Map<String, dynamic>.from(message['details'] ?? {}),
        );
      }
    } catch (e) {
      log('Error handling message: $e');
      return null;
    }
  }

  ExNotData? _handleAction(String action, Map<String, dynamic> message) {
    switch (action.toLowerCase()) {
      case 'new':
        return _handleNewAction(message);
      case 'update':
        return _handleUpdateAction(message);
      case 'delete':
        return _handleDeleteAction(message);
      case 'check':
        return _handleCheckAction(message);
      default:
        log('Unknown action: $action');
        return ExNotData(
          message: 'Unknown action received',
          type: 'error',
          details: {
            'action': action,
            'error': 'Unknown action: $action',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
    }
  }

  ExNotData? _handleNewAction(Map<String, dynamic> message) {
    try {
      final vn = message['vn'] as String?;

      if (vn != null) {
        log('Received new action with VN: $vn, navigating to homepage');

        // Trigger navigation
        _navigationService.debounceNavigation(vn);

        return ExNotData(
          message: 'New action received',
          type: 'new_action',
          details: {
            'vn': vn,
            'timestamp': DateTime.now().toIso8601String(),
            'action': 'new',
          },
        );
      } else {
        log('New action received but VN is missing');
        return ExNotData(
          message: 'VN is required for new action',
          type: 'error',
          details: {
            'error': 'VN is required for new action',
            'timestamp': DateTime.now().toIso8601String(),
          },
        );
      }
    } catch (e) {
      log('Error handling new action: $e');
      return ExNotData(
        message: 'Error processing new action',
        type: 'error',
        details: {
          'error': 'Error processing new action: $e',
          'timestamp': DateTime.now().toIso8601String(),
        },
      );
    }
  }

  ExNotData _handleUpdateAction(Map<String, dynamic> message) {
    return ExNotData(
      message: message['message'] ?? 'Update action received',
      type: 'update_action',
      details: Map<String, dynamic>.from(message),
    );
  }

  ExNotData _handleDeleteAction(Map<String, dynamic> message) {
    return ExNotData(
      message: message['message'] ?? 'Delete action received',
      type: 'delete_action',
      details: Map<String, dynamic>.from(message),
    );
  }

  ExNotData _handleCheckAction(Map<String, dynamic> message) {
    return ExNotData(
      message: 'Check action received',
      type: 'check_action',
      details: Map<String, dynamic>.from(message),
    );
  }
}
