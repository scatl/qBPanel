import 'package:qbpanel/util/app_log_file_result.dart';

bool get appLogFileSupported => false;

Future<void> appendAppLogLine(String line) async {}

Future<AppLogFileReadResult> readAppLogFile() async {
  return const AppLogFileReadResult(supported: false, lines: []);
}
