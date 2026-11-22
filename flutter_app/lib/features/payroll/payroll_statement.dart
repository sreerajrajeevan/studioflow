import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../core/format.dart';
import '../../domain/models.dart';

/// A shareable/printable salary statement for one payroll run,
/// built purely from the run's frozen line snapshots — later edits
/// to employees or attendance never change it.
class PayrollStatement {
  const PayrollStatement({
    required this.studioName,
    required this.run,
    required this.lines,
  });

  final String studioName;
  final PayrollRun run;
  final List<PayrollLine> lines;

  int get totalGross => lines.fold(0, (s, l) => s + l.grossPaise);
  int get totalAdvances => lines.fold(0, (s, l) => s + l.advancesPaise);
  int get totalDeductions => lines.fold(0, (s, l) => s + l.deductionsPaise);
  int get totalNet => lines.fold(0, (s, l) => s + l.netPaise);
  int get totalPaid => lines.fold(0, (s, l) => s + l.paidPaise);

  String statusLabel() => switch (run.status) {
        PayrollRunStatus.draft => 'DRAFT — not approved',
        PayrollRunStatus.approved => 'Approved',
        PayrollRunStatus.partiallyPaid => 'Partially paid',
        PayrollRunStatus.paid => 'Paid',
        PayrollRunStatus.voided => 'VOIDED',
      };

  /// Fixed-width text statement (thermal-printer friendly layout).
  String formatText({int width = 42}) {
    String row(String label, String value) {
      final spaces = width - label.length - value.length;
      return '$label${' ' * (spaces < 1 ? 1 : spaces)}$value';
    }

    final out = StringBuffer();
    out.writeln(studioName);
    out.writeln('Salary statement — ${run.periodKey}');
    out.writeln('Status: ${statusLabel()}');
    if (run.approvedBy != null) {
      out.writeln('Approved by ${run.approvedBy}');
    }
    out.writeln('-' * width);
    for (final line in lines) {
      out.writeln(line.employeeName);
      out.writeln(row(
        '  P ${line.counts.present} · H ${line.counts.halfDays} · '
        'L ${line.counts.leave} · A ${line.counts.absent}',
        '',
      ));
      out.writeln(row('  Gross', inr(line.grossPaise)));
      if (line.advancesPaise != 0) {
        out.writeln(
            row('  Advances', '-${inr(line.advancesPaise)}'));
      }
      if (line.deductionsPaise != 0) {
        out.writeln(
            row('  Deductions', '-${inr(line.deductionsPaise)}'));
      }
      out.writeln(row('  Net payable', inr(line.netPaise)));
      out.writeln(row('  Paid', inr(line.paidPaise)));
      if (line.carryForwardPaise > 0) {
        out.writeln(row('  Carried forward',
            inr(line.carryForwardPaise)));
      }
    }
    out.writeln('-' * width);
    out.writeln(row('Total gross', inr(totalGross)));
    out.writeln(row('Total advances', inr(totalAdvances)));
    out.writeln(row('Total net payable', inr(totalNet)));
    out.writeln(row('Total paid', inr(totalPaid)));
    out.writeln(row('Outstanding', inr(totalNet - totalPaid)));
    return out.toString();
  }

  Future<Uint8List> buildPdf() async {
    final doc = pw.Document();
    final text = formatText(width: 64);
    doc.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a5,
        build: (context) => pw.Text(
          text,
          style: const pw.TextStyle(fontSize: 9, lineSpacing: 3),
        ),
      ),
    );
    return doc.save();
  }
}
