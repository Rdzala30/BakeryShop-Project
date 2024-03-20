class order {
  final String itemname;
  final int quantity;
  final int totalbill;

  order({
    required this.itemname,
    required this.quantity,
    required this.totalbill,
  });

  factory order.fromJson(Map<String, dynamic> json) {
    return order(
      itemname: json['username'],
      quantity: json['totQuantity'],
      totalbill: json['totPrice'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'username': itemname,
      'totQuantity': quantity,
      'totPrice': totalbill,
    };
  }
}
