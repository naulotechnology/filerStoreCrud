import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:connectivity/connectivity.dart';

class PlanningFormModel {
  String company;
  String department;
  List<String> costElements;
  String jpt;
  List montlyActualHrs = new List<int>();
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
    this.company = "N Tech";
    this.department = "Marketing";
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

 
  
  String toStringMp() {
    String planningFormInString = "company = " +
        this.company +
        "\n" +
        "department = " +
        this.department +
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
    String planningFormInString = "company = " +
        this.company +
        "\n" +
        "department = " +
        this.department +
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
    String planningFormInString = "company = " +
        this.company +
        "\n" +
        "department = " +
        this.department +
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
    p = p + "'company':" + "'${this.company}'" + ",";
    p = p + "'department':" + "'${this.department}'" + ",";
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
    p = p + "'company':" + "'${this.company}'" + ",";
    p = p + "'department':" + "'${this.department}'" + ",";
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
    p = p + "'company':" + "'${this.company}'" + ",";
    p = p + "'department':" + "'${this.department}'" + ",";
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
    this.st.writeJsonData(this.planningFormModelMvtoJSON());

    // this.st.writeData(this.toString());
  }

  // savepfmToFirebasePlan() {
  //   for (String ce in this.costElements) {
  //     String a = ce;
  //     final DocumentReference $a = Firestore.instance.document(
  //         "/PlanningFormModel/PlanningFormModel/ceToMpMap/ceToMpMap/$a/$a");
  //     List montlyPlanHrs = new List<int>();
  //     List monthlyPlanAmts = new List<int>();
  //     for (int i = 1; i < 13; i++) {
  //       PlanValue pm = new PlanValue(i * 125, i);
  //       PlanValue ph = new PlanValue(i * 7, i);
  //       monthlyPlanAmts.add(pm.value);
  //       montlyPlanHrs.add(ph.value);
  //     }
  //     Map<String, List> data = <String, List>{
  //       "amountInMonth": monthlyPlanAmts,
  //       "hrInMonth": montlyPlanHrs,
  //     };

  //     $a.setData(data).whenComplete(() {
  //       print("Document Added");
  //     }).catchError((e) => print(e));
  //   }
  // }

  savepfmToFirebase() {
     int pm , am, vm , ph , ah , vh;
  
  String path = "";
  String company = "company"; // this.company;
  String department =  "department"  ; //this.department;
  String year =  "2019" ; //this.year;
  String month =  "janaury" ; //this.month;
  // path = "/" + company + "/" + company + "/" + department + "/" + department + "/" + year + "/" + year + "/" + month + "/" + month ;
  path = "/" + company +  "/" + department +"/" + year +  "/"  + month ;
    List mPHrs = new List<int>();
    List mPAmts= new List<int>();
    List mAHrs = new List<int>();
    List mAAmts= new List<int>();
    List mVHrs = new List<int>();
    List mVAmts= new List<int>();
   for (String ce in this.costElements) {
          String a = ce;
          // final DocumentReference $a =
          // Firestore.instance.document("path/$a/plan");
          // Firestore.instance.document("path/$a/actual");
          // Firestore.instance.document("path/$a/varience");
        // Firestore.instance.document("/PlanningFormModel/PlanningFormModel/ceToMaMap/ceToMaMap/$a/$a");
           final DocumentReference planDocRef= Firestore.instance.document("$path/$a/plan");
            final DocumentReference actualDocRef = Firestore.instance.document("$path/$a/actual");
             final DocumentReference varienceDocRef = Firestore.instance.document("$path/$a/varience");

            // final DocumentReference planDocRef = Firestore.instance.document("path/$a/plan");
            // final DocumentReference actualDocRef = Firestore.instance.document("path/$a/actual");
            //  final DocumentReference varienceDocRef = Firestore.instance.document("path/$a/varience");

         MonthlyPlan mp  = this.ceToMpMap[ce];
            MonthlyActual ma = this.ceToMaMap[ce];
           MonthlyVariance mv = this.ceToMvMap[ce];
      // for (int i = 1; i < 13; i++) {
      // //  PlanValue pm = mp.amountInMonth[i];
         
      //   ActualValue am = new ActualValue(i * 135, i);
      //   ActualValue ah = new ActualValue(i * 9, i);
      //   monthlyActualAmts.add(am.value);
      //   montlyActualHrs.add(ah.value);
      // }


           for (PlanValue amount in mp.amountInMonth) {
        pm = amount.value;
        mPAmts.add(pm);
      }

        
           for (PlanValue hour in mp.amountInMonth) {
        ph = hour.value;
        mPHrs.add(ph);
      }

          for (ActualValue amount in ma.amountInMonth) {
        am = amount.value;
        mAAmts.add(am);
      }

        
           for (ActualValue hour in ma.amountInMonth) {
        ah = hour.value;
        mAHrs.add(ah);
      }

    for (VarianceValue amount in mv.amountInMonth) {
        vm = amount.value;
        mVAmts.add(vm);
      }

        
           for (VarianceValue hour in mv.amountInMonth) {
        vh = hour.value;
        mVHrs.add(vh);
      }


      Map<String, List> planData = <String,List>{
       
     "amountInMonth":mPAmts,
     "hrInMonth": mPHrs,
      // "amountInMonth":mp.amountInMonth,
      // "hrInMonth":mp.hourInMonth,
       
    };

    Map<String, List> actualData = <String,List>{
       
     // "amountInMonth":monthlyActualAmts,
      // "amountInMonth":ma.amountInMonth,
      // "hrInMonth":ma.hourInMonth,
       "amountInMonth":mAAmts,
        "hrInMonth": mAHrs,
    };

      Map<String, List> varienceData = <String,List>{
       
       "amountInMonth":mVAmts,
        "hrInMonth": mVHrs,
    };
     // "amountInMonth":monthlyActualAmts,
      // "amountInMonth":mv.amountInMonth,
      // "hrInMonth":mv.hourInMonth,
       
    

      //below codes saves planValue to firebase
    planDocRef.setData(planData).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));

    // below codes saves actualValue to firebase
    actualDocRef.setData(actualData).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));

 //below codes saves varienceValue to firebase
    varienceDocRef.setData(varienceData).whenComplete(() {
      print("Document Added");
    }).catchError((e) => print(e));

  }
  


  // Future<String> readPfmFromFile() {
  //   return this.st.readData();
  // }
}
  checkInternetConnectivity() async {
    PlanningFormModel pfm =   PlanningFormModel();
    var result = await Connectivity().checkConnectivity();
    if (result == ConnectivityResult.wifi || result == ConnectivityResult.mobile) {
     pfm.savepfmToFirebase();
    }

    print("no internet access");
     //pfm.savePfmToFile();
    //  else if (result == ConnectivityResult.none) {
    //   print(
    //   "  ' No Internet access',You're not connected "
    //   );
    // } 
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
    //   "company": "N tech",
    //   "department": "my",

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

  Future<File> get localFileJson async {
    final path = await localPath;
    return File('$path/db.json');
  }

   Future<File> get localFileString async {
    final path = await localPath;
    return File('$path/db.txt');
  }


  Future<String> readJsonData() async {
    try {
      final file = await localFileJson;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<String> readStringData() async {
    try {
      final file = await localFileString;
      String body = await file.readAsString();

      return body;
    } catch (e) {
      return e.toString();
    }
  }

  Future<File> writeJsonData(String jsonData) async {
    final file = await localFileJson;
    return file.writeAsString("$jsonData");
  }

  Future<File> writeStringData(String stringData) async {
    final file = await localFileJson;
    return file.writeAsString("$stringData");
  }
}

//    class PlanningFormModel {
//   String company;
//   String department;
//   List<String> costElements;
//   Map<String, MonthlyPlan> ceToMpMap;
//   List<int> amtList;
//     Map<String, MonthlyPlan> monthLevelPlan;

//   MonthlyPlan mPlan = new MonthlyPlan();
//  String cost = "";

//   String allCatagory;

//   PlanningFormModel() {
//     this.company = "N Tech";
//     this.department = "Marketing";
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
//     String planningFormInString = "company = " +
//         this.company +
//         "\n" +
//         "department = " +
//         this.department +
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
//     p = p + "'company':" + "'${this.company}'" + ",";
//     p = p + "'department':" + "'${this.department}'" + ",";
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

//       "company":this.company,
//       "department":this.department,

//           // "department":"${pfm.department}",
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

//           // "department":"${pfm.department}",
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
