# Home Feature - BLoC Pattern Implementation

## Overview

This feature implements the BLoC (Business Logic Component) pattern for managing home page functionality and pill line operations.

## Architecture

### BLoCs

- **HomeBloc**: Manages home page data and settings
- **PillLineBloc**: Manages pill line operations, drug fetching, and WebSocket communication

### Key Features

#### HomeBloc

- Fetches home data from API
- Updates home settings
- Manages loading states and errors

#### PillLineBloc

- Fetches drug items from VN (Visit Number)
- Manages pill line status updates
- Handles WebSocket communication for drug data submission
- Detects when patient VN is not found and shows appropriate dialog
- **NEW**: Integrated socket communication functions moved from SocketController
- **NEW**: Updated JSON format for drug data submission

## Events and States

### HomeBloc Events

- `LoadHomeData`: Loads home page data
- `UpdateHomeSettings`: Updates home settings

### HomeBloc States

- `HomeInitial`: Initial state
- `HomeLoading`: Loading state
- `HomeLoaded`: Data loaded successfully
- `HomeError`: Error state

### PillLineBloc Events

- `FetchDrugFromVN`: Fetches drug items for a specific VN
- `HandleChangedStatusMessage`: Handles status change messages
- `HandleFetchedDrugitemsMessage`: Handles drug items fetched messages
- `HandleFinishedMessage`: Handles completion messages
- `UpdatePillLineStatus`: Updates pill line status

### PillLineBloc States

- `PillLineInitial`: Initial state
- `PillLineLoading`: Loading state
- `PillLineLoaded`: Data loaded successfully
- `PillLineNoPatientFound`: Patient VN not found
- `PillLineError`: Error state
- `PillLineFinished`: Process completed

## WebSocket Integration

### Drug Data Submission Format

The BLoC now handles WebSocket communication with the following JSON format:

```json
{
  "action": "submit_drug_list",
  "vn": "650000000",
  "total": 2,
  "drug": [
    {
      "icode": "xxxx1",
      "tmt": "123454",
      "name": "testt"
    },
    {
      "icode": "xxxx2",
      "tmt": "123454",
      "name": "testt"
    }
  ]
}
```

### Functions Moved from SocketController

- `_sendDrugDataToBackend()`: Sends drug data to backend via WebSocket
- `_sendMessage()`: Sends messages via WebSocket

## Usage

### Basic Usage

```dart
// In a widget
BlocProvider(
  create: (context) => getIt<HomeBloc>()..add(LoadHomeData()),
  child: BlocBuilder<HomeBloc, HomeState>(
    builder: (context, state) {
      // Handle states
    },
  ),
)
```

### Multiple BLoCs

```dart
MultiBlocProvider(
  providers: [
    BlocProvider<HomeBloc>(
      create: (context) => getIt<HomeBloc>(),
    ),
    BlocProvider<PillLineBloc>(
      create: (context) => getIt<PillLineBloc>(),
    ),
  ],
  child: HomePageWidget(),
)
```

## Dependencies

- `flutter_bloc`: BLoC pattern implementation
- `equatable`: Value equality for states and events
- `get_it`: Dependency injection

## Notes

- The PillLineBloc now manages all pill line related operations including WebSocket communication
- SocketController is still used for basic WebSocket connection management
- JSON format has been updated to use `submit_drug_list` action and proper drug item structure
