import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:weatherapp/screens/location_screen.dart';
import 'package:weatherapp/services/weather.dart';

class LoadingScreen extends StatefulWidget {
  @override
  _LoadingScreenState createState() => _LoadingScreenState();
}

class _LoadingScreenState extends State<LoadingScreen> {

  @override
  void initState() {
    super.initState();
    getWeatherData();
  }

  void getWeatherData() async {
    try {
      WeatherModel weatherModel = WeatherModel();
      var weatherData = await weatherModel.getWeatherData();

      if (weatherData == null) {
        print('Error: No se obtuvo el clima');
      } else {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) {
              return LocationScreen(locationWeather: weatherData);
            },
          ),
        );
      }
    } catch (e) {
      print('Exception en getWeatherData: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SpinKitFadingGrid(
          color: Colors.white,
          size: 50.0,
        ),
      ),
    );
  }
}
