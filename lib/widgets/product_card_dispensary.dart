import 'package:chat/bloc/dispensary_bloc.dart';
import 'package:chat/models/products.dart';
import 'package:chat/theme/theme.dart';
import 'package:chat/widgets/productProfile_card.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/extension.dart';

class CardProductDispensary extends StatefulWidget {
  final Product product;
  final bool isDispensary;
  final bool isActive;
  final int quantitysTotal;
  final ProductDispensaryBloc productsUserDispensaryBloc;

  CardProductDispensary(
      {this.product,
      this.isDispensary = false,
      this.quantitysTotal = 0,
      this.isActive = false,
      this.productsUserDispensaryBloc});
  @override
  _CardProductState createState() => _CardProductState();
}

List<Product> productDispensary = [];

class _CardProductState extends State<CardProductDispensary> {
  @override
  void dispose() {
    productDispensary = [];
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);

    final quantityDispensary = widget.product.quantityDispensary;

    setState(() {
      quantity = quantityDispensary;
      //isActive = widget.isActive;

      if (widget.isActive)
        productDispensary =
            widget.productsUserDispensaryBloc.productDispensary.value;
    });

    print(widget.product);
    return Column(
      children: <Widget>[
        Container(
          decoration: BoxDecoration(
              color: (currentTheme.customTheme)
                  ? currentTheme.currentTheme.cardColor
                  : Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(10.0),
                  topLeft: Radius.circular(10.0),
                  bottomRight: Radius.circular(10.0),
                  bottomLeft: Radius.circular(10.0))),

          // padding: EdgeInsets.only(top: 10, left: 10, right: 10, bottom: 5.0),
          width: size.height / 1.5,
          child: FittedBox(
            child: Stack(
              children: [
                Row(
                  children: <Widget>[
                    productItem(widget.isDispensary, widget.quantitysTotal,
                        widget.productsUserDispensaryBloc, widget.isActive),
                    Container(
                        width: 100,
                        height: (widget.isDispensary) ? 100 : 150,
                        child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0),
                                bottomRight: Radius.circular(0.0),
                                bottomLeft: Radius.circular(10.0)),
                            child: Material(
                              type: MaterialType.transparency,
                              child: (widget.product.coverImage != "")
                                  ? cachedNetworkImage(
                                      widget.product.getCoverImg())
                                  : FadeInImage(
                                      image: AssetImage(
                                          'assets/images/empty_image.png'),
                                      placeholder:
                                          AssetImage('assets/loading2.gif'),
                                      fit: BoxFit.cover),
                            ))),
                  ],
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  int quantity;

  bool isActive1 = false;

  Widget productItem(bool isDispensary, int quantitysTotal,
      ProductDispensaryBloc productsUserDispensaryBloc, bool isActive) {
    final size = MediaQuery.of(context).size;
    final currentTheme = Provider.of<ThemeChanger>(context);
    final thc = (widget.product.thc.isEmpty) ? '0' : widget.product.thc;
    final cbd = (widget.product.cbd.isEmpty) ? '0' : widget.product.cbd;
    final rating = widget.product.ratingInit;
    final about = widget.product.description;

    var ratingDouble = double.parse('$rating');

    isActive1 = isActive;

    print(isActive1);

    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 5.0),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 10, vertical: 0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                child: Text(
                  widget.product.name.capitalize(),
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: currentTheme.currentTheme.accentColor),
                ),
              ),
              CbdthcRow(
                thc: '$thc',
                cbd: '$cbd',
                fontSize: 9.0,
              ),
              if (!isDispensary)
                SizedBox(
                  height: 5.0,
                ),
              if (!isDispensary)
                Container(
                  width: size.width / 3.5,
                  child: Text(
                    (about.length > 0) ? about.capitalize() : "Sin descripción",
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                    style: TextStyle(
                        fontWeight: FontWeight.normal,
                        fontSize: 10,
                        color: Colors.grey),
                  ),
                ),
              SizedBox(
                height: (about.length < 20 || isDispensary) ? 10 : 0.0,
              ),
              (isDispensary)
                  ? StreamBuilder(
                      stream: productsUserDispensaryBloc.gramsStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        final isSelected = (snapshot.data != null)
                            ? (snapshot.data != "")
                                ? true
                                : false
                            : false;

                        final gram =
                            (isSelected) ? int.parse(snapshot.data) : 0;

                        if (gram == 0 || gram < quantity && isActive1) {
                          quantity = 0;
                          productDispensary = [];

                          productsUserDispensaryBloc.productDispensary.sink
                              .add(productDispensary);
                        }

                        setState(() {
                          isActive1 = false;
                        });

                        return Container(
                          width: size.width / 3.5,
                          height: size.height / 25,
                          padding: const EdgeInsets.symmetric(
                            vertical: 0,
                          ),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: currentTheme
                                  .currentTheme.scaffoldBackgroundColor),
                          child: Row(
                            children: [
                              Material(
                                color: currentTheme
                                    .currentTheme.scaffoldBackgroundColor,
                                borderRadius: BorderRadius.circular(10),
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(10),
                                  radius: 25,
                                  onTap: () {
                                    if (quantity > 0) {
                                      setState(() {
                                        quantity--;
                                        FocusScope.of(context)
                                            .requestFocus(new FocusNode());

                                        final item =
                                            productDispensary.firstWhere(
                                                (item) =>
                                                    item.id ==
                                                    widget.product.id,
                                                orElse: () => null);
                                        if (item != null) {
                                          setState(() => {
                                                item.quantityDispensary =
                                                    quantity,
                                                productsUserDispensaryBloc
                                                    .productDispensary.sink
                                                    .add(productDispensary)
                                              });
                                        }
                                      });
                                    }
                                  },
                                  splashColor: Colors.grey,
                                  highlightColor: Colors.grey,
                                  child: Container(
                                    width: 34,
                                    height: 34,
                                    child: Icon(
                                      Icons.remove,
                                      color:
                                          currentTheme.currentTheme.accentColor,
                                      size: 15,
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Container(
                                  alignment: Alignment.center,
                                  padding: const EdgeInsets.only(),
                                  child: Text(
                                    quantity.toString(),
                                    style: TextStyle(
                                      color:
                                          currentTheme.currentTheme.accentColor,
                                    ),
                                  ),
                                ),
                              ),
                              Material(
                                  color: currentTheme
                                      .currentTheme.scaffoldBackgroundColor,
                                  borderRadius: BorderRadius.circular(10),
                                  child: InkWell(
                                    borderRadius: BorderRadius.circular(10),
                                    radius: 25,
                                    onTap: () {
                                      print(quantitysTotal);
                                      if (quantity < gram &&
                                          gram != quantitysTotal) {
                                        setState(() {
                                          FocusScope.of(context)
                                              .requestFocus(new FocusNode());

                                          quantity++;

                                          final product = widget.product;

                                          product.quantityDispensary = quantity;

                                          final findItem =
                                              productDispensary.firstWhere(
                                                  (item) =>
                                                      item.id == product.id,
                                                  orElse: () => null);

                                          if (findItem == null) {
                                            productDispensary.add(product);

                                            productsUserDispensaryBloc
                                                .productDispensary.sink
                                                .add(productDispensary);
                                          } else {
                                            product.quantityDispensary =
                                                quantity;
                                            productsUserDispensaryBloc
                                                .productDispensary.sink
                                                .add(productDispensary);
                                          }
                                        });
                                      }
                                    },
                                    splashColor: Colors.grey,
                                    highlightColor: Colors.grey,
                                    child: Container(
                                      width: 34,
                                      height: 34,
                                      child: Icon(
                                        Icons.add,
                                        color: currentTheme
                                            .currentTheme.accentColor,
                                        size: 15,
                                      ),
                                    ),
                                  ))
                            ],
                          ),
                        );
                      })
                  : Container(),
              if (isDispensary) const SizedBox(height: 10),
              (!isDispensary)
                  ? Container(
                      padding: EdgeInsets.only(left: 0, top: 5.0),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          (ratingDouble >= 1)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble >= 2)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble >= 3)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble >= 4)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                          (ratingDouble == 5)
                              ? Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.orangeAccent,
                                )
                              : Icon(
                                  Icons.star,
                                  size: 15,
                                  color: Colors.grey,
                                ),
                        ],
                      ),
                    )
                  : Container(),
            ],
          ),
        ),
      ],
    );
  }

  Widget eliteitem() {
    return Container(
      //width: 150,
      child: Column(
        //mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Text(
              "Alinea Chicago",
              style: TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 15, color: Colors.red),
            ),
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            "Classical French cooking",
            style: TextStyle(
                fontWeight: FontWeight.normal,
                fontSize: 9.5,
                color: Colors.grey),
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            children: <Widget>[
              Icon(
                Icons.shopping_cart,
                size: 15,
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.deepOrange[300],
                  //color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Spicy",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 9.5),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.red,
                  //color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "Hot",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 9.5,
                      color: Colors.white),
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Container(
                width: 35,
                decoration: BoxDecoration(
                  color: Colors.yellow[400],
                  //color: Theme.of(context).accentColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                alignment: Alignment.center,
                child: Text(
                  "New",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9.5,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              Text(
                "Ratings",
                style: TextStyle(
                    fontWeight: FontWeight.normal,
                    fontSize: 7,
                    color: Colors.grey),
              ),
              SizedBox(
                width: 10,
              ),
              Icon(
                Icons.star,
                size: 10,
                color: Colors.orangeAccent,
              ),
              Icon(
                Icons.star,
                size: 10,
                color: Colors.orangeAccent,
              ),
              Icon(
                Icons.star,
                size: 10,
                color: Colors.orangeAccent,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CbdthcRow extends StatelessWidget {
  const CbdthcRow(
      {Key key, @required this.thc, @required this.cbd, this.fontSize = 15})
      : super(key: key);

  final String thc;
  final String cbd;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 5.0),
      child: Row(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.0, vertical: 5.0),
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                color: Color(0xffF12937E),
                //color: Theme.of(context).accentColor,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                "THC: $thc %",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: fontSize,
                    color: Colors.white),
              ),
            ),
          ),
          SizedBox(
            width: 10,
          ),
          Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              color: Colors.blue,
              //color: Theme.of(context).accentColor,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              "CBD: $cbd %",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                  color: Colors.white),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
    );
  }
}
