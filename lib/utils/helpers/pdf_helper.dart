import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:intl/intl.dart';
import 'package:admin_panel/features/shop/models/order_model.dart';
import 'package:printing/printing.dart';

class PdfHelper {
  static Future<void> generateAndPrintOrderPdf(QuanliDonHangModel order) async {
    // Load font file from assets
    final fontData = await rootBundle.load('assets/fonts/pdf/times.ttf');
    final ttf = pw.Font.ttf(fontData);

    final pdf = pw.Document();

    pdf.addPage(
      pw.Page(
        theme: pw.ThemeData.withFont(
          base: ttf,
        ),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              pw.Header(
                level: 0,
                child: pw.Text('Chi tiết đơn hàng',
                    style: pw.TextStyle(
                        font: ttf,
                        fontSize: 24,
                        fontWeight: pw.FontWeight.bold)),
              ),
              pw.SizedBox(height: 20),
              pw.Text('Mã đơn hàng: ${order.maDonHang}', style: pw.TextStyle(font: ttf)),
              pw.Text('Trạng thái: ${order.trangThai}', style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 10),
              pw.Divider(),
              pw.SizedBox(height: 10),
              pw.Text('Thông tin khách hàng:',
                  style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
              pw.Text('Họ tên: ${order.diaChi['Name']}', style: pw.TextStyle(font: ttf)),
              pw.Text('Số điện thoại: ${order.diaChi['PhoneNumber']}', style: pw.TextStyle(font: ttf)),
              pw.Text('Địa chỉ: ${order.diaChi['Street']}, ${order.diaChi['City']}', style: pw.TextStyle(font: ttf)),
              pw.SizedBox(height: 20),
              pw.Text('Danh sách sản phẩm:',
                  style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Table(
                border: pw.TableBorder.all(),
                children: [
                  pw.TableRow(
                    children: [
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Tên sản phẩm', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Số lượng', style: pw.TextStyle(font: ttf)),
                      ),
                      pw.Padding(
                        padding: const pw.EdgeInsets.all(5),
                        child: pw.Text('Đơn giá', style: pw.TextStyle(font: ttf)),
                      ),
                    ],
                  ),
                  ...order.danhSachSanPham.map(
                    (product) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(product.tenSanPham, style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(product.soLuong.toString(), style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(5),
                          child: pw.Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                .format(product.gia),
                            style: pw.TextStyle(font: ttf),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.end,
                children: [
                  pw.Text(
                    'Tổng tiền: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(order.tongTien)}',
                    style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ],
          );
        },
      ),
    );

    await Printing.layoutPdf(
      onLayout: (format) => pdf.save(),
    );
  }

  static Future<void> generateRevenueReport({
    required DateTime date,
    required String period,
    required double revenue,
    required String title,
    required Map<int, double> dailyData,
    bool isDaily = false,
  }) async {
    try {
      final fontData = await rootBundle.load('assets/fonts/pdf/times.ttf');
      final ttf = pw.Font.ttf(fontData);

      final pdf = pw.Document();

      pdf.addPage(
        pw.MultiPage(
          theme: pw.ThemeData.withFont(base: ttf),
          pageFormat: PdfPageFormat.a4,
          build: (context) => [
            pw.Header(
              level: 0,
              child: pw.Text('Báo cáo doanh thu', 
                style: pw.TextStyle(font: ttf, fontSize: 24, fontWeight: pw.FontWeight.bold)),
            ),
            pw.SizedBox(height: 20),
            pw.Text(title,
                style: pw.TextStyle(font: ttf, fontSize: 18, fontWeight: pw.FontWeight.bold)),
            pw.SizedBox(height: 20),

            if (isDaily) ...[
              pw.Text('Chi tiết doanh thu theo ngày:',
                  style: pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold)),
              pw.SizedBox(height: 10),
              pw.Container(
                decoration: pw.BoxDecoration(
                  border: pw.Border.all(),
                  borderRadius: const pw.BorderRadius.all(pw.Radius.circular(8)),
                ),
                child: pw.Table(
                  border: pw.TableBorder.all(color: PdfColors.grey300),
                  children: [
                    // Header
                    pw.TableRow(
                      decoration: pw.BoxDecoration(color: PdfColors.grey200),
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Ngày',
                              style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Doanh thu',
                              style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold)),
                        ),
                      ],
                    ),
                    // Data rows
                    ...dailyData.entries.map((entry) => pw.TableRow(
                      children: [
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text('Ngày ${entry.key}',
                              style: pw.TextStyle(font: ttf)),
                        ),
                        pw.Padding(
                          padding: const pw.EdgeInsets.all(8),
                          child: pw.Text(
                            NumberFormat.currency(locale: 'vi_VN', symbol: '₫')
                                .format(entry.value),
                            style: pw.TextStyle(font: ttf),
                          ),
                        ),
                      ],
                    )).toList(),
                  ],
                ),
              ),
            ],

            pw.SizedBox(height: 20),
            pw.Container(
              padding: const pw.EdgeInsets.all(10),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(),
                borderRadius: const pw.BorderRadius.all(pw.Radius.circular(10)),
                color: PdfColors.grey100,
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text('Thời gian: $period',
                      style: pw.TextStyle(font: ttf, fontSize: 14)),
                  pw.SizedBox(height: 10),
                  pw.Text(
                    'Tổng doanh thu: ${NumberFormat.currency(locale: 'vi_VN', symbol: '₫').format(revenue)}',
                    style: pw.TextStyle(font: ttf, fontSize: 16, fontWeight: pw.FontWeight.bold),
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 20),
            pw.Text(
              'Ngày xuất báo cáo: ${DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now())}',
              style: pw.TextStyle(font: ttf, fontSize: 12),
            ),
          ],
        ),
      );

      await Printing.layoutPdf(
        onLayout: (format) => pdf.save(),
      );
    } catch (e) {
      print('Error generating PDF: $e'); // Debug print
      rethrow;
    }
  }
}
