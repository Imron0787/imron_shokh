import 'dart:convert';

import 'dart:async';
import 'dart:math';

import 'package:animated_notch_bottom_bar/animated_notch_bottom_bar/animated_notch_bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final _pageController = PageController(initialPage: 4);
  final NotchBottomBarController _controller = NotchBottomBarController(index: 4);

  int maxCount = 5;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> bottomBarPages = [
      Page1(controller: _controller),
       Page2(),
      const My(),
      const MyAp(),
      const MemoryGame(),
    ];
    return Scaffold(
      body: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        children: List.generate(bottomBarPages.length, (index) => bottomBarPages[index]),
      ),
      extendBody: true,
      bottomNavigationBar: (bottomBarPages.length <= maxCount)
          ? AnimatedNotchBottomBar(
              notchBottomBarController: _controller,
              color: const Color.fromARGB(255, 37, 21, 216),
              showLabel: true,
              textOverflow: TextOverflow.visible,
              maxLine: 1,
              shadowElevation: 5,
              kBottomRadius: 28.0,
              notchColor: Color.fromARGB(255, 37, 21, 216),
              removeMargins: false,
              bottomBarWidth: 500,
              showShadow: false,
              durationInMilliSeconds: 300,
              itemLabelStyle: const TextStyle(fontSize: 10),
              elevation: 1,
              bottomBarItems: const [
                BottomBarItem(
                  inActiveItem: Icon(Icons.home_filled),
                  activeItem: Icon(Icons.home_filled),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.star),
                  activeItem: Icon(Icons.star),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.person),
                  activeItem: Icon(Icons.person),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.settings),
                  activeItem: Icon(Icons.settings),
                ),
                BottomBarItem(
                  inActiveItem: Icon(Icons.offline_bolt),
                  activeItem: Icon(Icons.offline_bolt),
                ),
              ],
              onTap: (index) {
                ('current selected index $index');
                _pageController.jumpToPage(index);
              },
              kIconSize: 24.0,
            )
          : null,
    );
  }
}

class Page1 extends StatelessWidget {
  final NotchBottomBarController? controller;

  const Page1({Key? key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onTap: () {
          controller?.jumpTo(2);
        },
        child: const Text("RAXMAT",style: TextStyle(fontSize: 50),),
      ),
    );
  }
}








class MyAppl extends StatelessWidget {
  const MyAppl({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Page2(),
    );
  }
}

class Page2 extends StatefulWidget {
  @override
  _Page2State createState() => _Page2State();
}

class _Page2State extends State<Page2> {
  List<Map<String, String>> _items = [];

  @override
  void initState() {
    super.initState();
    _loadItems();
  }

  void _loadItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? items = prefs.getString('items');
    if (items != null) {
      setState(() {
        _items = List<Map<String, String>>.from(
            json.decode(items).map((item) => Map<String, String>.from(item)));
      });
    }
  }

  void _saveItems() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('items', json.encode(_items));
  }

  void _removeItem(int index) {
    setState(() {
      _items.removeAt(index);
      _saveItems();
    });
  }

  // Edit an existing item
  void _editItem(int index) async {
    final result = await showDialog<Map<String, String>>(
      context: context,
      builder: (BuildContext context) {
        return AddItemDialog(
          initialText: _items[index]['text'],
          initialTime: _items[index]['time'],
        );
      },
    );
    if (result != null && result.isNotEmpty) {
      setState(() {
        _items[index] = result;
        _saveItems();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("rasm/q.webp"), // Path to your background image
                fit: BoxFit.cover, // Cover the entire screen
              ),
            ),
          ),
          // Main Content
          _items.isEmpty
              ? Center()
              : ListView.builder(
                  padding: EdgeInsets.all(10),
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8), // Slight transparency for overlay effect
                        borderRadius: BorderRadius.circular(12),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.3),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ListTile(
                        contentPadding:
                            EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        title: Text(
                          "${_items[index]['text']}",
                          style: TextStyle(
                            fontSize: 18,
                            color: Color.fromARGB(255, 37, 21, 216),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Qo'shilgan sana:"),
                            Text(
                              "${_items[index]['date']}", // Display the date when the item was added
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              "Qo'shilgan vaqti: ${_items[index]['time']}", // Display the time when the item was added
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: Icon(
                                Icons.edit, // Pencil icon for editing
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _editItem(index); // Edit the item
                              },
                            ),
                            IconButton(
                              icon: Icon(
                                Icons.close, // Close icon for removing
                                color: Colors.grey,
                              ),
                              onPressed: () {
                                _removeItem(index); // Remove the item
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
        ],
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.only(bottom: 70),
        child: FloatingActionButton(
          onPressed: () async {
            final result = await showDialog<Map<String, String>>(
              context: context,
              builder: (BuildContext context) {
                return AddItemDialog();
              },
            );
            if (result != null && result.isNotEmpty) {
              setState(() {
                _items.add(result);
                _saveItems();
              });
            }
          },
          child: Icon(Icons.add),
        ),
      ),
    );
  }
}

class AddItemDialog extends StatefulWidget {
  final String? initialText;
  final String? initialTime;

  AddItemDialog({this.initialText, this.initialTime});

  @override
  _AddItemDialogState createState() => _AddItemDialogState();
}

class _AddItemDialogState extends State<AddItemDialog> {
  TextEditingController _textFieldController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _textFieldController.text = widget.initialText ?? '';
    if (widget.initialTime != null && widget.initialTime != 'Tanlanmagan') {
      final timeParts = widget.initialTime!.split(':');
      _selectedTime = TimeOfDay(
        hour: int.parse(timeParts[0]),
        minute: int.parse(timeParts[1].split(' ')[0]),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20),
      ),
      child: Container(
        decoration: BoxDecoration(
  color: Colors.purple.shade900.withOpacity(0.1), // shade900 yoki boshqa shade ishlatish mumkin
  borderRadius: BorderRadius.circular(20),
),

        
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(
              "Ma'lumot kiriting",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: 20),
            TextField(
              controller: _textFieldController,
              decoration: InputDecoration(
                labelText: 'Ism kiriting',
              ),
            ),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text('Bekor qilish'),
                ),
                TextButton(
                  onPressed: () {
                    // Format current date and time
                    final now = DateTime.now();
                    final formattedDate = "${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}";
                    final formattedTime = _selectedTime != null
                        ? _selectedTime!.format(context)
                        : '${now.hour}:${now.minute.toString().padLeft(2, '0')}';
                    Navigator.of(context).pop({
                      'text': _textFieldController.text,
                      'date': formattedDate,
                      'time': formattedTime,
                    });
                  },
                  // style: ElevatedButton.styleFrom(
                  //   backgroundColor: Colors.transparent,
                  //   // shape: RoundedRectangleBorder(
                  //   //   borderRadius: BorderRadius.circular(12),
                  //   // ),
                  // ),
                  child: Text(
                    "Qo'shish",
                    style: TextStyle(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
















class My extends StatefulWidget {
  const My({Key? key}) : super(key: key);

  @override
  _MyState createState() => _MyState();
}

class _MyState extends State<My> {
  List<Map<String, dynamic>> data = [];
  String dollarRate = '';

  Future<void> fetchData() async {
    try {
      final response = await http.get(Uri.parse("https://cbu.uz/uz/arkhiv-kursov-valyut/json/"));
      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        setState(() {
          data = jsonData.map((e) => Map<String, dynamic>.from(e)).toList();
          // Find the dollar rate from the data
          var dollarData = data.firstWhere(
            (element) => element['Ccy'] == 'USD',
            orElse: () => {},
          );
          dollarRate = dollarData.isNotEmpty ? dollarData['Rate'] : 'N/A'; // Assign dollar rate or N/A
        });
      } else {
        throw Exception('Failed to load data');
      }
    } catch (e) {
      ('Error: $e');
    }
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'kurs: $dollarRate UZS', // Display the dollar rate in the app bar
          style: TextStyle(color: Colors.black, fontSize: 24),
        ),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: List.generate(50, (index) {
                int lineLength = index + 1;
                return Text(
                  'X' * lineLength,
                  style: TextStyle(fontSize: 20),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}


class MyAp extends StatelessWidget {
  const MyAp({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const CountdownPage(),
    );
  }
}

class CountdownPage extends StatefulWidget {
  const CountdownPage({Key? key}) : super(key: key);

  @override
  _CountdownPageState createState() => _CountdownPageState();
}

class _CountdownPageState extends State<CountdownPage> {
  Duration _duration = Duration(days: 111, hours: 12, minutes: 43, seconds: 17);
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_duration.inSeconds > 0) {
          _duration -= Duration(seconds: 1);
        } else {
          _timer?.cancel();
        }
      });
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final days = _duration.inDays;
    final hours = _duration.inHours % 24;
    final minutes = _duration.inMinutes % 60;
    final seconds = _duration.inSeconds % 60;

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Yil tugashiga qolgan vaqt:',
              style: TextStyle(fontSize: 24),
            ),
            Text(
              '$days kun,\n$hours soat,\n$minutes daqiqa,\n$seconds sekund',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 20),
            ),
          ],
        ),
      ),
    );
  }
}









class MemoryGame extends StatefulWidget {
  const MemoryGame({Key? key}) : super(key: key);

  @override
  _MemoryGameState createState() => _MemoryGameState();
}

class _MemoryGameState extends State<MemoryGame> {
  final int gridSize = 5;
  List<bool> visible = [];
  List<String> images = [];
  final List<String> imageUrls = [
    'rasm/q.webp',
    'rasm/q1jpg.',
    'rasm/q2.jpg.',
    'rasm/q3.jpg',
    'rasm/q4.jpg',
    'rasm/q5.jpg',
    'rasm/q6.jpg',
    'rasm/q7.webp',
    'rasm/q8.webp',
    'rasm/q9.jpg',
    'rasm/q10.jpg',
    'rasm/q10.jpg',
    'rasm/q9.jgp',
    'rasm/q8.webp',
    'rasm/q7.webp',
    'rasm/q6.jpg',
    'rasm/q5.jpg',
    'rasm/q4.jpg',
    'rasm/q3.jpg',
    'rasm/q2.jpg',
    'rasm/q1.jpg',
    'rasm/q.webp',
    'rasm/q10.jpg',
    'rasm/q8.webp',
    'rasm/q2.jpg',
  ];

  @override
  void initState() {
    super.initState();
    resetGame(); // Initialize the game with shuffled images
  }

  void resetGame() {
    setState(() {
      // Shuffle images and reset visibility
      images = List<String>.from(imageUrls)..shuffle(Random());
      visible = List.generate(gridSize * gridSize, (index) => false);
    });
  }

  void revealTile(int index) {
    setState(() {
      visible[index] = !visible[index];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 37, 21, 216),
        title: Text(
          '1989',
          style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: IconButton(
              onPressed: resetGame, // Shuffle and reset the game
              icon: Icon(Icons.refresh, size: 30),
            ),
          )
        ],
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.only(top: 50),
          child: GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: gridSize,
              crossAxisSpacing: 8,
              mainAxisSpacing: 8,
            ),
            itemCount: gridSize * gridSize,
            itemBuilder: (context, index) {
              return GestureDetector(onTap: () => revealTile(index),
                child: Container(
                  color: Colors.grey,
                  child: visible[index]
                      ? Image.asset(
                          images[index], // Display the shuffled image
                          fit: BoxFit.cover,
                        )
                      : Container(color: Colors.blueGrey),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}