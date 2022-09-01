import 'package:devdawa/controllers/menu_controller.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/common_drugs.dart';
import 'package:devdawa/views/conditions.dart';
import 'package:devdawa/views/prescription.dart';
import 'package:devdawa/views/product_category.dart';
import 'package:devdawa/views/prooduct_detail.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_slider/carousel_slider.dart';
import 'package:flutter_carousel_slider/carousel_slider_indicators.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MenuHome extends StatefulWidget {
  @override
  State<MenuHome> createState() => _MenuHomeState();
}

class _MenuHomeState extends State<MenuHome> {
  bool _isPlaying = false;
  final GlobalKey _sliderKey = GlobalKey();

  bool fetching_cart = true;

  Map details = {};

  String token = "";

  List category_items = [
    {
      "name": "Skin care",
      "image":
          "https://post.healthline.com/wp-content/uploads/2021/09/1587874-13-Best-Natural-Skin-Care-Products-732x549-Feature-732x549.jpg",
    },
    {
      "name": "Medical devices",
      "image":
          "https://www.sahpra.org.za/wp-content/uploads/2020/01/medical-devices-2.jpg",
    },
    {
      "name": "Pharmaceuticals",
      "image":
          "https://www.pharmaceutical-technology.com/wp-content/uploads/sites/24/2019/03/pharmaceuticals.jpg",
    },
    {
      "name": "Prescription products",
      "image":
          "https://pharmanewsintel.com/images/site/article_headers/_normal/2020-02-25-GettyImages-913088320.png",
    },
  ];

  List popular_items = [
    {
      "image":
          "https://d1nrlfoo9ty7le.cloudfront.net/wp-content/uploads/2021/10/Cerave-sa-salicylic-acid-lotion.jpg",
      "name": "Cerave(SA)",
      "price": "200",
      "rating": "3.0"
    },
    {
      "image":
          "https://assets.vogue.com/photos/5f3d7e06a469cffcf783317b/master/w_1280%2Cc_limit/slide_3.jpg",
      "name": "CE Furilic",
      "price": "900",
      "rating": "3.5"
    },
    {
      "image":
          "https://www.popsci.com/uploads/2022/03/21/best-mask-3m.jpg?auto=webp",
      "name": "N95 Face Mask",
      "price": "1200",
      "rating": "4.0"
    },
    {
      "image":
          "https://cdn.shopify.com/s/files/1/0323/5073/2347/products/BlueLabWhey2kg-Chocolate_2048x.png?v=1616769262",
      "name": "Whey protein",
      "price": "3200",
      "rating": "5.0"
    },
  ];

  List _brands = [
    {
      "image":
          "https://www.pngitem.com/pimgs/m/476-4764764_pfizer-logo-black-and-white-pfizer-logo-white.png"
    },
    {"image": "http://assets.stickpng.com/images/6009cd5142063e000443066e.png"},
    {
      "image":
          "https://cdn4.vectorstock.com/i/1000x1000/54/58/fitness-logo-design-vector-26495458.jpg"
    },
    {
      "image":
          "https://cdn4.vectorstock.com/i/1000x1000/09/53/skin-care-logo-inspiration-vector-31020953.jpg"
    }
  ];

  List carousel_items = [
    "https://st2.depositphotos.com/13266880/44336/v/950/depositphotos_443360118-stock-illustration-pharmacy-items-medicines-medical-products.jpg?forcejpeg=true",
    "https://previews.123rf.com/images/css0101/css01011704/css0101170400131/76255834-a-set-of-vector-isometric-projection-illustrations-for-advertising-and-announcements-about-pharmacy-.jpg",
    "https://img.freepik.com/free-photo/medical-stuff-presenting-catalog-product-client-inside-pharmacy-medicine-healthcare-business-business-healthcare_482257-25625.jpg",
    "https://st2.depositphotos.com/13266880/44142/v/450/depositphotos_441422576-stock-illustration-pharmacy-items-medicines-medical-products.jpg?forcejpeg=true"
  ];

  List products_list = [];

  List<dynamic> cart = [];

  late InfiniteScrollController _carouselController;

  bool _fetchingproducts = true;
  bool _fetchingDetails = true;

  var base_client = BaseClient();

  int _cart_counter = 0;

  bool _fetch_categories = false;
  bool _fetch_brands = false;
  List _categories = [];
  List _brands_list = [];

  bool _fetch_anouncements = true;

  List _announce = [];

  @override
  void initState() {
    super.initState();
    _getProducts();
    _getCart();
    _getDetails();
    _getCategories();
    _getBrands();
    _getAnnouncemets();
    _carouselController = InfiniteScrollController();
  }

  _getAnnouncemets() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/announcements/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_anouncements = false;
          _announce = request_result["data"]["data"];
        });
      }
    }
  }

  _getCategories() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/category/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_categories = false;
          _categories = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  _getBrands() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/brand/all", prefs.getString("token"));

    if (request_result["status"] == "offline") {
      print("Offline");
    } else {
      if (request_result["data"]["success"]) {
        setState(() {
          _fetch_brands = false;
          _brands_list = request_result["data"]["data"]["data"];
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _carouselController.dispose();
  }

  _getCart() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/cart/all", prefs.getString("token"));

    setState(() {
      cart = request_result["data"]["data"]["data"];
      _cart_counter = request_result["data"]["data"]["data"].length;
      fetching_cart = false;
    });

    //print(request_result["data"]["data"]["data"].length);
  }

  _getProducts() async {
    final prefs = await SharedPreferences.getInstance();

    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/product/all", prefs.getString("token"));

    for (var product in request_result["data"]["data"]["data"]) {
      products_list.add({
        "id": product["id"],
        "name": product["name"],
        /*"image": product["product_image"][0]["image"],*/
        "image": product["product_image"],
        "price": product["product_pricing"]["price"].toString(),
        "rating": "3",
        "description": product["product_detail"]["details"],
        "stock": product["inventory"]
      });
    }

    setState(() {
      _fetchingproducts = false;
    });

    print(products_list);

    //popular_items
  }

  _getDetails() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/user/${prefs.getString("user_uid")}/get",
        prefs.getString("token"));

    setState(() {
      token = prefs.getString("token").toString();
      details = request_result["data"]["data"];
      _fetchingDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        color: AppColors.shade,
        child: Padding(
          padding: const EdgeInsets.only(top: 15, left: 15, right: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _fetch_anouncements
                  ? Center(
                      child: CircularProgressIndicator(),
                    )
                  : Container(
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: AppColors.white),
                      child: CarouselSlider.builder(
                          enableAutoSlider: true,
                          key: _sliderKey,
                          unlimitedMode: true,
                          slideBuilder: (index) {
                            return Container(
                              height: MediaQuery.of(context).size.height,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                image: DecorationImage(
                                    image:
                                        NetworkImage(_announce[index]["image"]),
                                    fit: BoxFit.cover),
                              ),
                              child: Container(
                                height: MediaQuery.of(context).size.height,
                                width: MediaQuery.of(context).size.width,
                                decoration: BoxDecoration(
                                    gradient: LinearGradient(colors: [
                                  Colors.pink.withOpacity(0.5),
                                  Colors.blue.withOpacity(0.5),
                                  Colors.purple.withOpacity(0.5),
                                  Colors.purple.withOpacity(0.8)
                                ])),
                                child: Stack(
                                  children: [
                                    Positioned(
                                      bottom: 30,
                                      left: 10,
                                      child: Text(
                                        _announce[index]["title"],
                                        style: GoogleFonts.openSans().copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 20,
                                            color: AppColors.white),
                                      ),
                                    ),
                                    Positioned(
                                      bottom: 10,
                                      left: 10,
                                      child: Text(
                                        _announce[index]["description"],
                                        style: GoogleFonts.openSans().copyWith(
                                            fontWeight: FontWeight.w600,
                                            fontSize: 14,
                                            color: AppColors.white),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          },
                          slideIndicator: CircularSlideIndicator(
                              padding: EdgeInsets.only(bottom: 10),
                              indicatorRadius: 3),
                          itemCount: _announce.length),
                    ),
              const SizedBox(
                height: 10,
              ),

              //Section 2
              Text(
                "Choose by category",
                style: GoogleFonts.openSans().copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              _fetch_categories && _categories.length > 0
                  ? Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : _categories.length > 0
                      ? Container(
                          height: 100,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(color: AppColors.white),
                          child: InfiniteCarousel.builder(
                            itemCount: _categories.length,
                            itemExtent: 170,
                            center: true,
                            anchor: 0.0,
                            velocityFactor: 0.2,
                            onIndexChanged: (index) {},
                            controller: _carouselController,
                            axisDirection: Axis.horizontal,
                            loop: true,
                            itemBuilder: (context, itemIndex, realIndex) {
                              return GestureDetector(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    PageTransition(
                                        type: PageTransitionType.rightToLeft,
                                        child: CategoryProduct(
                                          category: _categories[itemIndex]
                                                  ["category"]
                                              .toString(),
                                          category_id: _categories[itemIndex]
                                                  ["id"]
                                              .toString(),
                                        ),
                                        inheritTheme: true,
                                        ctx: context),
                                  );
                                },
                                child: _categoryItem(
                                    _categories[itemIndex]["category"],
                                    _categories[itemIndex]["image"]),
                              );
                            },
                          ),
                          /*child: ListView.builder(
                        itemCount: _categories.length,
                        itemBuilder: (_,index){
                          return _categoryItem(
                              _categories[index]["category"],
                              _categories[index]["image"]);
                        },
                      ),*/
                        )
                      : Center(
                          child: CircularProgressIndicator(),
                        ),
              const SizedBox(
                height: 10,
              ),

              //Section 3
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  /*Text(
                    "Popular products",
                    style: GoogleFonts.openSans().copyWith(
                        fontWeight: FontWeight.w600, color: AppColors.black),
                  ),*/
                  Container(
                    height: 30,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: Prescription(),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.category,
                            size: 15,
                          ),
                          Text("Prescription")
                        ],
                      ),
                      style:
                          ElevatedButton.styleFrom(primary: Colors.deepOrange),
                    ),
                  ),
                  Container(
                    height: 30,
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                              type: PageTransitionType.rightToLeft,
                              child: AllConditions(),
                              inheritTheme: true,
                              ctx: context),
                        );
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.accessibility_new,
                            size: 15,
                          ),
                          /*Text("Common drugs")*/
                          Text("Conditions")
                        ],
                      ),
                      style: ElevatedButton.styleFrom(primary: Colors.pink),
                    ),
                  )
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              _fetchingproducts || fetching_cart || _fetchingDetails
                  ? Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: AppColors.white),
                      child: InfiniteCarousel.builder(
                        itemCount: carousel_items.length,
                        itemExtent: 120,
                        center: true,
                        anchor: 0.0,
                        velocityFactor: 0.2,
                        onIndexChanged: (index) {},
                        controller: _carouselController,
                        axisDirection: Axis.horizontal,
                        loop: true,
                        itemBuilder: (context, itemIndex, realIndex) {
                          return GestureDetector(
                            onTap: () {
                              //print(products_list[itemIndex]);
                              Navigator.push(
                                context,
                                PageTransition(
                                    type: PageTransitionType.rightToLeft,
                                    child: ProductDetail(
                                      //data: popular_items[itemIndex],
                                      token: token,
                                      cart_count: cart.length,
                                      user: details,
                                      data: products_list[itemIndex],
                                      cart: cart,
                                    ),
                                    inheritTheme: true,
                                    ctx: context),
                              );
                            },
                            child: _popularProducts(
                                products_list[itemIndex]["image"][
                                        products_list[itemIndex]["image"]
                                                .length -
                                            1]["image"]
                                    .toString(),
                                products_list[itemIndex]["name"],
                                products_list[itemIndex]["price"],
                                products_list[itemIndex]["rating"].toString()),

                            /*popular_items[itemIndex]["image"],
                                popular_items[itemIndex]["name"],
                                popular_items[itemIndex]["price"],
                                popular_items[itemIndex]["rating"].toString()),*/
                          );
                        },
                      ),
                    ),

              const SizedBox(
                height: 10,
              ),

              //Section 3
              Text(
                "Popular brands",
                style: GoogleFonts.openSans().copyWith(
                    fontWeight: FontWeight.w600, color: AppColors.black),
              ),
              const SizedBox(
                height: 10,
              ),
              _fetch_brands
                  ? Container(
                      child: const Center(
                        child: CircularProgressIndicator(),
                      ),
                    )
                  : Container(
                      height: 150,
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(color: AppColors.white),
                      /*child: InfiniteCarousel.builder(
                        itemCount: _brands_list.length,
                        itemExtent: 120,
                        center: true,
                        anchor: 0.0,
                        velocityFactor: 0.2,
                        onIndexChanged: (index) {},
                        controller: _carouselController,
                        axisDirection: Axis.horizontal,
                        loop: true,
                        itemBuilder: (context, itemIndex, realIndex) {
                          return _popularBrands(
                              _brands_list[itemIndex]["image"].toString());
                        },
                      ),*/
                      child: ListView.builder(
                        scrollDirection: Axis.horizontal,
                        itemCount: _brands_list.length,
                        itemBuilder: (_, index) {
                          return _popularBrands(
                              _brands_list[index]["image"].toString());
                        },
                      ),
                    )
            ],
          ),
        ),
      ),
    );
  }

  Widget _popularBrands(image) {
    return image == "null"
        ? Container(
            height: MediaQuery.of(context).size.height,
            //width: MediaQuery.of(context).size.width,
            color: AppColors.shade,
            width: 100,
            child: Center(
              child: Text("No image"),
            ),
          )
        : Container(
            height: MediaQuery.of(context).size.height,
            /*width: MediaQuery.of(context).size.width,*/
            width: 100,
            child: Image.network(
              image,
              fit: BoxFit.contain,
            ),
          );
  }

  Widget _popularProducts(image, name, price, rating) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(3),
      decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black12,
          ),
          color: AppColors.shade),
      child: Padding(
        padding: const EdgeInsets.only(left: 5, right: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 100,
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(0)),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(0),
                child: Image.network(
                  image,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(
              height: 5,
            ),
            Text(
              name.length <= 15 ? name : name.substring(0, 14) + "...",
              style: GoogleFonts.openSans().copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.black,
                  fontSize: 11),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Ksh. ${price.toString()}",
                  style: GoogleFonts.openSans().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.pale_text,
                      fontSize: 12),
                ),
                const Spacer(),
                const Icon(
                  Icons.star,
                  color: Colors.yellow,
                  size: 17,
                ),
                Text(
                  rating.toString(),
                  style: GoogleFonts.openSans().copyWith(
                      fontWeight: FontWeight.w600,
                      color: AppColors.pale_text,
                      fontSize: 12),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }

  Widget _categoryItem(name, image) {
    return Container(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(image), fit: BoxFit.cover),
      ),
      child: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
            gradient: LinearGradient(colors: [
          Colors.orangeAccent.withOpacity(0.5),
          Colors.blue.withOpacity(0.5),
          Colors.orange.withOpacity(0.2),
          Colors.deepOrange.withOpacity(0.6)
        ])),
        child: Stack(
          children: [
            Positioned(
              bottom: 5,
              left: 5,
              child: Text(
                name,
                style: GoogleFonts.openSans().copyWith(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.white),
              ),
            )
          ],
        ),
      ),
    );
  }
}
