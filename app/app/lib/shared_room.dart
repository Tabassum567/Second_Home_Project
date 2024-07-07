// import 'package:flutter/material.dart';

// class RoomDetailsScreen extends StatefulWidget {
//   @override
//   _RoomDetailsScreenState createState() => _RoomDetailsScreenState();
// }

// void main() => runApp(MaterialApp(
//       debugShowCheckedModeBanner: false,
//       home: RoomDetailsScreen(),
//       theme: ThemeData(
//         primaryColor: Colors.blue,
//         accentColor: Colors.teal,
//         textTheme: TextTheme(
//           headline6: TextStyle(
//             color: Colors.black87,
//             fontWeight: FontWeight.bold,
//           ),
//           subtitle1: TextStyle(
//             color: Colors.grey[800],
//             fontWeight: FontWeight.w500,
//           ),
//           bodyText2: TextStyle(
//             color: Colors.grey[700],
//           ),
//         ),
//         elevatedButtonTheme: ElevatedButtonThemeData(
//           style: ElevatedButton.styleFrom(
//             primary: Colors.teal,
//             textStyle: TextStyle(
//               color: Colors.white,
//               fontWeight: FontWeight.bold,
//             ),
//           ),
//         ),
//       ),
//     ));

// class _RoomDetailsScreenState extends State<RoomDetailsScreen> {
//   bool _isShared = false;
//   int _numPrivateRooms = 0;
//   int _numBedsPerRoom = 0;
//   List<int> _bedsPerRoomList = [];
//   List<int> _sharedBedsPerRoomList = [];

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Room Details'),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             SizedBox(height: 8.0),
//             Row(
//               children: [
//                 Text(
//                   'Select Room Type:',
//                   style: Theme.of(context).textTheme.headline6,
//                 ),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isShared = true;
//                     });
//                   },
//                   child: Text('Shared'),
//                 ),
//                 SizedBox(width: 8.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     setState(() {
//                       _isShared = false;
//                     });
//                   },
//                   child: Text('Private'),
//                 ),
//               ],
//             ),
//             SizedBox(height: 16.0),
//             Visibility(
//               visible: _isShared,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Total number beds:',
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                   SizedBox(height: 8.0),
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       setState(() {
//                         _numBedsPerRoom = int.parse(value);
//                         // _numPrivateRooms = int.parse(value);
//                         if (_numBedsPerRoom < _sharedBedsPerRoomList.length) {
//                           _sharedBedsPerRoomList = _sharedBedsPerRoomList
//                               .sublist(0, _numBedsPerRoom);
//                         } else {
//                           for (int i = _sharedBedsPerRoomList.length;
//                               i < _numBedsPerRoom;
//                               i++) {
//                             _sharedBedsPerRoomList.add(0);
//                           }
//                         }
//                       });
//                     },
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Enter room details:',
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                   SizedBox(height: 8.0),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: _sharedBedsPerRoomList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     labelText: 'Beds in Room ${index + 1}',
//                                     filled: true,
//                                     fillColor: Colors.grey[200],
//                                     border: OutlineInputBorder(),
//                                   ),
//                                   onChanged: (value) {
//                                     if (_sharedBedsPerRoomList.length > index) {
//                                       _sharedBedsPerRoomList[index] =
//                                           int.parse(value);
//                                     } else {
//                                       _sharedBedsPerRoomList
//                                           .add(int.parse(value));
//                                     }
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 8.0),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _sharedBedsPerRoomList.removeAt(index);
//                                   });
//                                 },
//                                 child: Icon(Icons.delete),
//                               ),
//                             ],
//                           ));
//                     },
//                   ),
//                   SizedBox(height: 8.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _sharedBedsPerRoomList.add(0);
//                       });
//                     },
//                     child: Text('Add Room'),
//                   ),
//                 ],
//               ),
//             ),
//             Visibility(
//               visible: !_isShared,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     'Number of Private Rooms:',
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                   SizedBox(height: 8.0),
//                   TextField(
//                     keyboardType: TextInputType.number,
//                     onChanged: (value) {
//                       setState(() {
//                         _numPrivateRooms = int.parse(value);
//                         if (_numPrivateRooms < _bedsPerRoomList.length) {
//                           _bedsPerRoomList =
//                               _bedsPerRoomList.sublist(0, _numPrivateRooms);
//                         } else {
//                           for (int i = _bedsPerRoomList.length;
//                               i < _numPrivateRooms;
//                               i++) {
//                             _bedsPerRoomList.add(0);
//                           }
//                         }
//                       });
//                     },
//                     decoration: InputDecoration(
//                       filled: true,
//                       fillColor: Colors.grey[200],
//                       border: OutlineInputBorder(),
//                     ),
//                   ),
//                   SizedBox(height: 16.0),
//                   Text(
//                     'Enter Room Details:',
//                     style: Theme.of(context).textTheme.subtitle1,
//                   ),
//                   SizedBox(height: 8.0),
//                   ListView.builder(
//                     shrinkWrap: true,
//                     physics: NeverScrollableScrollPhysics(),
//                     itemCount: _bedsPerRoomList.length,
//                     itemBuilder: (BuildContext context, int index) {
//                       return Padding(
//                           padding: const EdgeInsets.only(bottom: 8.0),
//                           child: Row(
//                             children: [
//                               Expanded(
//                                 child: TextField(
//                                   keyboardType: TextInputType.number,
//                                   decoration: InputDecoration(
//                                     labelText: 'Beds in Room ${index + 1}',
//                                     filled: true,
//                                     fillColor: Colors.grey[200],
//                                     border: OutlineInputBorder(),
//                                   ),
//                                   onChanged: (value) {
//                                     if (_bedsPerRoomList.length > index) {
//                                       _bedsPerRoomList[index] =
//                                           int.parse(value);
//                                     } else {
//                                       _bedsPerRoomList.add(int.parse(value));
//                                     }
//                                   },
//                                 ),
//                               ),
//                               SizedBox(width: 8.0),
//                               ElevatedButton(
//                                 onPressed: () {
//                                   setState(() {
//                                     _bedsPerRoomList.removeAt(index);
//                                   });
//                                 },
//                                 child: Icon(Icons.delete),
//                               ),
//                             ],
//                           ));
//                     },
//                   ),
//                   SizedBox(height: 8.0),
//                   ElevatedButton(
//                     onPressed: () {
//                       setState(() {
//                         _bedsPerRoomList.add(0);
//                       });
//                     },
//                     child: Text('Add Room'),
//                   ),
//                 ],
//               ),
//             ),
//             SizedBox(height: 16.0),
//             ElevatedButton(
//               onPressed: () {
// // Save the room details
//                 print('Private: $_bedsPerRoomList');
//                 print('Shared: $_sharedBedsPerRoomList');
//               },
//               child: Text('Save'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
