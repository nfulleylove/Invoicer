import 'package:flutter/material.dart';
import 'package:invoicer/data/invoices_sql_helper.dart';
import 'package:invoicer/extensions/datetime_extensions.dart';
import 'package:invoicer/models/company_model.dart';
import 'package:invoicer/models/payment_details_model.dart';
import 'package:invoicer/models/personal_details_model.dart';
import 'package:invoicer/models/work_day_model.dart';

class InvoiceModel {
  int id = -1;
  DateTime date;
  int personalDetailsId;
  int companyId;
  int paymentDetailsId;

  late PersonalDetailsModel personalDetails =
      PersonalDetailsModel(-1, '', '', '', '', '', '', '', '', '', '', '');

  late CompanyModel company = CompanyModel(-1, '', '', '', '', '', '');

  late PaymentDetailsModel paymentDetails =
      PaymentDetailsModel(-1, '', '', '', 0);

  late List<WorkDayModel> workDays = [];

  String get dateAsText => date.toShortDateString();
  String get title => 'INVOICE - ${date.toFormattedString('yyyyMMdd')}';
  String get fileName =>
      '${personalDetails.fullName} - Invoice ${date.toFormattedString('yyyyMMdd')}.pdf';

  double get totalLabourCosts =>
      workDays.fold<double>(0, (sum, element) => sum + element.rate);

  String get locationsText {
    List<String> locations = [];

    for (var workDay in workDays) {
      if (workDay.location.isNotEmpty) {
        locations.add(workDay.location);
      }
    }

    locations = locations.toSet().toList();

    switch (locations.length) {
      case 0:
        return '';
      case 1:
        return locations.first;
      default:
        return '${locations.first} + ${locations.length - 1} more';
    }
  }

  InvoiceModel(this.id, this.date, this.personalDetailsId, this.companyId,
      this.paymentDetailsId);

  factory InvoiceModel.fromMap(Map<String, dynamic> map) {
    return InvoiceModel(
      map[InvoicesSqlHelper.colId],
      DateTime.parse(map[InvoicesSqlHelper.colDate]),
      map[InvoicesSqlHelper.colPersonalDetailsId],
      map[InvoicesSqlHelper.colCompanyId],
      map[InvoicesSqlHelper.colPaymentDetailsId],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      InvoicesSqlHelper.colDate: date.toIso8601String(),
      InvoicesSqlHelper.colPersonalDetailsId: personalDetailsId,
      InvoicesSqlHelper.colCompanyId: companyId,
      InvoicesSqlHelper.colPaymentDetailsId: paymentDetailsId
    };
  }

  List<DataRow> convertDaysWorkedToTableRows() {
    List<DataRow> rows = [];

    workDays.sort((a, b) => a.date.compareTo(b.date));

    for (WorkDayModel workDay in workDays) {
      rows.add(DataRow(cells: [
        DataCell(Text(workDay.dateAsString)),
        DataCell(Text(workDay.location)),
        DataCell(Text(workDay.miles.toString())),
        DataCell(Text('£${workDay.rate.toStringAsFixed(2)}'))
      ]));
    }

    return rows;
  }
}
