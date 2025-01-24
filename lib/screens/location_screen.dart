import 'package:flutter/material.dart';
import 'package:weatherapp/screens/city_screen.dart';
import 'package:weatherapp/services/weather.dart';
import 'package:weatherapp/utilities/constants.dart';

class LocationScreen extends StatefulWidget {
  final dynamic locationWeather;

  LocationScreen({
    Key? key,
    this.locationWeather,
  }) : super(key: key);

  @override
  _LocationScreenState createState() => _LocationScreenState();
}

// Instancia global de tu modelo (como ya tenías)
final weather = WeatherModel();

class _LocationScreenState extends State<LocationScreen> {
  int temperature = 0;
  String weatherIcon = '☀️';
  String weatherMessage = 'Fetching weather data...';
  String cityName = '';

  @override
  void initState() {
    super.initState();

    if (widget.locationWeather != null) {
      _updateFromLocationWeather(widget.locationWeather);
    } else {
      DatosUI();
    }
  }

  void DatosUI() async {
    try {
      var weatherData = await weather.getWeatherData();
      if (weatherData == null) {
        setState(() {
          weatherMessage = 'Unable to get weather data';
          weatherIcon = '🤷‍';
          cityName = '';
        });
        return;
      }

      setState(() {
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature);
        cityName = weatherData['name'];
      });
    } catch (e) {
      print('Error in updateUI: $e');
      setState(() {
        weatherMessage = 'Unable to fetch weather data.';
        weatherIcon = '🤷‍';
        cityName = '';
      });
    }
  }

  void _updateFromLocationWeather(dynamic data) {
    if (data == null) {
      setState(() {
        weatherMessage = 'Unable to get weather data';
        weatherIcon = '🤷‍';
        cityName = '';
      });
      return;
    }

    setState(() {
      double temp = data['main']['temp'];
      temperature = temp.toInt();
      var condition = data['weather'][0]['id'];
      weatherIcon = weather.getWeatherIcon(condition);
      weatherMessage = weather.getMessage(temperature);
      cityName = data['name'];
    });
  }

  void updateCityWeather(String city) async {
    try {
      var weatherData = await weather.getWeatherDataByCity(city);
      if (weatherData == null) {
        setState(() {
          weatherMessage = 'Unable to get weather data for $city';
          weatherIcon = '🤷‍';
          cityName = '';
        });
        return;
      }
      setState(() {
        double temp = weatherData['main']['temp'];
        temperature = temp.toInt();
        var condition = weatherData['weather'][0]['id'];
        weatherIcon = weather.getWeatherIcon(condition);
        weatherMessage = weather.getMessage(temperature);
        cityName = weatherData['name'];
      });
    } catch (e) {
      print('Error in updateCityWeather: $e');
      setState(() {
        weatherMessage = 'Unable to fetch city weather data.';
        weatherIcon = '🤷‍';
        cityName = '';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        // Fondo con imagen
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('images/location_background.jpg'),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.white.withOpacity(0.8),
              BlendMode.dstATop,
            ),
          ),
        ),
        constraints: BoxConstraints.expand(),
        child: SafeArea(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Barra superior
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  // Obtiene clima actual con GPS
                  TextButton(
                    onPressed: DatosUI,
                    child: Icon(
                      Icons.near_me,
                      size: 50.0,
                    ),
                  ),
                  // Botón de buscar clima por ciudad
                  TextButton(
                    onPressed: () async {
                      // Ir a CityScreen, y esperar el nombre de la ciudad
                      var typedCityName = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return CityScreen();
                          },
                        ),
                      );
                      // Si el usuario escribió algo, actualizar clima
                      if (typedCityName != null) {
                        updateCityWeather(typedCityName);
                      }
                    },
                    child: Icon(
                      Icons.location_city,
                      size: 50.0,
                    ),
                  ),
                ],
              ),

              // Sección con temperatura e ícono
              Padding(
                padding: EdgeInsets.only(left: 15.0),
                child: Row(
                  children: <Widget>[
                    Text(
                      '$temperature°',
                      style: kTempTextStyle,
                    ),
                    Text(
                      weatherIcon,
                      style: kConditionTextStyle,
                    ),
                  ],
                ),
              ),
              // Mensaje final
              Padding(
                padding: EdgeInsets.only(right: 15.0),
                child: Text(
                  "$weatherMessage in $cityName!",
                  textAlign: TextAlign.right,
                  style: kMessageTextStyle,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
