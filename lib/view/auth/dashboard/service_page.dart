// // lib/settings_page.dart

// import 'package:flutter/material.dart';
// import 'package:hamro_grocery_mobile/common/service/proximity_sensor_setting.dart';

// class SettingsPage extends StatelessWidget {
//   const SettingsPage({Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text('Settings')),
//       body: ListView(
//         // The list is not 'const'
//         children: const [
//           // This widget can now be found because of the import.
//           ProximitySensorSettingsWidget(),

//           ListTile(
//             leading: Icon(Icons.notifications),
//             title: Text('Notifications'),
//             trailing: Icon(Icons.arrow_forward_ios),
//           ),
//           ListTile(
//             leading: Icon(Icons.lock),
//             title: Text('Privacy'),
//             trailing: Icon(Icons.arrow_forward_ios),
//           ),
//         ],
//       ),
//     );
//   }
// }
