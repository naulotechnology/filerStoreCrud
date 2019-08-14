
  import 'dart:io';
  import 'package:path_provider/path_provider.dart';
  import 'dart:convert';

 import 'package:cloud_firestore/cloud_firestore.dart';
  























































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

//  final CollectionReference cr = Firestore.instance.collection("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b");

 


 final DocumentReference documentReference1 =
      // Firestore.instance.document("myData/dummy");
Firestore.instance.document("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b");
      
  
    add1() { 
      
    Map<String, String> data = <String,String>{
       
      "company":this.Company,
      "department":this.Department,
    
          // "department":"${pfm.Department}",
          // "costElements":"${pfm.costElements}",
          // "transportation" :"${pfm.ce()}",
          // "Marketing" :"${pfm.ce()}",
          // "Human Resources" :"${pfm.ce()}",
          // "Information Technology" :"${pfm.ce()}",
          // "Legal" :"${pfm.ce()}",
       
    
    };



   
    documentReference1.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }


   final DocumentReference documentReference2 =
      // Firestore.instance.document("myData/dummy");
Firestore.instance.document("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b/ceToMpMap/4lTpdHLKxq3hOCsLLUF6/Transportation/b6Zj4gIhSDStdzBsA19x");
   
    add2() {

          List hrList = new List();
    List amtList= new List();
      for (int i = 1; i < 13; i++) {
        //assign some amount to each of the 12 months
        amtList.add(i * 125);
        hrList.add(i*7);
      
    Map<String, List> data = <String,List>{
       
      "amountInMonth":amtList,
      "hrInMonth":hrList,
       
    
    };
    documentReference2.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }
   
    }

  





  final DocumentReference documentReference =
      // Firestore.instance.document("myData/dummy");
Firestore.instance.document("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b/ceToMpMap/4lTpdHLKxq3hOCsLLUF6/It/JHsZYk6hWJALGOySe3b6");
      


   add3() {
    List hrList = new List();
    List amtList= new List();
      for (int i = 1; i < 13; i++) {
        //assign some amount to each of the 12 months
        amtList.add(i * 125);
        hrList.add(i*7);
      
    Map<String, List> data = <String,List>{
       
      "amountInMonth":amtList,
      "hrInMonth":hrList,
    
          // "department":"${pfm.Department}",
          // "costElements":"${pfm.costElements}",
          // "transportation" :"${pfm.ce()}",
          // "Marketing" :"${pfm.ce()}",
          // "Human Resources" :"${pfm.ce()}",
          // "Information Technology" :"${pfm.ce()}",
          // "Legal" :"${pfm.ce()}",
       
    
    };
    documentReference.setData(data).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));
  }
   
   
   

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
