import 'package:flutter_test/flutter_test.dart';
import 'package:my_flutter_app/services/kantor_service.dart';
import 'package:my_flutter_app/services/jabatan_service.dart';
import 'package:my_flutter_app/models/kantor.dart';
import 'package:my_flutter_app/models/jabatan.dart';

void main() {
  group('Office (Kantor) and Position (Jabatan) Tests', () {
    // Kantor (Office) Tests
    group('Kantor Tests', () {
      test('CreateKantorRequest should be properly formed', () async {
        final createRequest = CreateKantorRequest(
          nama: 'Jakarta Office',
          alamat: 'Jl. Sudirman No. 123, Jakarta',
          telefon: '+62211234567',
          latitude: -6.2088,
          longitude: 106.8456,
        );

        expect(createRequest.nama, 'Jakarta Office');
        expect(createRequest.alamat, 'Jl. Sudirman No. 123, Jakarta');
        expect(createRequest.telefon, '+62211234567');
        expect(createRequest.latitude, -6.2088);
        expect(createRequest.longitude, 106.8456);

        final json = createRequest.toJson();
        expect(json['nama'], 'Jakarta Office');
        expect(json['alamat'], 'Jl. Sudirman No. 123, Jakarta');
        expect(json['telefon'], '+62211234567');
        expect(json['latitude'], -6.2088);
        expect(json['longitude'], 106.8456);
      });

      test('UpdateKantorRequest should be properly formed', () async {
        final updateRequest = UpdateKantorRequest(
          nama: 'Bandung Office',
          alamat: 'Jl. Asia Afrika No. 45, Bandung',
          telefon: '+62221234567',
          latitude: -6.9175,
          longitude: 107.6191,
        );

        expect(updateRequest.nama, 'Bandung Office');
        expect(updateRequest.alamat, 'Jl. Asia Afrika No. 45, Bandung');
        expect(updateRequest.telefon, '+62221234567');
        expect(updateRequest.latitude, -6.9175);
        expect(updateRequest.longitude, 107.6191);

        final json = updateRequest.toJson();
        expect(json['nama'], 'Bandung Office');
        expect(json['alamat'], 'Jl. Asia Afrika No. 45, Bandung');
      });

      test('Kantor model should parse JSON correctly', () async {
        final kantorJson = {
          'id': 1,
          'nama': 'Jakarta Office',
          'alamat': 'Jl. Sudirman No. 123, Jakarta',
          'telefon': '+62211234567',
          'latitude': -6.2088,
          'longitude': 106.8456,
          'created_by': 1,
          'updated_by': 1,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final kantor = Kantor.fromJson(kantorJson);

        expect(kantor.id, 1);
        expect(kantor.nama, 'Jakarta Office');
        expect(kantor.alamat, 'Jl. Sudirman No. 123, Jakarta');
        expect(kantor.telefon, '+62211234567');
        expect(kantor.latitude, -6.2088);
        expect(kantor.longitude, 106.8456);
        expect(kantor.createdBy, 1);
        expect(kantor.updatedBy, 1);
      });

      test('KantorService CRUD methods should exist and be callable', () async {
        final createRequest = CreateKantorRequest(
          nama: 'Test Office',
          alamat: 'Test Address',
          telefon: '+62211234567',
        );

        final updateRequest = UpdateKantorRequest(
          nama: 'Updated Office',
          alamat: 'Updated Address',
          telefon: '+62219876543',
        );

        // Test that all CRUD methods exist and can be called
        expect(() => KantorService.getAllKantors(), returnsNormally);
        expect(() => KantorService.getKantorById(1), returnsNormally);
        expect(
            () => KantorService.createKantor(createRequest), returnsNormally);
        expect(() => KantorService.updateKantor(1, updateRequest),
            returnsNormally);
        expect(() => KantorService.deleteKantor(1), returnsNormally);
      });

      test('Kantor data validation', () async {
        // Test valid office data
        final validRequest = CreateKantorRequest(
          nama: 'Jakarta Office',
          alamat: 'Jl. Sudirman No. 123, Jakarta',
          telefon: '+62211234567',
          latitude: -6.2088,
          longitude: 106.8456,
        );

        expect(validRequest.nama.isNotEmpty, true);
        expect(validRequest.alamat.isNotEmpty, true);
        expect(validRequest.telefon?.isNotEmpty, true);

        // Test minimal required data
        final minimalRequest = CreateKantorRequest(
          nama: 'Office',
          alamat: 'Address',
        );

        expect(minimalRequest.nama.isNotEmpty, true);
        expect(minimalRequest.alamat.isNotEmpty, true);
        expect(minimalRequest.telefon, null);
        expect(minimalRequest.latitude, null);
        expect(minimalRequest.longitude, null);
      });
    });

    // Jabatan (Position) Tests
    group('Jabatan Tests', () {
      test('CreateJabatanRequest should be properly formed', () async {
        final createRequest = CreateJabatanRequest(
          namaJabatan: 'Software Developer',
        );

        expect(createRequest.namaJabatan, 'Software Developer');

        final json = createRequest.toJson();
        expect(json['nama_jabatan'], 'Software Developer');
      });

      test('UpdateJabatanRequest should be properly formed', () async {
        final updateRequest = UpdateJabatanRequest(
          namaJabatan: 'Senior Software Developer',
        );

        expect(updateRequest.namaJabatan, 'Senior Software Developer');

        final json = updateRequest.toJson();
        expect(json['nama_jabatan'], 'Senior Software Developer');
      });

      test('Jabatan model should parse JSON correctly', () async {
        final jabatanJson = {
          'id': 1,
          'nama_jabatan': 'Software Developer',
          'created_by': 1,
          'updated_by': 1,
          'created_at': '2024-01-01T00:00:00Z',
          'updated_at': '2024-01-01T00:00:00Z',
        };

        final jabatan = Jabatan.fromJson(jabatanJson);

        expect(jabatan.id, 1);
        expect(jabatan.namaJabatan, 'Software Developer');
        expect(jabatan.createdBy, 1);
        expect(jabatan.updatedBy, 1);
      });

      test('JabatanService CRUD methods should exist and be callable',
          () async {
        final createRequest = CreateJabatanRequest(
          namaJabatan: 'Test Position',
        );

        final updateRequest = UpdateJabatanRequest(
          namaJabatan: 'Updated Position',
        );

        // Test that all CRUD methods exist and can be called
        expect(() => JabatanService.getAllJabatans(), returnsNormally);
        expect(() => JabatanService.getJabatanById(1), returnsNormally);
        expect(
            () => JabatanService.createJabatan(createRequest), returnsNormally);
        expect(() => JabatanService.updateJabatan(1, updateRequest),
            returnsNormally);
        expect(() => JabatanService.deleteJabatan(1), returnsNormally);
      });

      test('Jabatan data validation', () async {
        // Test valid position data
        final validRequest = CreateJabatanRequest(
          namaJabatan: 'Software Developer',
        );

        expect(validRequest.namaJabatan.isNotEmpty, true);

        // Test various position names
        final positions = [
          'Manager',
          'Software Engineer',
          'Product Manager',
          'UI/UX Designer',
          'Data Analyst',
        ];

        for (final position in positions) {
          final request = CreateJabatanRequest(namaJabatan: position);
          expect(request.namaJabatan, position);
          expect(request.namaJabatan.isNotEmpty, true);
        }
      });
    });

    // Integration Tests
    group('Integration Tests', () {
      test('JSON serialization round-trip for Kantor', () async {
        final originalKantor = Kantor(
          id: 1,
          nama: 'Jakarta Office',
          alamat: 'Jl. Sudirman No. 123, Jakarta',
          telefon: '+62211234567',
          latitude: -6.2088,
          longitude: 106.8456,
          createdBy: 1,
          updatedBy: 1,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        final json = originalKantor.toJson();
        final deserializedKantor = Kantor.fromJson(json);

        expect(deserializedKantor.id, originalKantor.id);
        expect(deserializedKantor.nama, originalKantor.nama);
        expect(deserializedKantor.alamat, originalKantor.alamat);
        expect(deserializedKantor.telefon, originalKantor.telefon);
        expect(deserializedKantor.latitude, originalKantor.latitude);
        expect(deserializedKantor.longitude, originalKantor.longitude);
      });

      test('JSON serialization round-trip for Jabatan', () async {
        final originalJabatan = Jabatan(
          id: 1,
          namaJabatan: 'Software Developer',
          createdBy: 1,
          updatedBy: 1,
          createdAt: '2024-01-01T00:00:00Z',
          updatedAt: '2024-01-01T00:00:00Z',
        );

        final json = originalJabatan.toJson();
        final deserializedJabatan = Jabatan.fromJson(json);

        expect(deserializedJabatan.id, originalJabatan.id);
        expect(deserializedJabatan.namaJabatan, originalJabatan.namaJabatan);
        expect(deserializedJabatan.createdBy, originalJabatan.createdBy);
        expect(deserializedJabatan.updatedBy, originalJabatan.updatedBy);
      });

      test('All services should be available for integration', () async {
        // Test that all services are importable and have expected methods
        expect(KantorService.getAllKantors, isNotNull);
        expect(JabatanService.getAllJabatans, isNotNull);

        // These would be used together in a real application
        expect(() => KantorService.getAllKantors(), returnsNormally);
        expect(() => JabatanService.getAllJabatans(), returnsNormally);
      });
    });
  });
}
