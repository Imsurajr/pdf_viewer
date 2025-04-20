import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:pdf_viewer/controller/constants/constants.dart';
import 'package:provider/provider.dart';
import '../../controller/pdf_controller.dart';

class PDFViewerScreen extends StatelessWidget {
  const PDFViewerScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // using provider for state management
    return ChangeNotifierProvider(
      create: (_) => PDFController(),
      child: const PDFViewerContent(),
    );
  }
}

class PDFViewerContent extends StatelessWidget {
  const PDFViewerContent({super.key});

  @override
  Widget build(BuildContext context) {
    void showErrorSnackBar(String message) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 5),
        ),
      );
    }

    // getting the screen orientation
    final isLandscape =
        MediaQuery.of(context).orientation == Orientation.landscape;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          appName,
          style: constantTextStyle,
        ),
        centerTitle: true,
        actions: [
          Consumer<PDFController>(
            builder: (context, controller, _) {
              return Center(
                child: Padding(
                  padding: EdgeInsets.only(right: 20.0),
                  child: Text(
                    controller.model.totalPages > 0
                        ? '${controller.model.currentPage}/${controller.model.totalPages}'
                        : '',
                    style: constantTextStyle,
                  ),
                ),
              );
            },
          ),
        ],
      ),
      body: Consumer<PDFController>(
        builder: (context, controller, _) {
          // different views for different results
          if (controller.isLoading) {
            return const Center(
              child: CircularProgressIndicator(
                color: blackColor,
              ),
            );
          }

          if (controller.errorMessage != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showErrorSnackBar(controller.errorMessage!);
            });
            return Center(
              child: Text(
                controller.errorMessage!,
                style: constantTextStyle,
              ),
            );
          }

          if (controller.model.filePath == null) {
            return const Center(
              child: Text(
                'No PDF loaded',
                style: constantTextStyle,
              ),
            );
          }

          return PDFViewerWidget(
            filePath: controller.model.filePath!,
            isLandscape: isLandscape,
            controller: controller,
          );
        },
      ),
    );
  }
}

class PDFViewerWidget extends StatelessWidget {
  final String filePath;
  final bool isLandscape;
  final PDFController controller;

  const PDFViewerWidget({
    super.key,
    required this.filePath,
    required this.isLandscape,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return PDFView(
      filePath: filePath,

      // fitting width in portrait, fit height in landscape
      fitPolicy: isLandscape ? FitPolicy.HEIGHT : FitPolicy.WIDTH,

      enableSwipe: true,

      // page change callback
      onPageChanged: (int? page, int? total) {
        if (page != null) {
          controller.setPage(page + 1);
        }
        if (total != null && controller.model.totalPages != total) {
          controller.updateTotalPages(total);
        }
      },

      onError: (error) {
        // handling any errors that occur during PDF rendering
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
            'Error: $error',
            style: constantTextStyle,
          )),
        );
      },

      // PDF load complete callback
      onRender: (pages) {
        if (pages != null && controller.model.totalPages != pages) {
          controller.updateTotalPages(pages);
        }
      },
    );
  }
}
