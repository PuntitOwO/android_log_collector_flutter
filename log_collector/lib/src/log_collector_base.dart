import 'dart:io';

/// A class that collects logs from a given package name.
class LogCollector {
  /// The package name of the app to collect logs from.
  static late String _package;

  /// Initializes the package name.
  static void init(String packageName) => LogCollector._package = packageName;

  /// Returns a temp [Directory] to store the logs.
  static Future<Directory> getLogDir() async {
    final directory = await Directory.systemTemp.createTemp(_package);
    return directory;
  }

  /// Returns the PID of the app.
  static Future<String?> getPidOf() async {
    final pid = await Process.run("pidof", <String>["-s", _package]);
    if (pid.exitCode != 0) return null;
    return pid.stdout.toString().trim();
  }

  /// Collects logs from the app to a file and returns the [File] object.
  static Future<File?> getLog() async {
    final pid = await getPidOf();
    if (pid == null) return null; // TODO(PuntitOwO): throw an error
    final logDirectory = await getLogDir();
    final log = await Process.run(
      "logcat",
      <String>[
        "-d", // Dump the log and exit
        "--pid=$pid", // Only show logs from the given pid
        "-f", "log.txt", // Write the log to a file
      ],
      workingDirectory: logDirectory.path,
      runInShell: true,
    );
    if (log.exitCode != 0) return null; // TODO: throw an error
    return File("${logDirectory.path}/log.txt");
  }
}
