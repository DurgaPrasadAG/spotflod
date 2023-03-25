import 'package:spotflod/data/aphids_data.dart';
import 'package:spotflod/data/armyworm_data.dart';
import 'package:spotflod/data/bacterial_blite_data.dart';
import 'package:spotflod/data/curl_virus_data.dart';
import 'package:spotflod/data/fusarium_wilt_data.dart';
import 'package:spotflod/data/powdery_mildew_data.dart';
import 'package:spotflod/data/target_spot_data.dart';

class Diseases {

  static getControlMeasures(String classLabel) {
    List<String> controlMeasures = [];

    switch (classLabel) {
      case "aphids":
        controlMeasures = AphidsData.controlMeasures;
        break;
      case 'army_worm':
        controlMeasures = ArmyWormData.controlMeasures;
        break;
      case 'bacterial_blight':
        controlMeasures = BacterialBlightData.controlMeasures;
        break;
      case 'curl_virus':
        controlMeasures = CurlVirusData.controlMeasures;
        break;
      case 'fusarium_wilt':
        controlMeasures = FusariumWilt.controlMeasures;
        break;
      case 'powdery_mildew':
        controlMeasures = PowderyMildew.controlMeasures;
        break;
      case 'target_spot':
        controlMeasures = TargetSpotData.controlMeasures;
        break;
    }
    return controlMeasures;
  }
}