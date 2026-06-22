class BannerModel {
  final String image;
  final String title;
  final String offer;

  BannerModel({required this.image, required this.title, required this.offer});
}

final List<BannerModel> bannerList = [
  BannerModel(
    image: 'https://images.unsplash.com/photo-1483985988355-763728e1935b',
    title: 'Summer Sale',
    offer: 'UP TO 50% OFF',
  ),
  BannerModel(
    image: 'https://images.unsplash.com/photo-1490481651871-ab68de25d43d',
    title: 'Women Collection',
    offer: 'FLAT 40% OFF',
  ),
  BannerModel(
    image: 'https://images.unsplash.com/photo-1441986300917-64674bd600d8',
    title: 'New Arrivals',
    offer: 'BUY 1 GET 1',
  ),
  BannerModel(
    image: 'https://images.unsplash.com/photo-1523381210434-271e8be1f52b',
    title: 'Men Fashion',
    offer: 'UP TO 60% OFF',
  ),
  BannerModel(
    image: 'https://images.unsplash.com/photo-1515886657613-9f3515b0c78f',
    title: 'Kids Special',
    offer: 'FLAT 30% OFF',
  ),
  BannerModel(
    image: 'https://images.unsplash.com/photo-1529139574466-a303027c1d8b',
    title: 'Weekend Deal',
    offer: 'EXTRA 20% OFF',
  ),
];
