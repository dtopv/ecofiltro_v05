import 'package:firebase_database/firebase_database.dart';

class FirebaseDatabaseService {
  final DatabaseReference _database = FirebaseDatabase.instance.ref();

  // Stream para escuchar cambios en el nivel de agua
  Stream<double> getWaterLevelStream() {
    return _database.child('water_level').onValue.map((event) {
      final value = event.snapshot.value;
      return value != null ? (value as num).toDouble() : 0.0;
    });
  }

  // Método para actualizar el nivel de agua
  Future<void> updateWaterLevel(double level) async {
    try {
      await _database.child('water_level').set(level);
    } catch (e) {
      print('Error al actualizar el nivel de agua: $e');
      rethrow;
    }
  }

  // Método para verificar si el nivel de agua está bajo
  Future<bool> isWaterLevelLow() async {
    try {
      final snapshot = await _database.child('water_level').get();
      if (snapshot.exists) {
        final level = (snapshot.value as num).toDouble();
        // Ajusta este valor según tus necesidades
        return level <
            20.0; // Consideramos nivel bajo si está por debajo del 20%
      }
      return false;
    } catch (e) {
      print('Error al verificar el nivel de agua: $e');
      rethrow;
    }
  }
}
