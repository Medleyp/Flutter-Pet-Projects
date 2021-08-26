import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:shop_app/providers/products_provider.dart';
import 'package:shop_app/screens/edit_product_screen.dart';
import 'package:shop_app/widgets/app_drawer.dart';
import 'package:shop_app/widgets/user_product_item.dart';

class UserProductsScren extends StatelessWidget {
  static const routeName = '/usesrProducts';

  Future<void> _refrechPriducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchAndSetProducts(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refrechPriducts(context),
        builder: (ctx, snaphot) => snaphot.connectionState ==
                ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refrechPriducts(context),
                child: Consumer<Products>(
                  builder: (ctx, productData, child) => Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ListView.separated(
                      itemCount: productData.items.length,
                      itemBuilder: (_, index) => UserProductItem(
                        id: productData.items[index].id,
                        title: productData.items[index].title,
                        imageUrl: productData.items[index].imageUrl,
                      ),
                      separatorBuilder: (ctx, index) => Divider(thickness: 2),
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
