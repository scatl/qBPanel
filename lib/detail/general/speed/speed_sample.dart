class SpeedSample {
  const SpeedSample({
    required this.at,
    required this.download,
    required this.upload,
  });

  final DateTime at;
  final int download;
  final int upload;
}
