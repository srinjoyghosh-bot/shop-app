import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/helpers/custom_route.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/orders.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:flutter_complete_guide/screens/auth_screen.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import 'package:flutter_complete_guide/screens/edit_product_screen.dart';
import 'package:flutter_complete_guide/screens/splash_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/product_detail_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/user_products_screen.dart';
import 'package:provider/provider.dart';
import 'providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          //provider which depends on another provider defined before this one
          create: (ctx) =>
              Products(Provider.of<Auth>(ctx, listen: false).token, []),
          update: (ctx, auth, previousProducts) => Products(auth.token,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) =>
              Orders(Provider.of<Auth>(ctx, listen: false).token, []),
          update: (ctx, auth, previousOrders) => Orders(
              auth.token, previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      //all child wigets can listen to changes
      //if something changes, only widgets listening will be rebuilt
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
                pageTransitionsTheme:PageTransitionsTheme(builders: {
                  TargetPlatform.android: CustomPageTransitionBuilder(),
                  TargetPlatform.iOS: CustomPageTransitionBuilder(),
                  //fade transition for all pages
                }) ),
            home: auth.isAuth
                ? ProductOverViewScreen()
                : FutureBuilder(
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                    future: auth.tryAutoLogin(),
                  ),
                  
            routes: {
              ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
              CartScreen.routeName: (ctx) => CartScreen(),
              OrdersScreen.routeName: (ctx) => OrdersScreen(),
              UserProductsScreen.routeName: (ctx) => UserProductsScreen(),
              EditProductScreen.routeName: (ctx) => EditProductScreen()
            }),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return null;
  }
}
