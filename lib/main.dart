import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_app_cubit/cubit/weather_cubit.dart';
import 'package:weather_app_cubit/weather.dart';
import 'package:weather_app_cubit/weather_repository.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocProvider(
        create: (context) => WeatherCubit(FakeWeatherRepository()),
        child: WeatherSearchPage(),
      ),
    );
  }
}

class WeatherSearchPage extends StatefulWidget {
  const WeatherSearchPage({Key? key}) : super(key: key);

  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocBuilder<WeatherCubit, WeatherState>(
          builder: (context, state) {
            if (state is WeatherInitial) return buildInitialInput(context);
            if (state is WeatherLoading) return buildLoading();
            if (state is WeatherLoaded)
              return buildColumnWithData(state.weather);
            else
              return buildInitialInput(context);
          },
        ),
      ),
    );
  }

  Widget buildInitialInput(BuildContext context) {
    return Container(
      child: Center(
        child: TextField(onSubmitted: (cityName) => {
          _onSubmittedCityName(context, cityName)
        },),
      ),
    );
  }

  void _onSubmittedCityName(BuildContext context, String cityName) {
    final weatherCubit = context.read<WeatherCubit>();
    weatherCubit.getWeather(cityName);
  }

  Widget buildLoading() {
    return Container(
      child: Center(
        child: CircularProgressIndicator(),
      ),
    );
  }

  Widget buildColumnWithData(Weather weather) {
    return Container(
      child: Column(
        children: [
          Text(weather.cityName),
          Text(weather.temperatureCelsius.toString())
        ],
      ),
    );
  }
}
