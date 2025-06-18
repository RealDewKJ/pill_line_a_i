# ExNotData Feature

## Overview

The ExNotData feature handles WebSocket connections and real-time data processing for the pill line AI system. It manages connections, message handling, navigation, and data updates.

## Architecture

### Clean Architecture Structure

```
ex_notdata/
├── core/
│   ├── constants/          # Configuration constants
│   ├── exceptions/         # Custom exceptions
│   └── di/                # Dependency injection
├── data/
│   ├── datasources/       # Remote data sources
│   ├── repositories/      # Repository implementations
│   └── services/          # WebSocket, Navigation, Message services
├── domain/
│   ├── entities/          # Business entities
│   ├── repositories/      # Repository interfaces
│   └── usecases/          # Business logic use cases
└── presentation/
    ├── bloc/              # State management
    ├── pages/             # UI pages
    └── widgets/           # Reusable widgets
```

## Key Components

### 1. Services

- **ExNotDataWebSocketService**: Manages WebSocket connections, reconnection, heartbeat, and rate limiting
- **ExNotDataNavigationService**: Handles navigation debouncing and callbacks
- **ExNotDataMessageHandler**: Processes WebSocket messages and actions

### 2. BLoC (Business Logic Component)

- **ExNotDataBloc**: Main state management for the feature
- **Events**: LoadExNotData, InitializeWebSocket, HandleWebSocketMessage, etc.
- **States**: Initial, Loading, Connected, Disconnected, Error, etc.

### 3. Use Cases

- **GetExNotDataUseCase**: Retrieves ExNotData
- **UpdateExNotDataUseCase**: Updates ExNotData

## Features

### WebSocket Management

- ✅ Automatic connection and reconnection
- ✅ Heartbeat mechanism
- ✅ Rate limiting (10 messages/second)
- ✅ Duplicate message detection
- ✅ Connection timeout handling

### Message Processing

- ✅ Action-based message handling (new, update, delete, check)
- ✅ Navigation triggering for 'new' actions
- ✅ Error handling and logging

### Navigation

- ✅ Debounced navigation (2-second delay)
- ✅ VN-based navigation to homepage
- ✅ WebSocket cleanup before navigation

### State Management

- ✅ Real-time connection status
- ✅ Loading states
- ✅ Error handling
- ✅ Data updates

## Usage

### Initialization

```dart
// Initialize DI
ExNotDataDI.init();

// Get BLoC
final bloc = ExNotDataBloc(repository: ExNotDataDI.repository);

// Set navigation callback
bloc.add(SetNavigationCallback((route, arguments) {
  // Handle navigation
}));

// Initialize WebSocket
bloc.add(InitializeWebSocket());
```

### Widget Integration

```dart
BlocProvider(
  create: (context) => ExNotDataBloc(repository: ExNotDataDI.repository),
  child: BlocBuilder<ExNotDataBloc, ExNotDataState>(
    builder: (context, state) {
      // Build UI based on state
    },
  ),
)
```

## Configuration

### WebSocket Settings

- **URL**: `ws://192.168.50.177:6789/ws/action`
- **Timeout**: 10 seconds
- **Reconnect Delay**: 2 seconds
- **Max Reconnect Attempts**: 5
- **Heartbeat Interval**: 30 seconds

### Rate Limiting

- **Max Messages/Second**: 10
- **Max Processed Messages**: 100
- **Navigation Debounce**: 2 seconds

## Error Handling

### Custom Exceptions

- **ExNotDataException**: Base exception
- **ExNotDataConnectionException**: Connection-related errors
- **ExNotDataNavigationException**: Navigation-related errors
- **ExNotDataMessageException**: Message processing errors

### Error States

- Connection failures
- Message processing errors
- Navigation errors
- WebSocket errors

## Testing

### Unit Tests

- BLoC tests for all events and states
- Service tests for WebSocket, Navigation, and Message handling
- Repository tests for data operations
- Use case tests for business logic

### Integration Tests

- End-to-end WebSocket communication
- Navigation flow testing
- Error scenario testing

## Performance Optimizations

### Memory Management

- Automatic cleanup of processed messages
- Timer cancellation on dispose
- Stream subscription management

### Rate Limiting

- Message rate limiting to prevent spam
- Navigation debouncing to prevent rapid navigation
- Duplicate message detection

### Connection Management

- Automatic reconnection with exponential backoff
- Heartbeat to maintain connection
- Graceful disconnection handling

## Dependencies

### Core Dependencies

- `flutter_bloc`: State management
- `equatable`: Value equality
- `dartz`: Functional programming
- `get_it`: Dependency injection

### Internal Dependencies

- `video_stream`: Video streaming feature
- `pill_line_controller`: Pill line controller

## Future Enhancements

### Planned Features

- [ ] Message encryption
- [ ] Connection pooling
- [ ] Offline message queuing
- [ ] Message acknowledgment
- [ ] Connection health monitoring

### Performance Improvements

- [ ] Message compression
- [ ] Connection multiplexing
- [ ] Background processing
- [ ] Memory optimization

## Contributing

### Code Style

- Follow Clean Architecture principles
- Use meaningful variable and function names
- Add comprehensive error handling
- Include unit tests for new features

### Testing

- Write tests for all new functionality
- Maintain test coverage above 80%
- Include integration tests for critical paths

### Documentation

- Update README for new features
- Add inline documentation for complex logic
- Update API documentation
