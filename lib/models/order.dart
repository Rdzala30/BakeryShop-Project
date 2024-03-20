class Order{
  final String username;
  final int totQuantity;
  final int totPrice;

  Order(this.username, this.totPrice, this.totQuantity);

  Map<String, dynamic> toJson()=>{
    'username': username,
    'totQuantity': totQuantity,
    'totPrice': totPrice,
  };
}