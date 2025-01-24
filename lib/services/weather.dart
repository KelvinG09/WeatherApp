import 'package:weatherapp/services/location.dart';
import 'package:weatherapp/services/networking.dart';

class WeatherModel {
  final String baseUrl = 'https://api.openweathermap.org/data/2.5/weather';
  final String apiKey = '7f28a317e96eacc77dc598b551f96fe3';

  Future<dynamic> getWeatherDataByCity(String cityName) async {
    var url = '$baseUrl?q=$cityName&appid=$apiKey&units=metric';
    Networking networking = Networking(url: url);
    var weatherData = await networking.getData();
    return weatherData;
  }

  Future<dynamic> getWeatherData() async {
    Location location = Location();
    await location.getCurrentPosition();

    Networking networking = Networking(
      url: '$baseUrl?lat=${location.latitude}&lon=${location.longitude}'
          '&appid=$apiKey&units=metric',
    );
    var weatherData = await networking.getData();
    return weatherData;  // Retornamos el mapa con la info del clima
  }

  String getWeatherIcon(int condition) {
    if (condition < 300) {
      return '🌩';
    } else if (condition < 400) {
      return '🌧';
    } else if (condition < 600) {
      return '☔️';
    } else if (condition < 700) {
      return '☃️';
    } else if (condition < 800) {
      return '🌫';
    } else if (condition == 800) {
      return '☀️';
    } else if (condition <= 804) {
      return '☁️';
    } else {
      return '🤷‍';
    }
  }

  String getMessage(int temp) {
    if (temp > 25) {
      return 'It\'s 🍦 time';
    } else if (temp > 20) {
      return 'Time for shorts and 👕';
    } else if (temp < 10) {
      return 'You\'ll need 🧣 and 🧤';
    } else {
      return 'Bring a 🧥 just in case';
    }
  }
}
