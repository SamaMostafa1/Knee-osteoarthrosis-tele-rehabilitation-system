// import 'package:flutter/material.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class StatsPage extends StatefulWidget {
//   const StatsPage({super.key});

//   @override
//   State<StatsPage> createState() => _StatsPageState();
// }

// class _StatsPageState extends State<StatsPage> {
//   var width, height;
//   final SupabaseClient supabase = Supabase.instance.client;
//   String response ="";

//   Future<void> _getPrediction() async {
//     response = await Supabase.instance.client
//         .from('Patient_Personal_Data')
//         .select('prediction')
//         .eq('id', 1)
//         .single();
//   }

//   void updateRecord(String button, bool value) async {
//     await supabase.from('Controls').update({button: value}).eq('id', 1);
//   }

//   @override
//   void initState() {
//     updateRecord('stats', true);
//     Future.delayed(Duration(seconds: 5));
//     _getPrediction();
//     super.initState();
//   }

//   @override
//   void dispose() {
//     updateRecord("stats", false);
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     height = MediaQuery.of(context).size.height;
//     width = MediaQuery.of(context).size.width;
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text(
//           'Statistics',
//           style: TextStyle(
//             fontWeight: FontWeight.bold,
//             fontSize: 25,
//             letterSpacing: 1,
//           ),
//         ),
//         centerTitle: true,
//         foregroundColor: Colors.white,
//         backgroundColor: Colors.blue[900],
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.only(
//             bottomLeft: Radius.circular(25),
//             bottomRight: Radius.circular(25),
//           ),
//         ),
//       ),
//       body: Theme(
//         data: ThemeData(
//           colorScheme: ColorScheme.light(
//             primary:
//                 Colors.blue.shade900, // This will change the active step color
//             //secondary: Colors.green, // This will change the text color
//           ),
//         ),
//         child: Padding(
//             padding: EdgeInsets.only(top: height * 0.05),
//             child: Column(
//               children: [
//                 Text("Prediction"),
//                 Tect("$response");
//               ],
//             )),
//       ),
//     );
//   }
// }

import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {
  var width, height;
  final SupabaseClient supabase = Supabase.instance.client;
  String prediction = "";

  Future<void> _getPrediction() async {
    final response = await supabase
        .from('Patient_Personal_Data')
        .select('prediction')
        .eq('id', 1)
        .single();
    print(response);
    setState(() {
      prediction = response['prediction'] as String;
    });
  }

  void updateRecord(String button, bool value) async {
    await supabase.from('Controls').update({button: value}).eq('id', 1);
  }

  @override
  void initState() {
    super.initState();
    updateRecord('stats', true);
    Future.delayed(Duration(seconds: 5), () {
      _getPrediction();
    });
  }

  @override
  void dispose() {
    updateRecord("stats", false);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    height = MediaQuery.of(context).size.height;
    width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistics',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 25,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        foregroundColor: Colors.white,
        backgroundColor: Colors.blue[900],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight: Radius.circular(25),
          ),
        ),
      ),
      body: Theme(
        data: ThemeData(
          colorScheme: ColorScheme.light(
            primary: Colors.blue.shade900,
          ),
        ),
        child: Padding(
          padding: EdgeInsets.only(top: height * 0.2),
          child: Column(
            children: [
              Center(
                  child: Text(
                "Prediction",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              )),
              SizedBox(height: height * 0.1),
              Text(
                "$prediction",
                style: TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
