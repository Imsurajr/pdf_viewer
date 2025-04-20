import 'package:flutter/material.dart';
import '../model/pdf_model.dart';

class PDFController with ChangeNotifier {
  final PDFDocumentModel _model =
      PDFDocumentModel(assetPath: 'assets/pdfs/coding.pdf');
  bool _isLoading = true;
  String? _errorMessage;

  // getting necessary details of the model
  PDFDocumentModel get model => _model;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  PDFController() {
    _initPDF();
  }

  Future<void> _initPDF() async {
    // error handling using try catch
    try {
      _isLoading = true;
      notifyListeners();

      await _model.prepareFromAsset();

      _isLoading = false;
      _errorMessage = null;
    } catch (e) {
      _isLoading = false;
      _errorMessage = e.toString();
      notifyListeners();
    }
    notifyListeners();
  }

  // next page method
  void goToNextPage() {
    if (_model.currentPage < _model.totalPages) {
      _model.currentPage++;
      notifyListeners();
    }
  }

  // previous page method
  void goToPreviousPage() {
    if (_model.currentPage > 1) {
      _model.currentPage--;
      notifyListeners();
    }
  }

  // setting page to current page
  void setPage(int pageNumber) {
    if (pageNumber >= 1 && pageNumber <= _model.totalPages) {
      _model.currentPage = pageNumber;
      notifyListeners();
    }
  }

  // updating page for page number
  void updateTotalPages(int count) {
    _model.totalPages = count;
    notifyListeners();
  }
}
