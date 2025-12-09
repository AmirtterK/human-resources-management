import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
import 'package:path_provider/path_provider.dart';
import 'package:hr_management/classes/Employee.dart';
import 'package:intl/intl.dart';

class PdfService {
  /// Generate and save/print employee list PDF
  static Future<void> generateEmployeeListPDF(List<Employee> employees, {String title = 'Employee List'}) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (pw.Context context) {
          return [
            // Header
            pw.Header(
              level: 0,
              child: pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    title,
                    style: pw.TextStyle(
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                      color: PdfColors.teal,
                    ),
                  ),
                  pw.Text(
                    'Generated: ${DateFormat('yyyy-MM-dd HH:mm').format(DateTime.now())}',
                    style: const pw.TextStyle(fontSize: 10),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            
            // Summary
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                color: PdfColors.grey200,
                borderRadius: pw.BorderRadius.circular(5),
              ),
              child: pw.Text(
                'Total Employees: ${employees.length}',
                style: pw.TextStyle(fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ),
            pw.SizedBox(height: 20),

            // Table
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey),
              columnWidths: {
                0: const pw.FlexColumnWidth(1),
                1: const pw.FlexColumnWidth(1.5),
                2: const pw.FlexColumnWidth(1),
                3: const pw.FlexColumnWidth(1.5),
                4: const pw.FlexColumnWidth(1.5),
              },
              children: [
                // Header row
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: [
                    _buildTableCell('ID', isHeader: true),
                    _buildTableCell('Full Name', isHeader: true),
                    _buildTableCell('Rank', isHeader: true),
                    _buildTableCell('Department', isHeader: true),
                    _buildTableCell('Specialty', isHeader: true),
                  ],
                ),
                // Data rows
                ...employees.map((employee) => pw.TableRow(
                  children: [
                    _buildTableCell(employee.id),
                    _buildTableCell(employee.fullName),
                    _buildTableCell(employee.rank),
                    _buildTableCell(employee.department),
                    _buildTableCell(employee.specialty),
                  ],
                )),
              ],
            ),
          ];
        },
      ),
    );

    // Show print/share dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  /// Generate and save/print work certificate PDF
  static Future<void> generateWorkCertificatePDF(Employee employee) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(60),
        build: (pw.Context context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header
              pw.Center(
                child: pw.Column(
                  children: [
                    pw.Text(
                      'WORK CERTIFICATE',
                      style: pw.TextStyle(
                        fontSize: 28,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Divider(thickness: 2, color: PdfColors.teal),
                  ],
                ),
              ),
              pw.SizedBox(height: 40),

              // Certificate Content
              pw.Paragraph(
                text: 'This is to certify that:',
                style: const pw.TextStyle(fontSize: 14),
              ),
              pw.SizedBox(height: 20),

              // Employee Details
              _buildCertificateField('Full Name:', employee.fullName),
              pw.SizedBox(height: 12),
              
              if (employee.firstName != null && employee.lastName != null) ...[
                _buildCertificateField('First Name:', employee.firstName!),
                pw.SizedBox(height: 12),
                _buildCertificateField('Last Name:', employee.lastName!),
                pw.SizedBox(height: 12),
              ],
              
              _buildCertificateField('Employee ID:', employee.id),
              pw.SizedBox(height: 12),
              
              _buildCertificateField('Rank:', employee.rank),
              pw.SizedBox(height: 12),
              
              _buildCertificateField('Department:', employee.department),
              pw.SizedBox(height: 12),
              
              _buildCertificateField('Specialty:', employee.specialty),
              pw.SizedBox(height: 12),
              
              if (employee.dateOfBirth != null) ...[
                _buildCertificateField(
                  'Date of Birth:',
                  DateFormat('yyyy-MM-dd').format(employee.dateOfBirth!),
                ),
                pw.SizedBox(height: 12),
              ],
              
              if (employee.address != null && employee.address!.isNotEmpty) ...[
                _buildCertificateField('Address:', employee.address!),
                pw.SizedBox(height: 12),
              ],
              
              if (employee.reference != null && employee.reference!.isNotEmpty) ...[
                _buildCertificateField('Reference:', employee.reference!),
                pw.SizedBox(height: 12),
              ],
              
              _buildCertificateField('Status:', employee.status.name.toUpperCase()),
              pw.SizedBox(height: 12),
              
              _buildCertificateField('Step:', employee.step.toString()),
              pw.SizedBox(height: 30),

              // Certification Statement
              pw.Paragraph(
                text: 'This certificate is issued upon request and confirms the above information is accurate as of the date of issuance.',
                style: pw.TextStyle(fontSize: 12, fontStyle: pw.FontStyle.italic),
              ),
              pw.SizedBox(height: 40),

              // Signature Section
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'Date: ${DateFormat('yyyy-MM-dd').format(DateTime.now())}',
                        style: const pw.TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Container(
                        width: 150,
                        height: 1,
                        color: PdfColors.black,
                      ),
                      pw.SizedBox(height: 5),
                      pw.Text(
                        'Authorized Signature',
                        style: const pw.TextStyle(fontSize: 12),
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

    // Show print/share dialog
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }

  static pw.Widget _buildTableCell(String text, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
      ),
    );
  }

  static pw.Widget _buildCertificateField(String label, String value) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 120,
          child: pw.Text(
            label,
            style: pw.TextStyle(
              fontSize: 14,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ),
        pw.Expanded(
          child: pw.Text(
            value,
            style: const pw.TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }
}

