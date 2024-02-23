import 'package:bloc/bloc.dart';
import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:weather_service/data/models/weather.dart';
import 'package:weather_service/data/services/dio_service.dart';
import 'package:weather_service/data/services/geo_service.dart';
import 'package:weather_service/secrets.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final DioService _dioService = DioService();

  HomeCubit() : super(HomeInitial());

  Future<void> getWeatherByLocation() async {
    emit(HomeLoading());
    try {
      final location = await GeoService().getCurrentLocation();
      await _getWeather(location.latitude, location.longitude);
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> getWeatherByCity(String cityName) async {
    emit(HomeLoading());
    try {
      final coordinates = await GeoService().getLocationByCityName(cityName);
      await _getWeather(coordinates['latitude'], coordinates['longitude']);
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      emit(HomeFailure(e.toString()));
    }
  }

  Future<void> _getWeather(double latitude, double longitude) async {
    try {
      final response = await _dioService.get(
        '?units=metric&lang=en&lat=$latitude&lon=$longitude&appid=$openWeatherMapApiKey',
      );
      final weather = Weather.fromJson(response.data as Map<String, dynamic>);
      await Hive.box('myBox').put('weather', weather);
      emit(HomeLoaded(weather));
    } catch (e, s) {
      debugPrintStack(label: e.toString(), stackTrace: s);
      emit(HomeFailure(e.toString()));
    }
  }
}
