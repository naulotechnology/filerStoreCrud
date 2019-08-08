

  import 'dart:io';
  import 'package:path_provider/path_provider.dart';
  import 'dart:convert';

 
  


   class PlanningFormModel {
  String Company;
  String Department;
  List<String> costElements;
  Map<String, MonthlyPlan> ceToMpMap;
  List<int> amtList;
    Map<String, MonthlyPlan> monthLevelPlan;

  MonthlyPlan mPlan = new MonthlyPlan();
 String cost = "";

  String allCatagory;

  PlanningFormModel() {
    this.Company = "N Tech";
    this.Department = "Marketing";
    this.costElements = new List<String>();

    this.costElements.add("Transportation");
    this.costElements.add("Marketing");
    this.costElements.add("Human Resources");
    this.costElements.add("Information Technology");
    this.costElements.add("Legal");

    //instatiate the map to store monthly plan for each costEleemnts
    ceToMpMap = new Map<String, MonthlyPlan>();

    //mp = mp.getbykey(legal)
    //  mp=mp.amountInMonth

    for (String ce in this.costElements) {
      //creaete monthly plan for each cost element

      mPlan.category = ce;
      amtList = new List<int>();

      for (int i = 1; i < 13; i++) {
        //assign some amount to each of the 12 months
        amtList.add(i * 125);
      }
      mPlan.amountInMonth = amtList;

      List hr = new List<int>();

      for (int i = 1; i < 13; i++) {
        //assign some amount to each of the 12 months
        hr.add(i * 7);
      }
      mPlan.hourInMonth = hr;

      //add monthly plan for the is
      this.ceToMpMap[ce] = mPlan;
    }
    //assign month plan
    // this.ceToMpMap = ceToMpM;
  }

  String toString() {
    String planningFormInString = "Company = " +
        this.Company +
        "\n" +
        "DepartMent = " +
        this.Department +
        "\n";

    planningFormInString = planningFormInString + "Monthly Amount Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyPlan mp = this.ceToMpMap[ce];

      for (int amount in mp.amountInMonth) {
        planningFormInString = planningFormInString + amount.toString() + "||";
      }

      planningFormInString = planningFormInString + "\n";
    }

    planningFormInString = planningFormInString + "Monthly hour Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyPlan mp = this.ceToMpMap[ce];

      for (int hour in mp.hourInMonth) {
        planningFormInString = planningFormInString + hour.toString() + "||";
      }
      planningFormInString = planningFormInString + "\n";
    }
    return planningFormInString;
  }

 String PlanningFormModeltoJsonv2() {
    String p = "";
    p = p + "{";
    p = p + "'Company':" + "'${this.Company}'" + ",";
    p = p + "'Department':" + "'${this.Department}'" + ",";
    p = p + "'costElements':[";
    for (String ce in this.costElements) {
      p = p + "'" + ce + "',";
    }
    p = p + "],";
    p = p +  "${mPlan.monthlyplantoJsonv2()}" + "]";

    p = p + "}";
    p = json.encode(p);
    return p;
  }

String dataMPTJ(){
  String a =" ${mPlan.monthlyplantoJsonv2()}";
  return a;

}


String ce(){
  String a =" ${mPlan.mpCE()}";
  return a;

}

}


  class MonthlyPlan{
    String category;
    List<int> amountInMonth;
    List<int> hourInMonth;
    
    // List<int> getMonthlyPlan(bool isHour){
    //    if(isHour) return this.hourInMonth;
    //    else return this.amountInMonth;
    // }

 String monthlyplantoJsonv2() {
    PlanningFormModel pfm = new PlanningFormModel();
    String s = "";
    for (String ce in pfm.costElements) {
      s = s + "{";
      s = s + "'" + ce + "':{";
      s = s + "'amountInMonth':[";
      for (int i in amountInMonth) {
        s = s + "'" + i.toString() + "',";
      }
      s = s + "]";

      s = s + "'hourInMonth':[";
      for (int i in hourInMonth) {
        s = s + "'" + i.toString() + "',";
      }
      s = s + "]}},";

      // s = json.encode(s);
    }

    return s;
  }

   String mpCE() {
    String a = "";
    a = a + "{";
//       a = a + "'" + ce + "':{";
    a = a + "'amountInMonth':[";
    for (int i in amountInMonth) {
      a = a + "'" + i.toString() + "',";
    }
    a = a + "],";

    a = a + "'hourInMonth':[";
    for (int i in hourInMonth) {
      a = a + "'" + i.toString() + "',";
    }
    a = a + "]}";

    // s = json.encode(s);

    return a;
  }

  }
  class Storage {
    PlanningFormModel pfm = PlanningFormModel();
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.txt');
  }

  Future<String> readData() async {
    try {
      final file = await localFile;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeData(String data) async {
    final file = await localFile;
    return file.writeAsString("");
  }
}
