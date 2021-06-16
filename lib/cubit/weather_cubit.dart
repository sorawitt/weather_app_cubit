import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_app_cubit/weather.dart';
import 'package:weather_app_cubit/weather_repository.dart';

part 'weather_state.dart';

class WeatherCubit extends Cubit<WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherCubit(this._weatherRepository) : super(WeatherInitial());

  Future<void> getWeather(String cityName) async {
    try {
      print("loading");
      emit(WeatherLoading());
      final weather = await _weatherRepository.fetchWeather(cityName);
      print("loaded");
      emit(WeatherLoaded(weather));
    } on NetworkException {
      print("error");
      emit(WeatherError("Couldn't fetch weather. Is the device online?"));
    }
  }
}
