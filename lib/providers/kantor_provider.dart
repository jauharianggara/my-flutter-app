import 'package:flutter/foundation.dart';
import '../models/kantor.dart';
import '../services/kantor_service.dart';

class KantorProvider with ChangeNotifier {
  List<Kantor> _kantors = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Kantor> get kantors => _kantors;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadKantors() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KantorService.getAllKantors();

      if (response.success && response.data != null) {
        _kantors = response.data!;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createKantor(CreateKantorRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KantorService.createKantor(request);

      if (response.success) {
        await loadKantors(); // Reload the list
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateKantor(int id, UpdateKantorRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KantorService.updateKantor(id, request);

      if (response.success) {
        await loadKantors(); // Reload the list
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteKantor(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KantorService.deleteKantor(id);

      if (response.success) {
        await loadKantors(); // Reload the list
        return true;
      } else {
        _errorMessage = response.message;
        _isLoading = false;
        notifyListeners();
        return false;
      }
    } catch (e) {
      _errorMessage = e.toString();
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
