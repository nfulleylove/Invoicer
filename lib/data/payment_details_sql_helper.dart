import 'package:sqflite/sqflite.dart';

import '../models/payment_details_model.dart';
import 'invoices_database.dart';

class PaymentDetailsSqlHelper {
  final Future<Database?> db = InvoicesDatabase().database;

  static const String tablePaymentDetails = 'PaymentDetails';

  static const String colId = 'id';
  static const String colNameOnCard = 'nameOnCard';
  static const String colAccountNumber = 'accountNumber';
  static const String colSortCode = 'sortCode';
  static const String colRate = 'rate';

  Future<PaymentDetailsModel> getPaymentDetails(int id) async {
    var database = await db;

    List<Map<String, dynamic>> map = await database!.query(tablePaymentDetails,
        where: '$colId = ?', whereArgs: [id], limit: 1);

    return PaymentDetailsModel.fromMap(
        map.isNotEmpty ? map.first : <String, dynamic>{});
  }

  Future<int> insert(PaymentDetailsModel paymentDetails) async {
    var database = await db;

    int result = await database!.insert(
        tablePaymentDetails, paymentDetails.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return result;
  }

  Future<bool> updatePaymentDetails(PaymentDetailsModel paymentDetails) async {
    var database = await db;

    int result = await database!.update(
        tablePaymentDetails, paymentDetails.toMap(),
        where: '$colId = ?', whereArgs: [paymentDetails.id]);

    return result == 1;
  }
}
