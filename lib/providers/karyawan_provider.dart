import 'package:flutter/foundation.dart';
import '../models/karyawan.dart';
import '../services/karyawan_service.dart';

class KaryawanProvider with ChangeNotifier {
  List<KaryawanWithKantor> _karyawans = [];
  bool _isLoading = false;
  String? _errorMessage;

  List<KaryawanWithKantor> get karyawans => _karyawans;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> loadKaryawans() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KaryawanService.getAllKaryawansWithKantor();

      if (response.success && response.data != null) {
        _karyawans = response.data!;
      } else {
        _errorMessage = response.message;
      }
    } catch (e) {
      _errorMessage = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<bool> createKaryawan(CreateKaryawanRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KaryawanService.createKaryawan(request);

      if (response.success) {
        await loadKaryawans(); // Reload the list
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

  Future<bool> updateKaryawan(int id, UpdateKaryawanRequest request) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KaryawanService.updateKaryawan(id, request);

      if (response.success) {
        await loadKaryawans(); // Reload the list
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

  Future<bool> deleteKaryawan(int id) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await KaryawanService.deleteKaryawan(id);

      if (response.success) {
        await loadKaryawans(); // Reload the list
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