import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import 'package:uqba_elibrary/controller/pdf_controller.dart';

class BookView extends StatelessWidget {
  final String bookUrl;
  final String bookName;
  const BookView({super.key, required this.bookUrl, required this.bookName});

  @override
  Widget build(BuildContext context) {
    PdfController pdfController = Get.put(PdfController());

    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          leading: BackButton(
            color: Theme.of(context).colorScheme.onSurface,
          ),
          backgroundColor: Theme.of(context).colorScheme.primary,
          title: Text(
            bookName,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(color: Theme.of(context).colorScheme.onSurface),
          ),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            pdfController.pdfViewerKey.currentState?.openBookmarkView();
          },
          child: Icon(
            Icons.bookmark,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
        body: SfPdfViewer.network(
          bookUrl,
          key: pdfController.pdfViewerKey,
        ),
      ),
    );
  }
}
