import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/format.dart';
import '../../domain/models.dart';

/// Platform-independent invoice presentation (Task 3 §8).
///
/// An [InvoiceDocument] is pure data derived from a [FinalizedBill] —
/// no financial calculation happens here; every amount is read from the
/// finalized record. Formatters (plain-text thermal layout, PDF) render
/// the document without touching billing logic.
class InvoiceDocument {
  InvoiceDocument.fromBill(FinalizedBill bill)
      : studioName = bill.studio.businessName,
        tagline = bill.studio.tagline,
        address = bill.studio.address,
        phone = bill.studio.phone,
        email = bill.studio.email,
        gstin = bill.studio.gstin,
        footer = bill.studio.invoiceFooter,
        primaryColor = bill.studioPrimaryColor,
        provisionalRef = bill.provisionalRef,
        isVoided = bill.status == FinalizedBillStatus.voided,
        customerName = bill.customerName,
        customerPhone = bill.customerPhone,
        billingEmployeeName = bill.billingEmployeeName,
        issuedAt = bill.finalizedAt,
        lines = bill.lines,
        subtotalPaise = bill.subtotalPaise,
        discountPercent = bill.discountPercent,
        discountPaise = bill.discountPaise,
        taxBasisPoints = bill.taxBasisPoints,
        taxPaise = bill.taxPaise,
        totalPaise = bill.totalPaise,
        payments = bill.payments,
        paymentStatus = bill.paymentStatus;

  final String studioName;
  final String? tagline;
  final String address;
  final String phone;
  final String? email;
  final String? gstin;
  final String? footer;
  final int primaryColor;
  final String provisionalRef;
  final bool isVoided;
  final String customerName;
  final String customerPhone;
  final String? billingEmployeeName;
  final DateTime issuedAt;
  final List<BillLine> lines;
  final int subtotalPaise;
  final int discountPercent;
  final int discountPaise;
  final int taxBasisPoints;
  final int taxPaise;
  final int totalPaise;
  final List<BillPayment> payments;
  final PaymentStatus paymentStatus;

  String get paymentStatusLabel => switch (paymentStatus) {
        PaymentStatus.pending => 'PAYMENT PENDING',
        PaymentStatus.confirmedManual => 'PAID (manually confirmed)',
        PaymentStatus.verifiedProvider => 'PAID (provider verified)',
      };

  static String methodLabel(PaymentMethod method) => switch (method) {
        PaymentMethod.cash => 'Cash',
        PaymentMethod.upi => 'UPI',
        PaymentMethod.card => 'Card',
      };

  static String paymentLineLabel(BillPayment payment) {
    final status = switch (payment.status) {
      PaymentStatus.pending => 'pending',
      PaymentStatus.confirmedManual => 'manually confirmed',
      PaymentStatus.verifiedProvider => 'provider verified',
    };
    return '${methodLabel(payment.method)} ${inr(payment.amountPaise)} — $status';
  }
}

String _two(int v) => v.toString().padLeft(2, '0');

String formatInvoiceDateTime(DateTime t) =>
    '${_two(t.day)}/${_two(t.month)}/${t.year} '
    '${_two(t.hour)}:${_two(t.minute)}';

/// Thermal-receipt layout abstraction: a fixed-width plain-text
/// rendering suitable for 58mm/80mm printers and for sharing as text.
/// (Bluetooth thermal printing itself is NOT implemented — it needs
/// real printer hardware to verify; this formatter is the layout such
/// a driver would consume.)
String formatTextReceipt(InvoiceDocument doc, {int width = 40}) {
  String center(String text) {
    if (text.length >= width) return text;
    final pad = (width - text.length) ~/ 2;
    return '${' ' * pad}$text';
  }

  String row(String left, String right) {
    if (left.length + right.length + 1 > width) {
      return '$left\n${right.padLeft(width)}';
    }
    return left.padRight(width - right.length) + right;
  }

  final out = StringBuffer();
  out.writeln(center(doc.studioName));
  if (doc.tagline != null && doc.tagline!.isNotEmpty) {
    out.writeln(center(doc.tagline!));
  }
  if (doc.address.isNotEmpty) out.writeln(center(doc.address));
  final contact = [
    if (doc.phone.isNotEmpty) doc.phone,
    if (doc.email != null && doc.email!.isNotEmpty) doc.email!,
  ].join(' · ');
  if (contact.isNotEmpty) out.writeln(center(contact));
  if (doc.gstin != null && doc.gstin!.isNotEmpty) {
    out.writeln(center('GSTIN: ${doc.gstin}'));
  }
  out.writeln('-' * width);
  out.writeln(row('Invoice (local ref)', doc.provisionalRef));
  out.writeln(row('Date', formatInvoiceDateTime(doc.issuedAt)));
  if (doc.customerName.isNotEmpty) {
    out.writeln(row('Customer', doc.customerName));
  }
  if (doc.customerPhone.isNotEmpty) {
    out.writeln(row('Mobile', doc.customerPhone));
  }
  if (doc.billingEmployeeName != null) {
    out.writeln(row('Billed by', doc.billingEmployeeName!));
  }
  if (doc.isVoided) out.writeln(center('*** VOIDED ***'));
  out.writeln('-' * width);
  for (final line in doc.lines) {
    out.writeln(row(
      '${line.serviceName} x${line.quantity}',
      inr(line.lineTotalPaise),
    ));
    if (line.employeeName != null && line.employeeName!.isNotEmpty) {
      out.writeln('  by ${line.employeeName}');
    }
    out.writeln('  ${inr(line.pricePaise)} each');
  }
  out.writeln('-' * width);
  out.writeln(row('Subtotal', inr(doc.subtotalPaise)));
  if (doc.discountPaise > 0) {
    final label =
        doc.discountPercent > 0 ? 'Discount (${doc.discountPercent}%)' : 'Discount';
    out.writeln(row(label, '-${inr(doc.discountPaise)}'));
  }
  if (doc.taxPaise > 0) {
    out.writeln(row(
      'Tax (${(doc.taxBasisPoints / 100).toStringAsFixed(doc.taxBasisPoints % 100 == 0 ? 0 : 2)}%)',
      inr(doc.taxPaise),
    ));
  }
  out.writeln(row('TOTAL', inr(doc.totalPaise)));
  out.writeln('-' * width);
  for (final payment in doc.payments) {
    out.writeln(InvoiceDocument.paymentLineLabel(payment));
  }
  out.writeln(doc.paymentStatusLabel);
  if (doc.footer != null && doc.footer!.isNotEmpty) {
    out.writeln('-' * width);
    out.writeln(center(doc.footer!));
  }
  out.writeln(center('Local provisional reference —'));
  out.writeln(center('not an official invoice number.'));
  return out.toString();
}

/// Renders the invoice as a PDF (receipt width, paginated). Pure Dart —
/// the bytes can be shared, saved, or printed by any platform channel.
Future<Uint8List> buildInvoicePdf(InvoiceDocument doc) async {
  final pdf = pw.Document();
  final accent = PdfColor.fromInt(doc.primaryColor);
  pdf.addPage(
    pw.Page(
      pageFormat: PdfPageFormat.roll80,
      margin: const pw.EdgeInsets.all(18),
      build: (context) {
        pw.Widget moneyRow(String left, String right, {bool bold = false}) {
          final style = pw.TextStyle(
            fontSize: bold ? 11 : 9,
            fontWeight: bold ? pw.FontWeight.bold : null,
          );
          return pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Expanded(child: pw.Text(left, style: style)),
              pw.Text(right, style: style),
            ],
          );
        }

        return pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.stretch,
          children: [
            pw.Text(
              doc.studioName,
              textAlign: pw.TextAlign.center,
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: accent,
              ),
            ),
            if (doc.tagline != null && doc.tagline!.isNotEmpty)
              pw.Text(doc.tagline!,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
            if (doc.address.isNotEmpty)
              pw.Text(doc.address,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
            if (doc.phone.isNotEmpty || (doc.email?.isNotEmpty ?? false))
              pw.Text(
                [doc.phone, if (doc.email != null) doc.email!]
                    .where((e) => e.isNotEmpty)
                    .join(' · '),
                textAlign: pw.TextAlign.center,
                style: const pw.TextStyle(fontSize: 8),
              ),
            if (doc.gstin != null && doc.gstin!.isNotEmpty)
              pw.Text('GSTIN: ${doc.gstin}',
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
            pw.Divider(),
            moneyRow('Invoice (local ref)', doc.provisionalRef),
            moneyRow('Date', formatInvoiceDateTime(doc.issuedAt)),
            if (doc.customerName.isNotEmpty)
              moneyRow('Customer', doc.customerName),
            if (doc.customerPhone.isNotEmpty)
              moneyRow('Mobile', doc.customerPhone),
            if (doc.billingEmployeeName != null)
              moneyRow('Billed by', doc.billingEmployeeName!),
            if (doc.isVoided)
              pw.Text('*** VOIDED ***',
                  textAlign: pw.TextAlign.center,
                  style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold, color: PdfColors.red)),
            pw.Divider(),
            for (final line in doc.lines) ...[
              moneyRow('${line.serviceName} x${line.quantity}',
                  inr(line.lineTotalPaise)),
              pw.Text(
                '  ${inr(line.pricePaise)} each'
                '${line.employeeName != null ? ' · by ${line.employeeName}' : ''}',
                style: const pw.TextStyle(fontSize: 8),
              ),
            ],
            pw.Divider(),
            moneyRow('Subtotal', inr(doc.subtotalPaise)),
            if (doc.discountPaise > 0)
              moneyRow(
                doc.discountPercent > 0
                    ? 'Discount (${doc.discountPercent}%)'
                    : 'Discount',
                '-${inr(doc.discountPaise)}',
              ),
            if (doc.taxPaise > 0)
              moneyRow('Tax', inr(doc.taxPaise)),
            moneyRow('TOTAL', inr(doc.totalPaise), bold: true),
            pw.Divider(),
            for (final payment in doc.payments)
              pw.Text(InvoiceDocument.paymentLineLabel(payment),
                  style: const pw.TextStyle(fontSize: 9)),
            pw.Text(doc.paymentStatusLabel,
                style: pw.TextStyle(
                    fontSize: 9, fontWeight: pw.FontWeight.bold)),
            if (doc.footer != null && doc.footer!.isNotEmpty) ...[
              pw.Divider(),
              pw.Text(doc.footer!,
                  textAlign: pw.TextAlign.center,
                  style: const pw.TextStyle(fontSize: 8)),
            ],
            pw.SizedBox(height: 8),
            pw.Text(
              'Local provisional reference — not an official invoice number.',
              textAlign: pw.TextAlign.center,
              style: const pw.TextStyle(fontSize: 7),
            ),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

/// Builds a UPI payment payload ONLY when the studio's own merchant
/// configuration is complete (UPI id + payee name from Settings).
/// Returns null otherwise — the app never invents a merchant, and a
/// payload is never evidence of payment.
String? buildUpiPayload({
  required String? upiId,
  required String? payeeName,
  required int amountPaise,
  required String note,
}) {
  final id = upiId?.trim() ?? '';
  final name = payeeName?.trim() ?? '';
  if (id.isEmpty || name.isEmpty || !id.contains('@')) return null;
  final amount = (amountPaise / 100).toStringAsFixed(2);
  return 'upi://pay?pa=${Uri.encodeComponent(id)}'
      '&pn=${Uri.encodeComponent(name)}'
      '&am=$amount&cu=INR'
      '&tn=${Uri.encodeComponent(note)}';
}
