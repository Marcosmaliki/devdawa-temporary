import 'package:badges/badges.dart';
import 'package:devdawa/auth/login.dart';
import 'package:devdawa/services/base_client.dart';
import 'package:devdawa/utils/appcolors.dart';
import 'package:devdawa/views/main_cart.dart';
import 'package:devdawa/views/menu_views/menu_basket.dart';
import 'package:devdawa/views/menu_views/menu_history.dart';
import 'package:devdawa/views/menu_views/menu_home.dart';
import 'package:devdawa/views/menu_views/menu_profile.dart';
import 'package:devdawa/views/search.dart';
import 'package:devdawa/views/wallet_transacrions.dart';
import 'package:devdawa/views/withdraw.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:infinite_carousel/infinite_carousel.dart';
import 'package:page_transition/page_transition.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:async';
import '../utils//number_formatter.dart';

class HomeScreen extends StatefulWidget {
  final Map user;
  final String token;

  const HomeScreen({required this.user, required this.token});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with WidgetsBindingObserver {
  int _selectedIndex = 0;

  final primaryColor = const Color(0xff4338CA);

  final secondaryColor = const Color(0xff6D28D9);

  final accentColor = const Color(0xffffffff);

  final backgroundColor = const Color(0xffffffff);

  final errorColor = const Color(0xffEF4444);

  String _cart_counter = "..";

  bool _fetching_cart_count = true;

  String wallet_balance = "0";
  String? wallet_id;

  late InfiniteScrollController _carouselController;

  var base_client = BaseClient();

  bool _fetch_wallet = true;

  List menu_screens = [
    MenuHome(),
    MenuBasket(),
    //MenuFavs(),
    MenuHistory(),
    MenuProfile()
  ];

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

  bool _isPlaying = false;
  final GlobalKey _sliderKey = GlobalKey();
  var scaffoldKey = GlobalKey<ScaffoldState>();

  _getCart() async {
    final prefs = await SharedPreferences.getInstance();
    var request_result = await BaseClient.getRequestAuth(
        base_client.base_url + "/cart/all", prefs.getString("token"));

    setState(() {
      _cart_counter = request_result["data"]["data"]["data"].length.toString();
      _fetching_cart_count = false;
    });

    //print(request_result["data"]["data"]["data"].length);
  }

  _showSnackBar(message, color, icon) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon),
          SizedBox(
            width: 10,
          ),
          Text(message)
        ],
      ),
      backgroundColor: color,
      action: SnackBarAction(
        label: 'Undo',
        onPressed: () {
          // Some code to undo the change.
        },
      ),
    );

    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool _fetch_categories = false;
  bool _fetch_brands = false;
  bool _fetch_anouncements = true;
  List _categories = [];
  List _announce = [];

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance!.addObserver(this);

    _getCart();
    _getCategories();
    _getWallet();

    _carouselController = InfiniteScrollController();

    /*Timer mytimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      */ /*print(base_client.cart_change);*/ /*
      print("Running every 1 seconds");
    });*/
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

  _getWallet() async {
    final prefs = await SharedPreferences.getInstance();
    Map data = {
      "id": prefs.getString("client_id"),
      "type": "client",
    };

    var request_result = await BaseClient.postRequest(
        base_client.base_url + "/wallet/user/get", data);

    setState(() {
      print("All fone");
      _fetch_wallet = false;
      wallet_id = request_result["data"]["data"]["id"].toString();

      wallet_balance =
          request_result["data"]["data"]["accountBalance"].toString();
    });
  }

  @override
  void dispose() {
    super.dispose();
    WidgetsBinding.instance!.removeObserver(this);
    _carouselController.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    switch (state) {
      case AppLifecycleState.resumed:
        onResumed();
        break;
      case AppLifecycleState.inactive:
        onInactive();
        break;
      case AppLifecycleState.paused:
        onPaused();
        break;
      case AppLifecycleState.detached:
        onDetached();
        break;
    }
  }

  onResumed() {
    print("Page resumed");
  }

  onPaused() {
    print("Page paused");
  }

  onInactive() {
    print("Page inactive");
  }

  onDetached() {
    print("Page detarched");
  }

  /*void onInactive();
  void onDetached();*/

  DateTime? currentBackPressTime;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        DateTime now = DateTime.now();
        if (currentBackPressTime == null ||
            now.difference(currentBackPressTime!) > Duration(seconds: 5)) {
          currentBackPressTime = now;
          //Fluttertoast.showToast(msg: exit_warning);
          _showSnackBar("Tap again to close", Colors.grey, Icons.close);
          return Future.value(false);
        }
        return Future.value(true);
      },
      child: Scaffold(
        key: scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          leading: GestureDetector(
            onTap: () {
              Navigator.push(
                context,
                PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: Search(
                      user: widget.user,
                      token: widget.token,
                    ),
                    inheritTheme: true,
                    ctx: context),
              );
            },
            child: const Icon(
              Icons.search,
              size: 30,
            ),
          ),
          title: GestureDetector(
            onTap: () {
              _showSnackBar(
                  "Welcome here", Colors.green, Icons.favorite_border);
            },
            child: Row(
              children: [
                Image.asset(
                  "assets/icons/pharmacy.png",
                  height: 37,
                  width: 37,
                ),
                const SizedBox(
                  width: 10,
                ),
                Text(
                  "Dawasap",
                  style: GoogleFonts.lobster(),
                )
              ],
            ),
          ),
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: MainCart(
                        user: widget.user,
                      ),
                      inheritTheme: true,
                      ctx: context),
                );
              },
              child: Badge(
                badgeContent: Text(
                  _cart_counter.toString(),
                  style: GoogleFonts.openSans()
                      .copyWith(fontSize: 10, color: AppColors.white),
                ),
                padding: EdgeInsets.all(5),
                child: Icon(Icons.shopping_basket),
                position: BadgePosition.topStart(top: 5, start: -15),
                badgeColor: Colors.green.shade200,
              ),
            ),
            const SizedBox(
              width: 5,
            ),
            //const Icon(Icons.more_vert),
            PopupMenuButton(
                onSelected: (value) async {
                  if (value == 1) {
                    final prefs = await SharedPreferences.getInstance();
                    prefs.setBool("logged_in", false).then((value) {
                      Navigator.push(
                        context,
                        PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: Login(),
                            inheritTheme: true,
                            ctx: context),
                      );
                    });
                  } else if (value == 2) {
                    final prefs = await SharedPreferences.getInstance();
                    /*Navigator.push(
                      context,
                      PageTransition(
                          type: PageTransitionType.rightToLeft,
                          child: RateDelivery(
                              user: widget.user,
                              token: widget.token,
                              ),
                          inheritTheme: true,
                          ctx: context),
                    );*/
                  }
                },
                itemBuilder: (context) => [
                      PopupMenuItem(
                          value: 2,
                          child: Row(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                                child: Icon(
                                  Icons.send,
                                  color: Colors.black,
                                ),
                              ),
                              Text('Prescription')
                            ],
                          )),
                      PopupMenuItem(
                          value: 1,
                          child: Row(
                            children: const <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(2, 2, 8, 2),
                                child: Icon(
                                  Icons.exit_to_app,
                                  color: Colors.black,
                                ),
                              ),
                              Text('Logout')
                            ],
                          )),
                    ]),
            const SizedBox(
              width: 0,
            )
          ],
        ),
        body: Container(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  height: 110,
                  width: MediaQuery.of(context).size.width,
                  margin: EdgeInsets.all(10),
                  decoration: BoxDecoration(color: AppColors.white),
                  child: _fetch_wallet
                      ? Center(
                          child: CircularProgressIndicator(),
                        )
                      : Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Wallet balance:",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 22,
                                  color: AppColors.green),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Text(
                              "Ksh. ${num.parse(wallet_balance).formatNumber}",
                              style: const TextStyle(
                                  fontWeight: FontWeight.w500, fontSize: 20),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: WalletTransactions(
                                            user: widget.user,
                                            token: widget.token,
                                            walletId: wallet_id.toString(),
                                          ),
                                          inheritTheme: true,
                                          ctx: context),
                                    );
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: AppColors.green,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Center(
                                      child: Text(
                                        "View transactions",
                                        style:
                                            TextStyle(color: AppColors.white),
                                      ),
                                    ),
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      PageTransition(
                                          type: PageTransitionType.rightToLeft,
                                          child: Withdraw(
                                            user: widget.user,
                                            token: widget.token,
                                            walletId: wallet_id.toString(),
                                          ),
                                          inheritTheme: true,
                                          ctx: context),
                                    );
                                  },
                                  child: Container(
                                    height: 45,
                                    width: 150,
                                    decoration: BoxDecoration(
                                        color: AppColors.green_shade,
                                        borderRadius: BorderRadius.circular(7)),
                                    child: Center(
                                      child: Text(
                                        "Withdraw",
                                        style:
                                            TextStyle(color: AppColors.white),
                                      ),
                                    ),
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                ),
                menu_screens[_selectedIndex]
              ],
            ),
          ),
        ),
        bottomNavigationBar: _bottomNavigation(),
      ),
    );
  }

  _onItemTapped(item) {
    setState(() {
      _selectedIndex = item;
    });
  }

  Widget _bottomNavigation() {
    return BottomNavigationBar(
      unselectedItemColor: Colors.grey.shade400,
      type: BottomNavigationBarType.fixed,
      backgroundColor: AppColors.green,
      items: <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.home),
          label: 'Home',
          backgroundColor: AppColors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.reorder),
          label: 'Orders',
          backgroundColor: AppColors.green,
        ),
        /*BottomNavigationBarItem(
          icon: Icon(Icons.favorite_border),
          label: 'Favourites',
          backgroundColor: AppColors.green_shade,
        ),*/
        BottomNavigationBarItem(
          icon: Icon(Icons.access_time),
          label: 'History',
          backgroundColor: AppColors.green,
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: 'Account',
          backgroundColor: AppColors.green,
        ),
      ],
      currentIndex: _selectedIndex,
      selectedItemColor: AppColors.white,
      onTap: _onItemTapped,
    );
  }

  Widget _bottomNav() {
    return BottomAppBar(
      color: AppColors.green,
      child: SizedBox(
        height: 56,
        width: MediaQuery.of(context).size.width,
        child: Padding(
          padding: const EdgeInsets.only(left: 20.0, right: 20.0, bottom: 7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              IconBottomBar(
                  text: "Home",
                  icon: CupertinoIcons.home,
                  selected: true,
                  onPressed: () {}),
              IconBottomBar(
                  text: "Search",
                  icon: Icons.search_outlined,
                  selected: false,
                  onPressed: () {}),
              IconBottomBar(
                  text: "Add",
                  icon: Icons.add_to_photos_outlined,
                  selected: false,
                  onPressed: () {}),
              IconBottomBar(
                  text: "Cart",
                  icon: Icons.local_grocery_store_outlined,
                  selected: false,
                  onPressed: () {}),
              IconBottomBar(
                  text: "History",
                  icon: Icons.access_time,
                  selected: false,
                  onPressed: () {})
            ],
          ),
        ),
      ),
    );
  }
}

class IconBottomBar extends StatelessWidget {
  const IconBottomBar(
      {Key? key,
      required this.text,
      required this.icon,
      required this.selected,
      required this.onPressed})
      : super(key: key);
  final String text;
  final IconData icon;
  final bool selected;
  final Function() onPressed;

  final primaryColor = const Color(0xff4338CA);
  final accentColor = const Color(0xffffffff);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: onPressed,
          icon:
              Icon(icon, size: 25, color: selected ? accentColor : Colors.grey),
        ),
        Text(
          text,
          style: TextStyle(
              fontSize: 12,
              height: .1,
              color: selected ? accentColor : Colors.grey),
        )
      ],
    );
  }
}
