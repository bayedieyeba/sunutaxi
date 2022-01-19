import 'package:geolocator/geolocator.dart';
import 'package:sunutaxi/Assistants/requestAssistant.dart';
import 'package:sunutaxi/configMap.dart';

class AssistantMethods {
  static Future<String> searchCoordinateAddress(Position position) async {
    String placeAdress = "";
    String url =
        "https://maps.googleapis.com/maps/api/geocode/json?latlng=${position.latitude},${position.longitude}&key=$mapKey";
    var response = await RequestAssistant.getRequest(url);

    if (response != "Failed") {
      placeAdress = response["results"][0]["formatted_addres"];
    }

    return placeAdress;
  }
}
