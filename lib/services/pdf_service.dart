import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import '../models/grade.dart';
import '../models/student.dart';
//import 'package:flutter/services.dart';

class PdfService {
  static Future<void> generateReportCard(
    Student student,
    List<Grade> grades,
    String semester,
    String academicYear,
  ) async {
    final pdf = pw.Document();

    final font = await PdfGoogleFonts.nunitoRegular();
    final boldFont = await PdfGoogleFonts.nunitoBold();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'LAPORAN HASIL BELAJAR',
                        style: pw.TextStyle(
                          font: boldFont,
                          fontSize: 18,
                        ),
                      ),
                      pw.SizedBox(height: 8),
                      pw.Text(
                        'Semester: $semester',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                        ),
                      ),
                      pw.Text(
                        'Tahun Ajaran: $academicYear',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  pw.Container(
                    width: 80,
                    height: 80,
                    decoration: pw.BoxDecoration(
                      border: pw.Border.all(color: PdfColors.grey300),
                    ),
                    child: pw.Center(
                      child: pw.Text(
                        'Logo',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 12,
                          color: PdfColors.grey500,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 24),
              
              // Student Info
              pw.Container(
                padding: const pw.EdgeInsets.all(12),
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'NIS',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            ': ${student.nis}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Nama',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            ': ${student.name}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Kelas',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            ': ${student.className}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                    pw.SizedBox(height: 4),
                    pw.Row(
                      children: [
                        pw.Expanded(
                          flex: 1,
                          child: pw.Text(
                            'Jurusan',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                        pw.Expanded(
                          flex: 3,
                          child: pw.Text(
                            ': ${student.major}',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              pw.SizedBox(height: 24),
              
              // Grades Table
              pw.Table(
                border: pw.TableBorder.all(color: PdfColors.grey300),
                columnWidths: {
                  0: const pw.FixedColumnWidth(30),
                  1: const pw.FlexColumnWidth(2),
                  2: const pw.FlexColumnWidth(1),
                  3: const pw.FlexColumnWidth(1),
                  4: const pw.FlexColumnWidth(1),
                  5: const pw.FlexColumnWidth(1),
                  6: const pw.FlexColumnWidth(1),
                },
                children: [
                  // Table Header
                  pw.TableRow(
                    decoration: const pw.BoxDecoration(color: PdfColors.grey200),
                    children: [
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'No',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'Mata Pelajaran',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'Tugas',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'UTS',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'UAS',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'Nilai Akhir',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                      pw.Container(
                        padding: const pw.EdgeInsets.all(8),
                        child: pw.Center(
                          child: pw.Text(
                            'Predikat',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 10,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Table Rows
                  ...grades.asMap().entries.map((entry) {
                    final index = entry.key + 1;
                    final grade = entry.value;
                    return pw.TableRow(
                      children: [
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              '$index',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            grade.subject,
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              '${grade.assignment}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              '${grade.midTerm}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              '${grade.finalExam}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              '${grade.finalScore}',
                              style: pw.TextStyle(
                                font: font,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ),
                        pw.Container(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Center(
                            child: pw.Text(
                              grade.predicate,
                              style: pw.TextStyle(
                                font: boldFont,
                                fontSize: 10,
                                color: grade.predicate == 'A'
                                    ? PdfColors.green
                                    : grade.predicate == 'B'
                                        ? PdfColors.blue
                                        : grade.predicate == 'C'
                                            ? PdfColors.orange
                                            : PdfColors.red,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  }).toList(),
                ],
              ),
              pw.SizedBox(height: 24),
              
              // Summary
              pw.Row(
                children: [
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Catatan:',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            'A = Sangat Baik (≥ 85)',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            'B = Baik (75 – 84)',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            'C = Cukup (65 – 74)',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                          pw.Text(
                            'D = Kurang (< 65)',
                            style: pw.TextStyle(
                              font: font,
                              fontSize: 10,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  pw.SizedBox(width: 16),
                  pw.Expanded(
                    child: pw.Container(
                      padding: const pw.EdgeInsets.all(12),
                      decoration: pw.BoxDecoration(
                        border: pw.Border.all(color: PdfColors.grey300),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Rata-rata Nilai:',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 12,
                            ),
                          ),
                          pw.SizedBox(height: 8),
                          pw.Text(
                            '${grades.isEmpty ? 0 : grades.map((g) => g.finalScore).reduce((a, b) => a + b) / grades.length}',
                            style: pw.TextStyle(
                              font: boldFont,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 32),
              
              // Footer
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 120,
                        height: 40,
                      ),
                      pw.Text(
                        'Orang Tua/Wali',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                  pw.Column(
                    children: [
                      pw.Container(
                        width: 120,
                        height: 40,
                      ),
                      pw.Text(
                        'Wali Kelas',
                        style: pw.TextStyle(
                          font: font,
                          fontSize: 10,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}