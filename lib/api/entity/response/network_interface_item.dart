/// `/api/v2/app/networkInterfaceList` 单项。
class NetworkInterfaceItem {
  const NetworkInterfaceItem({
    required this.name,
    required this.value,
  });

  final String name;
  final String value;

  factory NetworkInterfaceItem.fromJson(Map<String, dynamic> json) {
    return NetworkInterfaceItem(
      name: json['name']?.toString() ?? '',
      value: json['value']?.toString() ?? '',
    );
  }
}
