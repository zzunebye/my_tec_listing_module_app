# my_tec_listing_module_app

This repository is a demo of a interview process with TEC. 

The goal is to create a Flutter-based meeting room listing module with filtering capabilities and robust state management. This is a core booking feature that helps users discover and filter available meeting rooms.

This project depends on *dio, riverpod, flutter_hooks, json_serializable, extended_image*, and some of the packages they depend on.

## Features
- [x] API integration with the TEC REST API provided
- [x] State management with Riverpod and flutter_hooks(hooks_riverpod)  
- [x] Filtering capabilities with date, time, capacity, centres,
- [x] Responsive UI with map and list mode

## Setup

### Prerequisites

- Flutter SDK 3.32.4

### How to run

Install dependencies

```bash
flutter pub get
```

Generate code (for JSON serialization and Riverpod providers)

```bash
# For development, watch for changes
dart run build_runner watch -d

# or just build once
dart run build_runner build
```

Run the app with the access key

- Please open up simulator in prior

```bash
# For development
flutter run --dart-define=ACCESS_KEY={{your_access_key}}

# if you want to run on a specific device
flutter devices
flutter run --dart-define=ACCESS_KEY={{your_access_key}} -d {{device_id}}
```

### How to build

## Architecture overview


## Assumptions and Known issues