import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

class PlanningFormModel {
  String Company;
  String Department;
  List<String> costElements;
  String jpt;
  
  /*
  Cost Element to Monthly Plan map
  */
  Map<String, MonthlyPlan> ceToMpMap;

  /*
  Cost Element to Monthly Actuals map
  */
  Map<String, MonthlyActual> ceToMaMap;

  /*
  Cost Element to Monthly Variance map
  */
  Map<String, MonthlyVariance> ceToMvMap;

  /*
  *This string is to hold current state of the App read from Storage
  */
  String savedStateFromFile = "This is default";

  /*
  *Storge class does the file/cloudstore/db read/write
  */
  Storage st;

  PlanningFormModel() {
    this.Company = "N Tech";
    this.Department = "Marketing";
    this.st = new Storage();
    this.costElements = new List<String>();
    //mPlan = new MonthlyPlan(this);

    this.costElements.add("Transportation");
    this.costElements.add("Marketing");
    this.costElements.add("Human Resources");
    this.costElements.add("Information Technology");
    this.costElements.add("Legal");

    //instatiate the map to store monthly plan for each costEleemnts
    ceToMpMap = new Map<String, MonthlyPlan>();
    ceToMaMap = new Map<String, MonthlyActual>();
    ceToMvMap = new Map<String, MonthlyVariance>();

    MonthlyPlan mPlan;
    MonthlyActual mActual;
    MonthlyVariance mVariance;
    List<DataValue> monthlyActualAmts, montlyPlanAmts, monthlyVarianceAmts;
    List<DataValue> monthlyActualHrs, montlyPlanHrs, monthlyVarianceHrs;

    for (String ce in this.costElements) {
      mPlan = new MonthlyPlan();
      mActual = new MonthlyActual();
      mVariance = new MonthlyVariance();

      mPlan.category = ce;
      mActual.category = ce;
      mVariance.category = ce;

      monthlyActualAmts = new List<ActualValue>();
      montlyPlanAmts = new List<PlanValue>();
      monthlyVarianceAmts = new List<VarianceValue>();

      monthlyActualHrs = new List<ActualValue>();
      montlyPlanHrs = new List<PlanValue>();
      monthlyVarianceHrs = new List<VarianceValue>();

      for (int i = 0; i < 12; i++) {
        
        //assign plan amounts to each of the 12 months
        PlanValue pv = new PlanValue(i * 125, i);
        //assign plan amounts to each of the 12 months
        ActualValue av = new ActualValue(i * 135, i);
        //Variance the difference between plan = actual
        VarianceValue vv = new VarianceValue(pv.value - av.value, i);

        //assign plan Hours to each of the 12 months
        PlanValue ph = new PlanValue(i * 7, i);
        //assign plan Hours to each of the 12 months
        ActualValue ah = new ActualValue(i * 9, i);
        //Variance the difference between plan = actual
        VarianceValue vh = new VarianceValue(ph.value - ah.value, i);

        //add to amounts list for Plan, Actual, Variance
        monthlyActualAmts.add(av);
        montlyPlanAmts.add(pv);
        monthlyVarianceAmts.add(vv);

        //add to amounts list for Plan, Actual, Variance
        monthlyActualHrs.add(ah);
        montlyPlanHrs.add(ph);
        monthlyVarianceHrs.add(vh);
      }

      //assign Monthly Plan Actual Vairance amounts to each plan
      mActual.amountInMonth = monthlyActualAmts;
      mPlan.amountInMonth = montlyPlanAmts;
      mVariance.amountInMonth = monthlyVarianceAmts;

      //assign Monthly Plan Actual Vairance amounts to each plan
      mActual.hourInMonth = monthlyActualHrs;
      mPlan.hourInMonth = montlyPlanHrs;
      mVariance.hourInMonth = monthlyVarianceHrs;

      //add monthly plan for the is
      this.ceToMpMap[ce] = mPlan;
      this.ceToMaMap[ce] = mActual;
      this.ceToMvMap[ce] = mVariance;
      
    }

    //assign month plan
    //this.monthLevelPlan = ceToMpMap;
  }

  String stringMp() {
    String planningFormInString = "";

    planningFormInString = planningFormInString + "Monthly Amount Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      // MonthlyPlan mp = this.ceToMpMap[ce];
      MonthlyPlan mp = new MonthlyPlan();
      for (PlanValue amount in mp.amountInMonth) {
        planningFormInString =
            planningFormInString + amount.value.toString() + "||";
      }

      planningFormInString = planningFormInString + "\n";
    }

    return planningFormInString;
  }

  String toStringMp() {
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

      for (PlanValue amount in mp.amountInMonth) {
        planningFormInString =
            planningFormInString + amount.value.toString() + "||";
      }

      planningFormInString = planningFormInString + "\n";
    }

    planningFormInString = planningFormInString + "Monthly hour Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyPlan mp = this.ceToMpMap[ce];

      for (PlanValue hour in mp.hourInMonth) {
        planningFormInString =
            planningFormInString + hour.value.toString() + "||";
      }
      planningFormInString = planningFormInString + "\n";
    }
    return planningFormInString;
  }

  String toStringMa() {
    String planningFormInString = "Company = " +
        this.Company +
        "\n" +
        "DepartMent = " +
        this.Department +
        "\n";

    planningFormInString = planningFormInString + "Monthly Amount Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyActual ma = this.ceToMaMap[ce];

      for (ActualValue amount in ma.amountInMonth) {
        planningFormInString =
            planningFormInString + amount.value.toString() + "||";
      }

      planningFormInString = planningFormInString + "\n";
    }

    planningFormInString = planningFormInString + "Monthly hour Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyActual ma = this.ceToMaMap[ce];

      for (ActualValue hour in ma.hourInMonth) {
        planningFormInString =
            planningFormInString + hour.value.toString() + "||";
      }
      planningFormInString = planningFormInString + "\n";
    }
    return planningFormInString;
  }

  String toStringMv() {
    String planningFormInString = "Company = " +
        this.Company +
        "\n" +
        "DepartMent = " +
        this.Department +
        "\n";

    planningFormInString = planningFormInString + "Monthly Amount Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyVariance mv = this.ceToMvMap[ce];

      for (VarianceValue amount in mv.amountInMonth) {
        planningFormInString =
            planningFormInString + amount.value.toString() + "||";
      }

      planningFormInString = planningFormInString + "\n";
    }

    planningFormInString = planningFormInString + "Monthly hour Plan\n";
    for (String ce in this.costElements) {
      planningFormInString = planningFormInString + ce + " ";

      MonthlyVariance mv = this.ceToMvMap[ce];

      for (VarianceValue hour in mv.hourInMonth) {
        planningFormInString =
            planningFormInString + hour.value.toString() + "||";
      }
      planningFormInString = planningFormInString + "\n";
    }
    return planningFormInString;
  }

  setAmount(bool isHour, String costElement, String amount, int idx) {
    if (isHour) {
      this.ceToMpMap[costElement].hourInMonth[idx].value = (int.parse(amount));
    } else {
      this.ceToMpMap[costElement].amountInMonth[idx].value =
          (int.parse(amount));
    }
  }

  String planningFormModelMptoJSON() {
    String p = "";
    p = p + "{";
    p = p + "'Company':" + "'${this.Company}'" + ",";
    p = p + "'Department':" + "'${this.Department}'" + ",";
    p = p + "'costElements':[";
    for (String ce in this.costElements) {
      p = p + "'" + ce + "',";
    }
    p = p + "],{'Plan':{[";
    for (String ce in this.costElements) {
      p = p + "${this.ceToMpMap[ce].monthlyPlanToJson()},";
    }
    p = p + "]}";

    p = p + "]}";
    p = json.encode(p);
    return p;
  }

  String planningFormModelMatoJSON() {
    String p = "";
    p = p + "{";
    p = p + "'Company':" + "'${this.Company}'" + ",";
    p = p + "'Department':" + "'${this.Department}'" + ",";
    p = p + "'costElements':[";
    for (String ce in this.costElements) {
      p = p + "'" + ce + "',";
    }
    p = p + "],{'Plan':{[";
    for (String ce in this.costElements) {
      p = p + "${this.ceToMaMap[ce].monthlyActualToJson()},";
    }
    p = p + "]}";

    p = p + "]}";
    p = json.encode(p);
    return p;
  }

  String planningFormModelMvtoJSON() {
    String p = "";
    p = p + "{";
    p = p + "'Company':" + "'${this.Company}'" + ",";
    p = p + "'Department':" + "'${this.Department}'" + ",";
    p = p + "'costElements':[";
    for (String ce in this.costElements) {
      p = p + "'" + ce + "',";
    }
    p = p + "],{'Plan':{[";
    for (String ce in this.costElements) {
      p = p + "${this.ceToMvMap[ce].monthlyVarianceToJson()},";
    }
    p = p + "]}";

    p = p + "]}";
    p = json.encode(p);
    return p;
  }

  savePfmToFile() {
    this.st.writeData(this.planningFormModelMvtoJSON());

    // this.st.writeData(this.toString());
  }

  savepfmToFirebasePlan() {
    for (String ce in this.costElements) {
      String a = ce;
      final DocumentReference $a = Firestore.instance.document(
          "/PlanningFormModel/PlanningFormModel/ceToMpMap/ceToMpMap/$a/$a");
      List montlyPlanHrs = new List<int>();
      List monthlyPlanAmts = new List<int>();
      for (int i = 1; i < 13; i++) {
        PlanValue pm = new PlanValue(i * 125, i);
        PlanValue ph = new PlanValue(i * 7, i);
        monthlyPlanAmts.add(pm.value);
        montlyPlanHrs.add(ph.value);
      }
      Map<String, List> data = <String, List>{
        "amountInMonth": monthlyPlanAmts,
        "hrInMonth": montlyPlanHrs,
      };

      $a.setData(data).whenComplete(() {
        print("Document Added");
      }).catchError((e) => print(e));
    }
  }

  savepfmToFirebaseActual() {
    List montlyActualHrs = new List<int>();
    List monthlyActualAmts = new List<int>();
    for (String ce in this.costElements) {
      String a = ce;
      final DocumentReference $a = Firestore.instance.document(
          "/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/$a/$a");

      for (int i = 1; i < 13; i++) {
        ActualValue am = new ActualValue(i * 135, i);
        ActualValue ah = new ActualValue(i * 9, i);
        monthlyActualAmts.add(am.value);
        montlyActualHrs.add(ah.value);
      }
      Map<String, List> data = <String, List>{
        "amountInMonth": monthlyActualAmts,
        "hrInMonth": montlyActualHrs,
      };

      $a.setData(data).whenComplete(() {
        print("Document Added");
      }).catchError((e) => print(e));
    }
  }

// savepfmToFirebaseVariance(){
//   PlanningFormModel pfm = new PlanningFormModel();

//     PlanValue pm = pfm.savepfmToFirebasePlan().monthlyPlamAmts;
//     PlanValue ph = pfm.savepfmToFirebasePlan().monthlyPlamHrs;
//      ActualValue am = pfm.savepfmToFirebaseActual().monthlyActualAmts;
//     ActualValue ah =pfm.savepfmToFirebaseActual().montlyActualHrs;

//    for (String ce in this.costElements) {
//           String a = ce;
//           final DocumentReference $a =
//           Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/$a/$a");
//           List montlyVarianceHrs = new List<int>();
//           List monthlyVarianceAmts= new List<int>();
//       for (int i = 1; i < 13; i++) {
//         VarianceValue vm = new VarianceValue(pm-am, i);
//         VarianceValue vh = new VarianceValue(ph-ah, i);
//         monthlyVarianceAmts.add(vm.value);
//         montlyVarianceHrs.add(vh.value);
//       }
//       Map<String, List> data = <String,List>{

//       "amountInMonth":monthlyVarianceAmts,
//       "hrInMonth":montlyVarianceHrs,

//     };

//     $a.setData(data).whenComplete(() {
//       print("Document Added");
//     }).catchError((e) => print(e));
//       }
// }

  Future<String> readPfmFromFile() {
    return this.st.readData();
  }

  checkInternetConnectivity() async {
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.none) {
      print(
        "'No internet', You're not connected to a network"
      );
    } else if (result == ConnectivityResult.mobile) {
      print(
      "  'Internet access',You're connected over mobile data"
      );
    } else if (result == ConnectivityResult.wifi) {
      print(
       " 'Internet access',You're connected over wifi"
      );
    }
  }




}
  // final DocumentReference documentReference1 =
  //     // Firestore.instance.document("myData/dummy");
  //     Firestore.instance.document("/PlanningFormModel/PlanningFormModel");

  // add1() {
    // List hrList = new List();
    // List amtList= new List();
    //   for (int i = 1; i < 13; i++) {
    //     //assign some amount to each of the 12 months
    //     amtList.add(i * 125);
    //     hrList.add(i*7);

    // Map<String, String> data = <String, String>{
    //   "Company": "N tech",
    //   "Department": "my",

      //       List montlyPlanHrs = new List();
      //       // montlyPlanHrs = new List<PlanValue>();
      //       // montlyPlanAmts = new List<PlanValue>();
      // List montlyPlanAmts= new List();
      //   for (int i = 1; i < 13; i++) {
      //     //assign some amount to each of the 12 months
      //     montlyPlanAmts.add(i * 125);
      //     montlyPlanHrs.add(i*7);

      // Map<String, List> data = <String,List>{

      //   "amountInMonth":montlyPlanAmts,
      //   "hrInMonth":montlyPlanHrs,
  //   };
  //   documentReference1.setData(data).whenComplete(() {
  //     print("Document Added");
  //   }).catchError((e) => print(e));
  // }

// final DocumentReference documentReference2 =
//       // Firestore.instance.document("myData/dummy");
// Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/Transportation/Transportation");

  // add2() {
  //        for (String ce in this.costElements) {
  //        String a = ce;
  //       final DocumentReference $a =
  //       Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/$a/$a");
  //               List hrList = new List();
  // List amtList= new List();
  //   for (int i = 1; i < 13; i++) {
  //     //assign some amount to each of the 12 months
  //     amtList.add(i * 125);
  //     hrList.add(i*7);
  //   }
  // Map<String, List> data = <String,List>{

  //   "amountInMonth":amtList,
  //   "hrInMonth":hrList,

  // };

  //       List montlyActualHrs = new List<int>();
  //       // montlyPlanHrs = new List<PlanValue>();
  //       // montlyPlanAmts = new List<PlanValue>();
  // List monthlyActualAmts= new List<int>();
  //   for (int i = 1; i < 13; i++) {
  //     //assign some amount to each of the 12 months
  //     ActualValue am = new ActualValue(i * 135, i);
  //     ActualValue ah = new ActualValue(i * 9, i);
  //     monthlyActualAmts.add(am.value);
  //     montlyActualHrs.add(ah.value);
  //   }

  // Map<String, List> data = <String,List>{

  //   "amountInMonth":monthlyActualAmts,
  //   "hrInMonth":montlyActualHrs,

  // };

  // $a.setData(data).whenComplete(() {
  //   print("Document Added");
  // }).catchError((e) => print(e));

  //          }
  //          }



//  DocumentReference documentReference3 =Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMvMap/ceToMvMap/Transportation/Transportation");
//  DocumentReference documentReference =Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMvMap/ceToMvMap/Transportation/Transportation");
//     add3() {

//  List montlyActualHrs = new List<int>();
//         // montlyPlanHrs = new List<PlanValue>();
//         // montlyPlanAmts = new List<PlanValue>();
//   List monthlyActualAmts= new List<int>();
//     for (int i = 1; i < 13; i++) {
//       //assign some amount to each of the 12 months
//       ActualValue am = new ActualValue(i * 135, i);
//       ActualValue ah = new ActualValue(i * 9, i);
//       monthlyActualAmts.add(am.value);
//       montlyActualHrs.add(ah.value);
//     }

//   Map<String, List> data = <String,List>{

//     "amountInMonth":monthlyActualAmts,
//     "hrInMonth":montlyActualHrs,

//   };

//   documentReference2.setData(data).whenComplete(() {
//     print("Document Added");
//   }).catchError((e) => print(e));

//   }

class DataValue {
  int index;
  int value;

  DataValue(int amt, int idx) {
    this.value = amt;
    this.index = idx;
  }
}

class PlanValue extends DataValue {
  PlanValue(int amt, int idx) : super(amt, idx);
}

class ActualValue extends DataValue {
  ActualValue(int amt, int idx) : super(amt, idx);
}

class VarianceValue extends DataValue {
  VarianceValue(int amt, int idx) : super(amt, idx);
}

class MonthlyValues {
  String category;
  List<DataValue> amountInMonth;
  List<DataValue> hourInMonth;
  //PlanningFormModel pfm;
}

class MonthlyActual extends MonthlyValues {
  String monthlyActualToJson() {
    PlanningFormModel pfm = new PlanningFormModel();
    String s = "";
    for (String ce in pfm.costElements) {
      s = s + "{";
      s = s + "'" + ce + "':{";
      s = s + "'amountInMonth':[";
      for (ActualValue i in amountInMonth) {
        s = s + "'" + i.value.toString() + "',";
      }
      s = s + "],";

      s = s + "'hourInMonth':[";
      for (ActualValue i in hourInMonth) {
        s = s + "'" + i.value.toString() + "',";
      }
      s = s + "]}},";

      // s = json.encode(s);
    }

    return s;
  }

  List<ActualValue> getMonthlyActual(bool isHour) {
    if (isHour)
      return this.hourInMonth;
    else
      return this.amountInMonth;
  }
}

class MonthlyVariance extends MonthlyValues {
  String monthlyVarianceToJson() {
    PlanningFormModel pfm = new PlanningFormModel();
    String s = "";
    for (String ce in pfm.costElements) {
      s = s + "{";
      s = s + "'" + ce + "':{";
      s = s + "'amountInMonth':[";
      for (VarianceValue i in amountInMonth) {
        s = s + "'" + i.value.toString() + "',";
      }
      s = s + "],";

      s = s + "'hourInMonth':[";
      for (VarianceValue i in hourInMonth) {
        s = s + "'" + i.value.toString() + "',";
      }
      s = s + "]}},";

      // s = json.encode(s);
    }

    return s;
  }

  List<VarianceValue> getMonthlyVariance(bool isHour) {
    if (isHour)
      return this.hourInMonth;
    else
      return this.amountInMonth;
  }
}

class MonthlyPlan extends MonthlyValues {
  // String category;
  // List<PlanValue> amountInMonth;
  // List<PlanValue> hourInMonth;
  // PlanningFormModel pfm;

  //MonthlyPlan(PlanningFormModel pfm){
  //    this.pfm = pfm;
  //}

  String monthlyPlanToJson() {
    PlanningFormModel pfm = new PlanningFormModel();
    String s = "";
    for (String ce in pfm.costElements) {
      s = s + "{";
      s = s + "'" + ce + "':{";
      s = s + "'amountInMonth':[";
      for (PlanValue i in amountInMonth) {
        s = s + "'" + i.value.toString() + "',";
      }
      s = s + "],";

      s = s + "'hourInMonth':[";
      for (PlanValue i in hourInMonth) {
        s = s + "'" + i.value.toString() + "',";
      }
      s = s + "]}},";

      // s = json.encode(s);
    }

    return s;
  }

  List<PlanValue> getMonthlyPlan(bool isHour) {
    if (isHour)
      return this.hourInMonth;
    else
      return this.amountInMonth;
  }
}

class Storage {
  Future<String> get localPath async {
    final dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/db.json');
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
    return file.writeAsString("$data");
  }
}

//    class PlanningFormModel {
//   String Company;
//   String Department;
//   List<String> costElements;
//   Map<String, MonthlyPlan> ceToMpMap;
//   List<int> amtList;
//     Map<String, MonthlyPlan> monthLevelPlan;

//   MonthlyPlan mPlan = new MonthlyPlan();
//  String cost = "";

//   String allCatagory;

//   PlanningFormModel() {
//     this.Company = "N Tech";
//     this.Department = "Marketing";
//     this.costElements = new List<String>();

//     this.costElements.add("Transportation");
//     this.costElements.add("Marketing");
//     this.costElements.add("Human Resources");
//     this.costElements.add("Information Technology");
//     this.costElements.add("Legal");

//     //instatiate the map to store monthly plan for each costEleemnts
//     ceToMpMap = new Map<String, MonthlyPlan>();

//     //mp = mp.getbykey(legal)
//     //  mp=mp.amountInMonth

//     for (String ce in this.costElements) {
//       //creaete monthly plan for each cost element

//       mPlan.category = ce;
//       amtList = new List<int>();

//       for (int i = 1; i < 13; i++) {
//         //assign some amount to each of the 12 months
//         amtList.add(i * 125);
//       }
//       mPlan.amountInMonth = amtList;

//       List hr = new List<int>();

//       for (int i = 1; i < 13; i++) {
//         //assign some amount to each of the 12 months
//         hr.add(i * 7);
//       }
//       mPlan.hourInMonth = hr;

//       //add monthly plan for the is
//       this.ceToMpMap[ce] = mPlan;
//     }
//     //assign month plan
//     // this.ceToMpMap = ceToMpM;
//   }

//   String toString() {
//     String planningFormInString = "Company = " +
//         this.Company +
//         "\n" +
//         "DepartMent = " +
//         this.Department +
//         "\n";

//     planningFormInString = planningFormInString + "Monthly Amount Plan\n";
//     for (String ce in this.costElements) {
//       planningFormInString = planningFormInString + ce + " ";

//       MonthlyPlan mp = this.ceToMpMap[ce];

//       for (int amount in mp.amountInMonth) {
//         planningFormInString = planningFormInString + amount.toString() + "||";
//       }

//       planningFormInString = planningFormInString + "\n";
//     }

//     planningFormInString = planningFormInString + "Monthly hour Plan\n";
//     for (String ce in this.costElements) {
//       planningFormInString = planningFormInString + ce + " ";

//       MonthlyPlan mp = this.ceToMpMap[ce];

//       for (int hour in mp.hourInMonth) {
//         planningFormInString = planningFormInString + hour.toString() + "||";
//       }
//       planningFormInString = planningFormInString + "\n";
//     }
//     return planningFormInString;
//   }

//  String PlanningFormModeltoJsonv2() {
//     String p = "";
//     p = p + "{";
//     p = p + "'Company':" + "'${this.Company}'" + ",";
//     p = p + "'Department':" + "'${this.Department}'" + ",";
//     p = p + "'costElements':[";
//     for (String ce in this.costElements) {
//       p = p + "'" + ce + "',";
//     }
//     p = p + "],";
//     p = p +  "${mPlan.monthlyplantoJsonv2()}" + "]";

//     p = p + "}";
//     p = json.encode(p);
//     return p;
//   }

// String dataMPTJ(){
//   String a =" ${mPlan.monthlyplantoJsonv2()}";
//   return a;

// }

// String ce(){
//   String a =" ${mPlan.mpCE()}";
//   return a;

// }

// //  final CollectionReference cr = Firestore.instance.collection("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b");

//  final DocumentReference documentReference1 =
//       // Firestore.instance.document("myData/dummy");
// Firestore.instance.document("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b");

//     add1() {

//     Map<String, String> data = <String,String>{

//       "company":this.Company,
//       "department":this.Department,

//           // "department":"${pfm.Department}",
//           // "costElements":"${pfm.costElements}",
//           // "transportation" :"${pfm.ce()}",
//           // "Marketing" :"${pfm.ce()}",
//           // "Human Resources" :"${pfm.ce()}",
//           // "Information Technology" :"${pfm.ce()}",
//           // "Legal" :"${pfm.ce()}",

//     };

//     documentReference1.setData(data).whenComplete(() {
//       print("Document Added");
//     }).catchError((e) => print(e));
//   }

//    final DocumentReference documentReference2 =
//       // Firestore.instance.document("myData/dummy");
// Firestore.instance.document("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b/ceToMpMap/4lTpdHLKxq3hOCsLLUF6/Transportation/b6Zj4gIhSDStdzBsA19x");

//     add2() {

//           List hrList = new List();
//     List amtList= new List();
//       for (int i = 1; i < 13; i++) {
//         //assign some amount to each of the 12 months
//         amtList.add(i * 125);
//         hrList.add(i*7);

//     Map<String, List> data = <String,List>{

//       "amountInMonth":amtList,
//       "hrInMonth":hrList,

//     };
//     documentReference2.setData(data).whenComplete(() {
//       print("Document Added");
//     }).catchError((e) => print(e));
//   }

//     }

//   final DocumentReference documentReference =
//       // Firestore.instance.document("myData/dummy");
// Firestore.instance.document("/PlanningFormModel/LzpO3NZ3OA8aj0Stil4b/ceToMpMap/4lTpdHLKxq3hOCsLLUF6/It/JHsZYk6hWJALGOySe3b6");

//    add3() {
//     List hrList = new List();
//     List amtList= new List();
//       for (int i = 1; i < 13; i++) {
//         //assign some amount to each of the 12 months
//         amtList.add(i * 125);
//         hrList.add(i*7);

//     Map<String, List> data = <String,List>{

//       "amountInMonth":amtList,
//       "hrInMonth":hrList,

//           // "department":"${pfm.Department}",
//           // "costElements":"${pfm.costElements}",
//           // "transportation" :"${pfm.ce()}",
//           // "Marketing" :"${pfm.ce()}",
//           // "Human Resources" :"${pfm.ce()}",
//           // "Information Technology" :"${pfm.ce()}",
//           // "Legal" :"${pfm.ce()}",

//     };
//     documentReference.setData(data).whenComplete(() {
//       print("Document Added");
//     }).catchError((e) => print(e));
//   }

// }

// }

//   class MonthlyPlan{
//     String category;
//     List<int> amountInMonth;
//     List<int> hourInMonth;

//     // List<int> getMonthlyPlan(bool isHour){
//     //    if(isHour) return this.hourInMonth;
//     //    else return this.amountInMonth;
//     // }

//  String monthlyplantoJsonv2() {
//     PlanningFormModel pfm = new PlanningFormModel();
//     String s = "";
//     for (String ce in pfm.costElements) {
//       s = s + "{";
//       s = s + "'" + ce + "':{";
//       s = s + "'amountInMonth':[";
//       for (int i in amountInMonth) {
//         s = s + "'" + i.toString() + "',";
//       }
//       s = s + "]";

//       s = s + "'hourInMonth':[";
//       for (int i in hourInMonth) {
//         s = s + "'" + i.toString() + "',";
//       }
//       s = s + "]}},";

//       // s = json.encode(s);
//     }

//     return s;
//   }

//    String mpCE() {
//     String a = "";
//     a = a + "{";
// //       a = a + "'" + ce + "':{";
//     a = a + "'amountInMonth':[";
//     for (int i in amountInMonth) {
//       a = a + "'" + i.toString() + "',";
//     }
//     a = a + "],";

//     a = a + "'hourInMonth':[";
//     for (int i in hourInMonth) {
//       a = a + "'" + i.toString() + "',";
//     }
//     a = a + "]}";

//     // s = json.encode(s);

//     return a;
//   }

//   }
//   class Storage {
//     PlanningFormModel pfm = PlanningFormModel();
//   Future<String> get localPath async {
//     final dir = await getApplicationDocumentsDirectory();
//     return dir.path;
//   }

//   Future<File> get localFile async {
//     final path = await localPath;
//     return File('$path/db.txt');
//   }

//   Future<String> readData() async {
//     try {
//       final file = await localFile;
//       String body = await file.readAsString();

//       return body;
//     } catch (e) {
//       return e.toString();
//     }
//   }

//   Future<File> writeData(String data) async {
//     final file = await localFile;
//     return file.writeAsString("");
//   }
// }
