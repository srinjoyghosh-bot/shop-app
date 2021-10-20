import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/products.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatelessWidget {
  //final String title;
  static const routeName = '/product-detail';

  //ProductDetailScreen(this.title);

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context).settings.arguments as String;
    final loadedProduct =
        Provider.of<Products>(context, listen: false).findById(productId);
//listen:false prevents rebuilding of screen as here nothing changes so no need to rebuild
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      body: CustomScrollView(
        //slivers are scrollable regions on screen
        slivers: [
          SliverAppBar(
            expandedHeight: 300, //height when its not the app bar but image
            pinned: true, //changes to app bar and sticks at top
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct.title),
              background: Hero(
                tag: loadedProduct.id, //same as previous tag
                child: Image.network(
                  loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                ),
              ), //what should be visible when expanded
            ), //what is inside app bar and how may change
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$${loadedProduct.price}',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 20,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  width: double.infinity,
                  child: Text(
                    loadedProduct.description,
                    textAlign: TextAlign.center,
                    softWrap: true,
                  )),
              SizedBox(
                height: 800,
              )
            ]),
          ),
        ],
      ),
    );
  }
}
