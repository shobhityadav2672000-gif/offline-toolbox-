import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

void main() {
  runApp(const OfflineToolboxApp());
}

class OfflineToolboxApp extends StatelessWidget {
  const OfflineToolboxApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Offline Toolbox',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF121212),
        primaryColor: Colors.deepPurpleAccent,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1E1E1E),
          centerTitle: true,
        ),
      ),
      home: const DashboardScreen(),
    );
  }
}

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  final List<Map<String, dynamic>> tools = const [
    {'title': 'Calculator', 'icon': Icons.calculate, 'screen': CalculatorScreen()},
    {'title': 'Unit Converter', 'icon': Icons.swap_horiz, 'screen': UnitConverterScreen()},
    {'title': 'Stopwatch', 'icon': Icons.timer, 'screen': StopwatchScreen()},
    {'title': 'Notes / To-Do', 'icon': Icons.note_add, 'screen': NotesScreen()},
    {'title': 'BMI Calculator', 'icon': Icons.fitness_center, 'screen': BMIScreen()},
    {'title': 'Compass (Sim)', 'icon': Icons.explore, 'screen': CompassScreen()},
    {'title': 'Flashlight', 'icon': Icons.flash_on, 'screen': FlashlightScreen()},
    {'title': 'Tip Calculator', 'icon': Icons.attach_money, 'screen': TipCalculatorScreen()},
    {'title': 'Dice / Coin', 'icon': Icons.casino, 'screen': RandomizerScreen()},
    {'title': 'Counter', 'icon': Icons.add_circle_outline, 'screen': TallyCounterScreen()},
    {'title': 'Clock & Alarm', 'icon': Icons.access_time, 'screen': ClockScreen()},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Offline Toolbox (11 Tools)'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: tools.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
          ),
          itemBuilder: (context, index) {
            final tool = tools[index];
            return Card(
              color: const Color(0xFF1E1E1E),
              elevation: 4,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => tool['screen']),
                  );
                },
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(tool['icon'], size: 48, color: Colors.deepPurpleAccent),
                    const SizedBox(height: 12),
                    Text(
                      tool['title'],
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

// 1. Calculator Screen
class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});
  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';

  void btnPressed(String val) {
    setState(() {
      if (val == 'C') {
        input = '';
        result = '0';
      } else if (val == '=') {
        try {
          result = _evaluate(input);
        } catch (e) {
          result = 'Error';
        }
      } else {
        input += val;
      }
    });
  }

  String _evaluate(String expr) {
    expr = expr.replaceAll('x', '*').replaceAll('÷', '/');
    List<String> tokens = expr.split(RegExp(r'(?<=[+-/*])|(?=[+-/*])'));
    if (tokens.length < 3) return expr;
    double num1 = double.parse(tokens[0]);
    String op = tokens[1];
    double num2 = double.parse(tokens[2]);
    double res = 0;
    if (op == '+') res = num1 + num2;
    if (op == '-') res = num1 - num2;
    if (op == '*') res = num1 * num2;
    if (op == '/') res = num2 != 0 ? num1 / num2 : 0;
    return res.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    final buttons = [
      '7', '8', '9', '÷',
      '4', '5', '6', 'x',
      '1', '2', '3', '-',
      'C', '0', '=', '+'
    ];

    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      body: Column(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.bottomRight,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(input, style: const TextStyle(fontSize: 28, color: Colors.grey)),
                  Text(result, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold)),
                ],
              ),
            ),
          ),
          GridView.builder(
            shrinkWrap: true,
            itemCount: buttons.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 4),
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF2C2C2C)),
                  onPressed: () => btnPressed(buttons[index]),
                  child: Text(buttons[index], style: const TextStyle(fontSize: 24, color: Colors.white)),
                ),
              );
            },
          )
        ],
      ),
    );
  }
}

// 2. Unit Converter
class UnitConverterScreen extends StatefulWidget {
  const UnitConverterScreen({super.key});
  @override
  State<UnitConverterScreen> createState() => _UnitConverterScreenState();
}

class _UnitConverterScreenState extends State<UnitConverterScreen> {
  double km = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Unit Converter')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Kilometers (km)', border: OutlineInputBorder()),
              onChanged: (val) {
                setState(() {
                  km = double.tryParse(val) ?? 0;
                });
              },
            ),
            const SizedBox(height: 20),
            Card(
              child: ListTile(
                title: const Text('Miles'),
                subtitle: Text('${(km * 0.621371).toStringAsFixed(2)} miles', style: const TextStyle(fontSize: 20)),
              ),
            ),
            Card(
              child: ListTile(
                title: const Text('Meters'),
                subtitle: Text('${(km * 1000).toStringAsFixed(0)} m', style: const TextStyle(fontSize: 20)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// 3. Stopwatch Screen
class StopwatchScreen extends StatefulWidget {
  const StopwatchScreen({super.key});
  @override
  State<StopwatchScreen> createState() => _StopwatchScreenState();
}

class _StopwatchScreenState extends State<StopwatchScreen> {
  late Stopwatch _stopwatch;
  late Timer _timer;

  @override
  void initState() {
    super.initState();
    _stopwatch = Stopwatch();
  }

  void _startStop() {
    setState(() {
      if (_stopwatch.isRunning) {
        _stopwatch.stop();
      } else {
        _stopwatch.start();
        _timer = Timer.periodic(const Duration(milliseconds: 100), (timer) {
          setState(() {});
        });
      }
    });
  }

  void _reset() {
    setState(() {
      _stopwatch.reset();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stopwatch')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '${(_stopwatch.elapsedMilliseconds / 1000).toStringAsFixed(1)}s',
              style: const TextStyle(fontSize: 60, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: _startStop,
                  child: Text(_stopwatch.isRunning ? 'Pause' : 'Start'),
                ),
                const SizedBox(width: 20),
                ElevatedButton(
                  onPressed: _reset,
                  child: const Text('Reset'),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}

// 4. Notes Screen
class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final List<String> notes = [];
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Notes / To-Do')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration: const InputDecoration(hintText: 'Enter note...', border: OutlineInputBorder()),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: () {
                    if (controller.text.isNotEmpty) {
                      setState(() {
                        notes.add(controller.text);
                        controller.clear();
                      });
                    }
                  },
                )
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: notes.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(notes[index]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () {
                      setState(() {
                        notes.removeAt(index);
                      });
                    },
                  ),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

// 5. BMI Calculator Screen
class BMIScreen extends StatefulWidget {
  const BMIScreen({super.key});
  @override
  State<BMIScreen> createState() => _BMIScreenState();
}

class _BMIScreenState extends State<BMIScreen> {
  double weight = 70;
  double height = 170;
  double bmi = 0;

  void calculateBMI() {
    setState(() {
      bmi = weight / ((height / 100) * (height / 100));
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('BMI Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Text('Weight: ${weight.round()} kg'),
            Slider(
              value: weight,
              min: 30,
              max: 150,
              onChanged: (val) => setState(() => weight = val),
            ),
            Text('Height: ${height.round()} cm'),
            Slider(
              value: height,
              min: 100,
              max: 220,
              onChanged: (val) => setState(() => height = val),
            ),
            ElevatedButton(onPressed: calculateBMI, child: const Text('Calculate BMI')),
            const SizedBox(height: 20),
            if (bmi > 0)
              Text('BMI: ${bmi.toStringAsFixed(1)}', style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 6. Compass Screen (Simulated)
class CompassScreen extends StatelessWidget {
  const CompassScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Compass (Simulated)')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.navigation, size: 120, color: Colors.redAccent),
            SizedBox(height: 20),
            Text('Pointing North', style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// 7. Flashlight Screen
class FlashlightScreen extends StatefulWidget {
  const FlashlightScreen({super.key});
  @override
  State<FlashlightScreen> createState() => _FlashlightScreenState();
}

class _FlashlightScreenState extends State<FlashlightScreen> {
  bool isOn = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: isOn ? Colors.white : Colors.black,
      appBar: AppBar(title: const Text('Flashlight')),
      body: Center(
        child: IconButton(
          iconSize: 100,
          icon: Icon(Icons.power_settings_new, color: isOn ? Colors.black : Colors.white),
          onPressed: () {
            setState(() {
              isOn = !isOn;
            });
          },
        ),
      ),
    );
  }
}

// 8. Tip Calculator Screen
class TipCalculatorScreen extends StatefulWidget {
  const TipCalculatorScreen({super.key});
  @override
  State<TipCalculatorScreen> createState() => _TipCalculatorScreenState();
}

class _TipCalculatorScreenState extends State<TipCalculatorScreen> {
  double bill = 0;
  double tipPercent = 10;
  @override
  Widget build(BuildContext context) {
    double tipAmount = bill * (tipPercent / 100);
    double total = bill + tipAmount;

    return Scaffold(
      appBar: AppBar(title: const Text('Tip Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Bill Amount (₹)', border: OutlineInputBorder()),
              onChanged: (val) => setState(() => bill = double.tryParse(val) ?? 0),
            ),
            const SizedBox(height: 20),
            Text('Tip: ${tipPercent.round()}%'),
            Slider(
              value: tipPercent,
              min: 0,
              max: 30,
              onChanged: (val) => setState(() => tipPercent = val),
            ),
            Card(
              child: ListTile(
                title: Text('Total Bill: ₹${total.toStringAsFixed(2)}'),
                subtitle: Text('Tip Amount: ₹${tipAmount.toStringAsFixed(2)}'),
              ),
            )
          ],
        ),
      ),
    );
  }
}

// 9. Randomizer (Dice & Coin) Screen
class RandomizerScreen extends StatefulWidget {
  const RandomizerScreen({super.key});
  @override
  State<RandomizerScreen> createState() => _RandomizerScreenState();
}

class _RandomizerScreenState extends State<RandomizerScreen> {
  int diceVal = 1;
  String coinVal = 'Heads';

  void rollDice() {
    setState(() {
      diceVal = Random().nextInt(6) + 1;
    });
  }

  void flipCoin() {
    setState(() {
      coinVal = Random().nextBool() ? 'Heads' : 'Tails';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Dice / Coin Roller')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Dice Roll: $diceVal', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: rollDice, child: const Text('Roll Dice')),
            const SizedBox(height: 40),
            Text('Coin Flip: $coinVal', style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold)),
            ElevatedButton(onPressed: flipCoin, child: const Text('Flip Coin')),
          ],
        ),
      ),
    );
  }
}

// 10. Tally Counter Screen
class TallyCounterScreen extends StatefulWidget {
  const TallyCounterScreen({super.key});
  @override
  State<TallyCounterScreen> createState() => _TallyCounterScreenState();
}

class _TallyCounterScreenState extends State<TallyCounterScreen> {
  int count = 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Tally Counter')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('$count', style: const TextStyle(fontSize: 80, fontWeight: FontWeight.bold)),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                IconButton(iconSize: 48, icon: const Icon(Icons.remove_circle), onPressed: () => setState(() => count--)),
                const SizedBox(width: 20),
                IconButton(iconSize: 48, icon: const Icon(Icons.add_circle), onPressed: () => setState(() => count++)),
              ],
            ),
            ElevatedButton(onPressed: () => setState(() => count = 0), child: const Text('Reset')),
          ],
        ),
      ),
    );
  }
}

// 11. Clock Screen
class ClockScreen extends StatelessWidget {
  const ClockScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Clock')),
      body: Center(
        child: StreamBuilder(
          stream: Stream.periodic(const Duration(seconds: 1)),
          builder: (context, snapshot) {
            final now = DateTime.now();
            final timeStr = "${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}:${now.second.toString().padLeft(2, '0')}";
            return Text(
              timeStr,
              style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
            );
          },
        ),
      ),
    );
  }
}
