import 'package:animate_do/animate_do.dart';
import 'package:chat/models/dispensaries_products_response%20copy.dart';
import 'package:chat/models/products.dart';
import 'package:chat/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';

class CardDispensaryProducts extends StatefulWidget {
  final DispensariesProduct dispensaryProducts;

  CardDispensaryProducts({@required this.dispensaryProducts});
  @override
  _CardDispensaryProductsState createState() => _CardDispensaryProductsState();
}

class _CardDispensaryProductsState extends State<CardDispensaryProducts> {
  @override
  Widget build(BuildContext context) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final isActive = widget.dispensaryProducts.isActive;
    final isEdit = widget.dispensaryProducts.isEdit;

    final isDelivered = widget.dispensaryProducts.isDelivered;

    final products = widget.dispensaryProducts.productsDispensary;

    return Container(
      padding: EdgeInsets.fromLTRB(0, 0, 0, 0),
      height: (products.length > 0) ? 210 : 150,
      width: double.maxFinite,
      child: Card(
        color: currentTheme.currentTheme.cardColor,
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: [
                              dateDeliveredIcon(),
                              Spacer(),
                              dateUpdated(),
                              SizedBox(
                                width: 15,
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: <Widget>[
                              gramsIcon(),

                              // dateUpdated(),
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Row(
                            children: [
                              if (isActive && !isDelivered)
                                Chip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Icon(Icons.pending)),
                                  label: Text('En Curso'),
                                ),
                              if (isActive && isDelivered)
                                Chip(
                                  backgroundColor:
                                      currentTheme.currentTheme.accentColor,
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Icon(
                                        Icons.check,
                                        color: currentTheme
                                            .currentTheme.accentColor,
                                      )),
                                  label: Text(
                                    'Entregado',
                                    style: TextStyle(color: Colors.black),
                                  ),
                                ),
                              SizedBox(
                                width: 15,
                              ),
                              if (isEdit)
                                Chip(
                                  avatar: CircleAvatar(
                                      backgroundColor: Colors.black,
                                      child: Icon(Icons.edit_rounded)),
                                  label: Text('Editado'),
                                )
                            ],
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: false,
                              scrollDirection: Axis.horizontal,
                              itemCount: products.length,
                              itemBuilder: (BuildContext context, int index) {
                                final product = products[index];
                                return Container(
                                    padding: EdgeInsets.only(right: 0),
                                    child: FadeInLeft(
                                        delay:
                                            Duration(milliseconds: 200 * index),
                                        child: _buildBox(product: product)));
                              },
                            ),
                          )

                          /*  Row(
                            children: <Widget>[cryptoAmount()],
                          ), */
                        ],
                      ))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget _buildBox({Product product}) {
    final currentTheme = Provider.of<ThemeChanger>(context);

    final quantityDispensary = product.quantityDispensary;

    return Container(
      child: Stack(
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.all(Radius.circular(100.0)),
            child: Container(
              padding: const EdgeInsets.all(2.0),
              decoration: new BoxDecoration(
                color: currentTheme.currentTheme.cardColor, // border color
                shape: BoxShape.circle,
              ),
              width: 70,
              height: 70,
              child: Material(
                  type: MaterialType.transparency,
                  child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100)),
                      ),
                      child: ClipRRect(
                          borderRadius:
                              BorderRadius.all(Radius.circular(100.0)),
                          child: CircleAvatar(
                            backgroundColor: (currentTheme.customTheme)
                                ? Colors.black
                                : Colors.white,
                            foregroundColor: (currentTheme.customTheme)
                                ? Colors.black
                                : Colors.white,
                            child: Container(
                              color: Colors.white,
                              width: 100,
                              height: 100,
                              child: cachedNetworkImage(product.getCoverImg()),
                            ),
                          )))),
            ),
          ),
          Container(
            decoration: new BoxDecoration(
              color: Colors.black,
              shape: BoxShape.circle,
            ),
            margin: EdgeInsets.only(left: 50, top: 0),
            width: 30.0,
            height: 30.0,
            child: Center(child: Text('$quantityDispensary')),
          ),
        ],
      ),
    );
  }

  Widget gramsRecipe() {
    final gramsRecipe = widget.dispensaryProducts.gramsRecipe;
    final currentTheme = Provider.of<ThemeChanger>(context);

    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: 'G. Receta: ',
          style: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 15),
          children: <TextSpan>[
            TextSpan(
                text: '$gramsRecipe',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget dateDelivered() {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final dateDeliveredText = widget.dispensaryProducts.dateDelivery;

    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: 'Entrega: ',
          style: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 15),
          children: <TextSpan>[
            TextSpan(
                text: (dateDeliveredText != "")
                    ? '$dateDeliveredText'
                    : 'Sin Fecha',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget dateDeliveredIcon() {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final dateDeliveredText = widget.dispensaryProducts.dateDelivery;

    return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            Icon(
              Icons.event,
              size: 20,
              color: currentTheme.currentTheme.accentColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text((dateDeliveredText != "") ? '$dateDeliveredText' : 'Sin Fecha',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold)),
          ],
        ));
  }

  Widget gramsIcon() {
    final currentTheme = Provider.of<ThemeChanger>(context);
    final gramsRecipe = widget.dispensaryProducts.gramsRecipe;

    return Align(
        alignment: Alignment.centerLeft,
        child: Row(
          children: [
            FaIcon(
              FontAwesomeIcons.handHoldingMedical,
              size: 20,
              color: currentTheme.currentTheme.accentColor,
            ),
            SizedBox(
              width: 10,
            ),
            Text('$gramsRecipe ',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 18,
                    fontWeight: FontWeight.bold)),
            Text('Gramos receta',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white54
                        : Colors.black54,
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
          ],
        ));
  }

  Widget dateUpdated() {
    final DateTime dateUpdated = widget.dispensaryProducts.updatedAt;
    final currentTheme = Provider.of<ThemeChanger>(context);

    final DateFormat formatter = DateFormat('dd MMMM');
    final String formatted = formatter.format(dateUpdated);

    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: 'Actualizado: ',
          style: TextStyle(
              fontWeight: FontWeight.normal, color: Colors.grey, fontSize: 15),
          children: <TextSpan>[
            TextSpan(
                text: '$formatted',
                style: TextStyle(
                    color: (currentTheme.customTheme)
                        ? Colors.white
                        : Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.normal)),
          ],
        ),
      ),
    );
  }

  Widget changeIcon() {
    return Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.ac_unit,
          color: Colors.green,
          size: 30,
        ));
  }

  Widget cryptoAmount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'sdfsdfds',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'sdfsdfsdf',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget cachedNetworkImage(String image) {
  return CachedNetworkImage(
    imageUrl: image,
    imageBuilder: (context, imageProvider) => Container(
      decoration: BoxDecoration(
        image: DecorationImage(
            image: imageProvider,
            fit: BoxFit.cover,
            colorFilter:
                ColorFilter.mode(Colors.transparent, BlendMode.colorBurn)),
      ),
    ),
    placeholder: (context, url) => Container(
      child: Container(
        child: Image(
          image: AssetImage('assets/loading2.gif'),
          fit: BoxFit.cover,
          width: double.maxFinite,
        ),
      ),
    ),
    errorWidget: (context, url, error) => Icon(Icons.error),
  );
}

class Dashboard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
      height: 220,
      width: double.maxFinite,
      child: Card(
        elevation: 5,
        child: Padding(
          padding: EdgeInsets.all(7),
          child: Stack(children: <Widget>[
            Align(
              alignment: Alignment.centerRight,
              child: Stack(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.only(left: 10, top: 5),
                      child: Column(
                        children: <Widget>[
                          Row(
                            children: <Widget>[
                              cryptoNameSymbol(),
                              Spacer(),
                              cryptoChange(),
                              SizedBox(
                                width: 10,
                              ),
                              changeIcon(),
                              SizedBox(
                                width: 20,
                              )
                            ],
                          ),
                          Row(
                            children: <Widget>[cryptoAmount()],
                          )
                        ],
                      ))
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }

  Widget cryptoNameSymbol() {
    return Align(
      alignment: Alignment.centerLeft,
      child: RichText(
        text: TextSpan(
          text: 'Bitcoin',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.black, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '',
                style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget cryptoChange() {
    return Align(
      alignment: Alignment.topRight,
      child: RichText(
        text: TextSpan(
          text: '234',
          style: TextStyle(
              fontWeight: FontWeight.bold, color: Colors.green, fontSize: 20),
          children: <TextSpan>[
            TextSpan(
                text: '324',
                style: TextStyle(
                    color: Colors.green,
                    fontSize: 15,
                    fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }

  Widget changeIcon() {
    return Align(
        alignment: Alignment.topRight,
        child: Icon(
          Icons.ac_unit,
          color: Colors.green,
          size: 30,
        ));
  }

  Widget cryptoAmount() {
    return Align(
      alignment: Alignment.centerLeft,
      child: Padding(
        padding: const EdgeInsets.only(left: 20.0),
        child: Row(
          children: <Widget>[
            RichText(
              textAlign: TextAlign.left,
              text: TextSpan(
                text: 'sdfsdfds',
                style: TextStyle(
                  color: Colors.grey,
                  fontSize: 35,
                ),
                children: <TextSpan>[
                  TextSpan(
                      text: 'sdfsdfsdf',
                      style: TextStyle(
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                          fontSize: 20,
                          fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
