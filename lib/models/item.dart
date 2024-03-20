class Item{
  final String name;
  final String flavour;
  final String url;
  final int price;

  Item(this.name, this.flavour, this.price, this.url);

  Map<String, dynamic> toJson() => {
    'name': name,
    'flavour': flavour,
    'price': price,
    'url': url,
  };

  static Item fromJson(Map<String, dynamic> json) => Item(
    json['name'],
    json['flavour'],
    json['price'],
    json['url']
  );
}