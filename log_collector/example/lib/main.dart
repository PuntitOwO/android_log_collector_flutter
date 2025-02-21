import 'dart:io' show File;

import 'package:flutter/material.dart';
import 'package:log_collector/log_collector.dart';

void main() => runApp(const MainApp());

const String packageName = "cl.puntito.log_collector_example";

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext buildContext) {
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Some buttons to generate logs
              OutlinedButton(onPressed: () => print("0"), child: Text("Log 0")),
              OutlinedButton(onPressed: () => print("1"), child: Text("Log 1")),
              // A button to collect logs
              Builder(
                builder:
                    (context) => OutlinedButton(
                      onPressed: () => collectLogs(context),
                      child: Text("Collect Logs"),
                    ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Collect logs and show a snackbar with the result
  void collectLogs(BuildContext context) async {
    print("Collecting logs...");
    LogCollector.init(packageName);
    final logFile = await LogCollector.getLog();
    if (!context.mounted) return;
    if (logFile == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Failed to collect logs")));
      return;
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("Logs collected to ${logFile.path}"),
        action: SnackBarAction(
          label: "Read",
          onPressed: () => readLogs(context, logFile),
        ),
      ),
    );
  }

  /// Read logs from a file and show them in a new page
  void readLogs(BuildContext context, File logFile) {
    Navigator.of(
      context,
    ).push(MaterialPageRoute(builder: (_) => LogDetailsPage(logFile)));
  }
}

/// A page to show the log details
class LogDetailsPage extends StatelessWidget {
  final File logFile;
  const LogDetailsPage(this.logFile, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Log details")),
      body: FutureBuilder<String>(
        future: logFile.readAsString(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          return SingleChildScrollView(child: Text(snapshot.data ?? ""));
        },
      ),
    );
  }
}
