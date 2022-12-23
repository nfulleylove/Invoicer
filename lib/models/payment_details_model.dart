import 'package:invoicer/data/payment_details_sql_helper.dart';

class PaymentDetailsModel {
  int id = 1;
  String nameOnCard;
  String accountNumber;
  String sortCode;
  double rate;

  PaymentDetailsModel(
      this.id, this.nameOnCard, this.accountNumber, this.sortCode, this.rate);

  factory PaymentDetailsModel.fromMap(Map<String, dynamic> map) {
    var model = PaymentDetailsModel(
        map[PaymentDetailsSqlHelper.colId] ?? 1,
        map[PaymentDetailsSqlHelper.colNameOnCard] ?? '',
        map[PaymentDetailsSqlHelper.colAccountNumber] ?? '',
        map[PaymentDetailsSqlHelper.colSortCode] ?? '',
        map[PaymentDetailsSqlHelper.colRate] ?? 0);

    return model;
  }

  Map<String, dynamic> toMap() {
    return {
      PaymentDetailsSqlHelper.colNameOnCard: nameOnCard,
      PaymentDetailsSqlHelper.colAccountNumber: accountNumber,
      PaymentDetailsSqlHelper.colSortCode: sortCode,
      PaymentDetailsSqlHelper.colRate: rate
    };
  }
}
