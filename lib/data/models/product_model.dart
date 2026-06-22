class ProductModel {
  final String
  id; // Added: Unique identifier property to resolve the compilation error
  final String title;
  final String category;
  final String imageUrl;
  final double price;
  bool isPurchased;
  bool isLiked;
  bool inCart;
  int quantity;

  ProductModel({
    required this.id, // Added to constructor
    required this.title,
    required this.category,
    required this.imageUrl,
    required this.price,
    this.isLiked = false,
    this.isPurchased = false,
    this.inCart = false,
    this.quantity = 1,
  });
}

final List<ProductModel> dummyProducts = [
  // ================= MEN =================
  ProductModel(
    id: "m1",
    title: "Nike Air Max",
    category: "Men",
    imageUrl: "https://images.unsplash.com/photo-1542291026-7eec264c27ff",
    price: 120,
  ),
  ProductModel(
    id: "m2",
    title: "Men Casual Shirt",
    category: "Men",
    imageUrl: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf",
    price: 45,
  ),
  ProductModel(
    id: "m3",
    title: "Men T-Shirt",
    category: "Men", // Fixed casing from "men" -> "Men"
    imageUrl: "https://images.unsplash.com/photo-1503919545889-aef636e10ad4",
    price: 25,
  ),
  ProductModel(
    id: "m4",
    title: "Men Sneakers",
    category: "Men", // Fixed casing from "men" -> "Men"
    imageUrl: "https://images.unsplash.com/photo-1460353581641-37baddab0fa2",
    price: 40,
  ),

  // ================= WOMEN =================
  ProductModel(
    id: "w1",
    title: "Women Handbag",
    category: "Women",
    imageUrl: "https://images.unsplash.com/photo-1584917865442-de89df76afd3",
    price: 75,
  ),
  ProductModel(
    id: "w2",
    title: "Women Dress",
    category: "Women",
    imageUrl: "https://images.unsplash.com/photo-1496747611176-843222e1e57c",
    price: 95,
  ),
  ProductModel(
    id: "w3",
    title: "Women Heels",
    category: "Women",
    imageUrl: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2",
    price: 65,
  ),
  ProductModel(
    id: "w4",
    title: "Women Denim Jacket",
    category: "Women", // Fixed category mixup from "Men" -> "Women"
    imageUrl: "https://images.unsplash.com/photo-1517841905240-472988babdf9",
    price: 85,
  ),

  // ================= KIDS =================
  ProductModel(
    id: "k1",
    title: "Kids Jacket",
    category: "Kids",
    imageUrl: "https://images.unsplash.com/photo-1519238263530-99bdd11df2ea",
    price: 60,
  ),
  ProductModel(
    id: "k2",
    title: "Kids T-Shirt",
    category: "Kids",
    imageUrl: "https://images.unsplash.com/photo-1503919545889-aef636e10ad4",
    price: 25,
  ),
  ProductModel(
    id: "k3",
    title: "Kids Sneakers",
    category: "Kids",
    imageUrl: "https://images.unsplash.com/photo-1460353581641-37baddab0fa2",
    price: 40,
  ),
];
