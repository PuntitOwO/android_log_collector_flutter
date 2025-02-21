A package to collect android logs from the application using pure dart code.

## Features

Generates a log file with the logs of the application.

## Getting started

Add the package to your `pubspec.yaml` file, in the `dependencies` section.

```yaml
dependencies:
  android_log_collector: <latest_version>
```

## Usage

To use the package you just need to initialize and start the log collection.

```dart
import 'package:log_collector/log_collector.dart';

// Somewhere in your code
LogCollector.init(packageName);

// Later in your code
// File is from 'dart:io'
final File? logFile = await LogCollector.getLog();
```

## Additional information

This is a very early build, so there might be some issues and missing features.
I'm going to keep updating this package to make it more useful and stable.
Issues and PRs are welcome!