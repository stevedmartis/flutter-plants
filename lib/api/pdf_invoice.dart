import 'dart:io';
import 'package:leafety/api/pdf_api.dart';
import 'package:leafety/models/invoice.dart';

import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/widgets.dart';

import 'package:http/http.dart' as http;
import '../utils.dart';

class PdfInvoiceApi {
  static Future<File> generate(Report report) async {
    final pdf = Document();

    Directory tempDir = await getApplicationDocumentsDirectory();
    String tempPath = tempDir.path;
    bool imageUpload = (report.profile.imageAvatar != "") ? true : false;

/*   var seacg = 'google'
     RegExp exp = new RegExp( "\\b" + search + "\\b", caseSensitive: false, ); 
    bool containe = exp.hasMatch(str);
 */

    if (imageUpload) {
      if (!report.profile.isGoogle) {
        String nameImage = (imageUpload)
            ? report.profile.imageAvatar.replaceAll('/avatar', '')
            : "";
        File file = new File('$tempPath' + (nameImage));

        final urlImage = Uri.https('leafety-images.s3.us-east-2.amazonaws.com',
            report.profile.imageAvatar);
        final response = await http.get(urlImage);

        await file.writeAsBytes(response.bodyBytes);

        final image = pw.MemoryImage(
          File(file.path).readAsBytesSync(),
        );

        pdf.addPage(MultiPage(
          build: (context) => [
            buildHeader(report, image),
            SizedBox(height: 1.5 * PdfPageFormat.cm),
            buildTitle(report),
            if (report.rooms.length > 0) buildTitleRooms(),
            if (report.rooms.length > 0) buildRooms(report),
            if (report.plants.length > 0) buildTitlePlants(),
            if (report.plants.length > 0) buildPlants(report),
            if (report.visits.length > 0) buildTitleVisits(),
            if (report.visits.length > 0) buildVisits(report),
            Divider(),
            if (report.visits.length > 0) buildTotal(report),
            SizedBox(height: 2.0),
            if (report.subscriptionsDispensary.length > 0)
              buildTitleDispensary(),
            if (report.subscriptionsDispensary.length > 0)
              buildSubscriptionsDispensaries(report),
            if (report.subscriptionsDispensary.length > 0) Divider(),
            if (report.subscriptionsDispensary.length > 0) buildGTotal(report),
          ],
          footer: (context) => buildFooter(report),
        ));
      } else {
        String nameImageGoogle = (imageUpload)
            ? report.profile.imageAvatar.replaceAll('/a-', '')
            : "";

        File file = new File('$tempPath' + (nameImageGoogle));

        final urlImageGoogle =
            Uri.https('lh3.googleusercontent.com', report.profile.imageAvatar);

        final responseGoogle = await http.get(urlImageGoogle);

        await file.writeAsBytes(responseGoogle.bodyBytes);

        final image = pw.MemoryImage(
          File(file.path).readAsBytesSync(),
        );

        pdf.addPage(MultiPage(
          build: (context) => [
            buildHeader(report, image),
            SizedBox(height: 1.5 * PdfPageFormat.cm),
            buildTitle(report),
            if (report.rooms.length > 0) buildTitleRooms(),
            if (report.rooms.length > 0) buildRooms(report),
            if (report.plants.length > 0) buildTitlePlants(),
            if (report.plants.length > 0) buildPlants(report),
            if (report.visits.length > 0) buildTitleVisits(),
            if (report.visits.length > 0) buildVisits(report),
            Divider(),
            if (report.visits.length > 0) buildTotal(report),
            SizedBox(height: 2.0),
            if (report.plants.length > 0) buildTitleDispensary(),
            if (report.subscriptionsDispensary.length > 0)
              buildSubscriptionsDispensaries(report),
            Divider(),
            if (report.visits.length > 0) buildGTotal(report),
          ],
          footer: (context) => buildFooter(report),
        ));
      }
    } else {
      pdf.addPage(MultiPage(
        build: (context) => [
          buildHeaderNotImage(report),
          SizedBox(height: 1.5 * PdfPageFormat.cm),
          buildTitle(report),
          if (report.rooms.length > 0) buildTitleRooms(),
          if (report.rooms.length > 0) buildRooms(report),
          if (report.plants.length > 0) buildTitlePlants(),
          if (report.plants.length > 0) buildPlants(report),
          if (report.visits.length > 0) buildTitleVisits(),
          if (report.visits.length > 0) buildVisits(report),
          Divider(),
          if (report.visits.length > 0) buildTotal(report),
        ],
        footer: (context) => buildFooter(report),
      ));
    }
    return PdfApi.saveDocument(name: 'mi_reporte.pdf', pdf: pdf);
  }

  static Widget buildHeader(Report invoice, imageProvider) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          pw.Container(
            width: 100,
            height: 100,
            child: pw.Image(imageProvider),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildSupplierAddress(invoice.profile),
              Container(
                height: 100,
                width: 100,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: 'https://leafety.com/',
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );

  static Widget buildHeaderNotImage(Report invoice) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              pw.Container(
                width: 100,
                height: 100,
                decoration: pw.BoxDecoration(
                  shape: BoxShape.circle,
                  border: new Border.all(
                    width: 1,
                  ),
                ),
                child: Center(
                  child: Text(
                    invoice.profile.username.substring(0, 2).toUpperCase(),
                    style: TextStyle(fontSize: 30),
                  ),
                ),
              ),
              buildSupplierAddress(invoice.profile),
              Container(
                height: 100,
                width: 100,
                child: BarcodeWidget(
                  barcode: Barcode.qrCode(),
                  data: 'https://leafety.com/',
                ),
              ),
            ],
          ),
          SizedBox(height: 1 * PdfPageFormat.cm),
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              buildCustomerAddress(invoice.customer),
              buildInvoiceInfo(invoice.info),
            ],
          ),
        ],
      );
  static Widget buildCustomerAddress(Customer customer) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(customer.name, style: TextStyle(fontWeight: FontWeight.bold)),
          Text(customer.email),
        ],
      );

  static Widget buildInvoiceInfo(InvoiceInfo info) {
    final paymentTerms = '${info.dueDate.difference(info.date).inDays} days';
    final titles = <String>[
      'Numero reporte:',
      'Fecha reporte:',
      // 'Payment Terms:',
      //'Due Date:'
    ];
    final data = <String>[
      info.number,
      Utils.formatDate(info.date),
      paymentTerms,
      Utils.formatDate(info.dueDate),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(titles.length, (index) {
        final title = titles[index];
        final value = data[index];

        return buildText(title: title, value: value, width: 200);
      }),
    );
  }

  static Widget buildSupplierAddress(Profile profile) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (profile.isClub)
            Text(profile.rutClub,
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text(profile.name,
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
          SizedBox(height: 2 * PdfPageFormat.mm),
          Text(profile.email),
          SizedBox(height: 10),
          pw.Container(
            width: 200,
            child: Text(profile.about, maxLines: 5),
          ),
        ],
      );

  static Widget buildTitle(Report report) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Reporte de Siembra',
            style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          SizedBox(height: 0.5 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitleRooms() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Habitaciones',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitlePlants() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text(
            'Plantas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitleVisits() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text(
            'Visitas',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ],
      );

  static Widget buildTitleDispensary() => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 0.5 * PdfPageFormat.cm),
          Text(
            'Dispensario',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
          SizedBox(height: 0.4 * PdfPageFormat.cm),
        ],
      );

  static Widget buildRooms(Report report) {
    final headers = [
      'Nombre',
      'Creación',
      //'Descripción',
      'N° Plantas',
      'N° Luces',
      'N° Aires',
    ];
    final data = report.rooms.map((item) {
      return [
        item.name,
        //item.description,
        Utils.formatDate(item.date),
        '${item.totalPlants}',
        '${item.totalAirs}',
        '${item.totalLights}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildPlants(Report report) {
    final headers = [
      'Nombre',
      'Creación',
      //'Descripción',
      'Cantidad',
      'CBD',
      'THC',
      'Germinación',
      'Semanas Flora'
    ];
    final data = report.plants.map((item) {
      return [
        item.name,
        //item.description,
        Utils.formatDate(item.date),
        '${item.quantity}',
        '${item.cbd}',
        '${item.thc}',
        '${item.germination}',
        '${item.floration}',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
      },
    );
  }

  static Widget buildVisits(Report report) {
    final headers = [
      'Creación',
      'Grados °',
      'Lt Agua',
      'Ph',
      'Conductor',
      'Abono',
      'Lt Abono',
      'Gramos'
    ];
    final data = report.visits.map((item) {
      return [
        //item.description,
        Utils.formatDate(item.date),
        (item.degrees != null) ? '${item.degrees}' : '0',
        (item.ml != null) ? '${item.ml}' : '0',
        (item.ph != null) ? '${item.ph}' : '0',
        (item.electro != null) ? '${item.electro}' : '0',
        (item.nameAbono != null) ? '${item.nameAbono}' : 'No',
        (item.mlAbono != null) ? '${item.mlAbono}' : '0',
        (item.grams != null) ? '${item.grams}' : '0',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
      },
    );
  }

  static Widget buildSubscriptionsDispensaries(Report report) {
    final headers = [
      'Miembro',
      'Suscripción',
      'G.Receta',
      'Estado',
      'Entrega',
      'G.Dispensados'
    ];
    final data = report.subscriptionsDispensary.map((item) {
      return [
        //item.description,

        (item.subscriptor.name != null)
            ? '${item.subscriptor.name}'
            : '${item.subscriptor.user.username}', //miembro
        Utils.formatDate(item.subscription.updatedAt), // date suscription
        item.gramsRecipe, // gramos receta

        (item.isActive && !item.isDelivered) // estado
            ? 'En Curso'
            : (item.isActive && item.isDelivered)
                ? 'Entregado'
                : 'Inactivo',

        (item.isActive && !item.isDelivered) // entrega date
            ? '${item.dateDelivery}'
            : (item.isActive && item.isDelivered)
                ? '${item.dateDelivery}'
                : 'Sin Fecha',

        item.gramsTotal, // g total

        //(item.ph != null) ? '${item.ph}' : '0',
      ];
    }).toList();

    return Table.fromTextArray(
      headers: headers,
      data: data,
      border: null,
      headerStyle: TextStyle(fontWeight: FontWeight.bold),
      headerDecoration: BoxDecoration(color: PdfColors.grey300),
      cellHeight: 30,
      cellAlignments: {
        0: Alignment.centerLeft,
        1: Alignment.centerRight,
        2: Alignment.centerRight,
        3: Alignment.centerRight,
        4: Alignment.centerRight,
        5: Alignment.centerRight,
        6: Alignment.centerRight,
        7: Alignment.centerRight,
      },
    );
  }

  static Widget buildTotal(Report report) {
    final gramsTotal = report.visits
        .map((item) => int.parse(item.grams))
        .reduce((item1, item2) => item1 + item2);

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* buildText(
                  title: 'Toal Gramos',
                  value: Utils.formatPrice(34),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${1 * 100} %',
                  value: Utils.formatPrice(2),
                  unite: true,
                ), */
                Divider(),
                buildText(
                  title: 'Total Cosechados',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '$gramsTotal',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildGTotal(Report report) {
    final gramsTotal = report.subscriptionsDispensary
        .map((item) => (item.gramsTotal))
        .reduce((item1, item2) => item1 + item2);

    return Container(
      alignment: Alignment.centerRight,
      child: Row(
        children: [
          Spacer(flex: 6),
          Expanded(
            flex: 4,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /* buildText(
                  title: 'Toal Gramos',
                  value: Utils.formatPrice(34),
                  unite: true,
                ),
                buildText(
                  title: 'Vat ${1 * 100} %',
                  value: Utils.formatPrice(2),
                  unite: true,
                ), */
                Divider(),
                buildText(
                  title: 'Total Dispensados',
                  titleStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  value: '$gramsTotal',
                  unite: true,
                ),
                SizedBox(height: 2 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
                SizedBox(height: 0.5 * PdfPageFormat.mm),
                Container(height: 1, color: PdfColors.grey400),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static Widget buildFooter(Report report) => Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Divider(),
          SizedBox(height: 2 * PdfPageFormat.mm),
          /*   buildSimpleText(
              title: 'Correo electrónico', value: report.profile.email), */
          SizedBox(height: 1 * PdfPageFormat.mm),
          buildSimpleText(title: 'Por', value: report.profile.siteInfo),
        ],
      );

  static buildSimpleText({
    String title,
    String value,
  }) {
    final style = TextStyle(fontWeight: FontWeight.bold);

    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: pw.CrossAxisAlignment.end,
      children: [
        Text(title, style: style),
        SizedBox(width: 2 * PdfPageFormat.mm),
        Text(value),
      ],
    );
  }

  static buildText({
    String title,
    String value,
    double width = double.infinity,
    TextStyle titleStyle,
    bool unite = false,
  }) {
    final style = titleStyle ?? TextStyle(fontWeight: FontWeight.bold);

    return Container(
      width: width,
      child: Row(
        children: [
          Expanded(child: Text(title, style: style)),
          Text(value, style: unite ? style : null),
        ],
      ),
    );
  }
}
