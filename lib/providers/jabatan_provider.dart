import 'package:flutter/foundation.dart';
import '../models/jabatan.dart';
import '../services/jabatan_service.dart';

class JabatanProvider with ChangeNotifier {
  List<Jabatan> _jabatans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<Jabatan> get jabatans => _jabatans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadJabatans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await JabatanService.getAllJabatans();

      if (response.success && response.data != null) {
        _jabatans = response.data!;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createJabatan(CreateJabatanRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await JabatanService.createJabatan(request);

      if (response.success) {
        await loadJabatans(); // Reload the list
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

  Future<bool> updateJabatan(int id, UpdateJabatanRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await JabatanService.updateJabatan(id, request);

      if (response.success) {
        await loadJabatans(); // Reload the list
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

  Future<bool> deleteJabatan(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await JabatanService.deleteJabatan(id);

      if (response.success) {
        await loadJabatans(); // Reload the list
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
