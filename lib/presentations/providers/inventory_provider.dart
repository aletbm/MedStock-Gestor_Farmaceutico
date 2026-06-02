import 'package:flutter_riverpod/legacy.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InventoryState {
  final bool stockMinimo;
  final int cantidadMinimaAlerta;
  final bool stockMaximo;
  final int cantidadMaximaAlerta;
  final bool alertasVencimiento;
  final int cantidadDiasAnticipados;
  final bool alertasStockBajo;
  final String currencyCode;

  InventoryState({
    required this.stockMinimo,
    required this.cantidadMinimaAlerta,
    required this.stockMaximo,
    required this.cantidadMaximaAlerta,
    required this.alertasVencimiento,
    required this.cantidadDiasAnticipados,
    required this.alertasStockBajo,
    required this.currencyCode,
  });

  InventoryState copyWith({
    bool? stockMinimo,
    int? cantidadMinimaAlerta,
    bool? stockMaximo,
    int? cantidadMaximaAlerta,
    bool? alertasVencimiento,
    int? cantidadDiasAnticipados,
    bool? alertasStockBajo,
    String? currencyCode,
  }) {
    return InventoryState(
      stockMinimo: stockMinimo ?? this.stockMinimo,
      cantidadMinimaAlerta: cantidadMinimaAlerta ?? this.cantidadMinimaAlerta,
      stockMaximo: stockMaximo ?? this.stockMaximo,
      cantidadMaximaAlerta: cantidadMaximaAlerta ?? this.cantidadMaximaAlerta,
      alertasVencimiento: alertasVencimiento ?? this.alertasVencimiento,
      cantidadDiasAnticipados: cantidadDiasAnticipados ?? this.cantidadDiasAnticipados,
      alertasStockBajo: alertasStockBajo ?? this.alertasStockBajo,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }
}

final inventoryProvider = StateNotifierProvider<InventoryNotifier, InventoryState>((ref) {
  return InventoryNotifier();
});

class InventoryNotifier extends StateNotifier<InventoryState> {
  InventoryNotifier() : super(InventoryState(
    stockMinimo: true,
    cantidadMinimaAlerta: 10,
    stockMaximo: false,
    cantidadMaximaAlerta: 100,
    alertasVencimiento: true,
    cantidadDiasAnticipados: 30,
    alertasStockBajo: true,
    currencyCode: 'ARS',
  )) {
    _loadSaved();
  }

  Future<void> _loadSaved() async {
    final prefs = await SharedPreferences.getInstance();
    final stockMinimo = prefs.getBool('stockMinimo') ?? true;
    final cantidadMinimaAlerta = prefs.getInt('cantidadMinimaAlerta') ?? 10;
    final stockMaximo = prefs.getBool('stockMaximo') ?? false;  
    final cantidadMaximaAlerta = prefs.getInt('cantidadMaximaAlerta') ?? 100;
    final alertasVencimiento = prefs.getBool('alertasVencimiento') ?? true;
    final cantidadDiasAnticipados = prefs.getInt('cantidadDiasAnticipados') ?? 30;
    final alertasStockBajo = prefs.getBool('alertasStockBajo') ?? true;
    final currencyCode = prefs.getString('currencyCode') ?? 'ARS';

    state = InventoryState(
      stockMinimo: stockMinimo,
      cantidadMinimaAlerta: cantidadMinimaAlerta,
      stockMaximo: stockMaximo,
      cantidadMaximaAlerta: cantidadMaximaAlerta,
      alertasVencimiento: alertasVencimiento,
      cantidadDiasAnticipados: cantidadDiasAnticipados,
      alertasStockBajo: alertasStockBajo,
      currencyCode: currencyCode,
    );
  }

  void toggleStockMinimo(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stockMinimo', value);
    state = state.copyWith(stockMinimo: value);
  }

  void setCantidadMinimaAlerta(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cantidadMinimaAlerta', value);
    state = state.copyWith(cantidadMinimaAlerta: value);
  }

  void toggleStockMaximo(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('stockMaximo', value);
    state = state.copyWith(stockMaximo: value);
  }

  void setCantidadMaximaAlerta(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cantidadMaximaAlerta', value);
    state = state.copyWith(cantidadMaximaAlerta: value);
  }

  void setCantidadDiasAnticipados(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('cantidadDiasAnticipados', value);
    state = state.copyWith(cantidadDiasAnticipados: value);
  }

  void toggleAlertasVencimiento(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alertasVencimiento', value);
    state = state.copyWith(alertasVencimiento: value);
  }

  void toggleAlertasStockBajo(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('alertasStockBajo', value);
    state = state.copyWith(alertasStockBajo: value);
  }

  void setCurrencyCode(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('currencyCode', code);
    state = state.copyWith(currencyCode: code);
  }
}