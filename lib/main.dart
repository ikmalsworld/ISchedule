import 'package:flutter/material.dart';

void main() {
  runApp(const ISchedule());
}

class ISchedule extends StatelessWidget {
  const ISchedule({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISchedule',
      debugShowCheckedModeBanner: false,
      home: const LogoScreen(), // Set LogoScreen as the initial screen
    );
  }
}

class LogoScreen extends StatefulWidget {
  const LogoScreen({super.key});

  @override
  _LogoScreenState createState() => _LogoScreenState();
}

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  String? errorMessage;

  void _login() {
    final username = _usernameController.text;
    final password = _passwordController.text;

    if (username == 'admin' && password == '1234') {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => WelcomePage(username: username),
        ),
      );
    } else {
      setState(() {
        errorMessage = 'Invalid username or password';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgsi.jpg', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          // Center content inside a container
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white
                          .withOpacity(0.98), // Semi-transparent white
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        // Logo and App Name
                        Column(
                          children: [
                            Image.asset(
                              'assets/images/logo.png',
                              width: 85,
                              height: 85,
                              errorBuilder: (context, error, stackTrace) =>
                                  const Icon(
                                Icons.error,
                                size: 80,
                                color: Colors.red,
                              ),
                            ),
                            const SizedBox(height: 15),
                            ShaderMask(
                              shaderCallback: (bounds) => const LinearGradient(
                                colors: [
                                  Color(0xff027DFD),
                                  Color.fromARGB(255, 0, 70, 146),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ).createShader(
                                Rect.fromLTWH(
                                    0, 0, bounds.width, bounds.height),
                              ),
                              child: const Text(
                                "ISchedule",
                                style: TextStyle(
                                  fontFamily: 'montserrat',
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // Error message
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 10),
                        // Username field
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        // Password field
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
                        // Login button
                        GestureDetector(
                          onTap: _login,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(vertical: 12.0),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [
                                  Color(0xff027DFD),
                                  Color.fromARGB(255, 0, 70, 146),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Center(
                              child: Text(
                                'Login',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class ScheduleStorage {
  static final ScheduleStorage _instance = ScheduleStorage._internal();
  factory ScheduleStorage() => _instance;

  final Map<String, List<Map<String, dynamic>>> schedules = {};

  ScheduleStorage._internal();

  void saveSchedule(String day, List<Map<String, dynamic>> schedule) {
    schedules[day] = schedule;
  }

  List<Map<String, dynamic>> getSchedule(String day) {
    return schedules[day] ?? [];
  }
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();

    // Initialize AnimationController for scaling animation
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    // Navigate to LoginPage after 3 seconds
    Future.delayed(const Duration(seconds: 3), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose AnimationController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFFE0F7FA), // Background color for splash screen
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Animated logo with scaling effect
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/logo.png', // Ensure the correct file path
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error, // Show error icon if the image is missing
                  size: 80,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 20),
            // App name displayed below the logo with gradient text
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [
                  Color(0xff027DFD),
                  Color.fromARGB(255, 0, 70, 146)
                ], // Gradient colors
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: const Text(
                "ISchedule",
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors
                      .white, // This color is overridden by the ShaderMask
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class WelcomePage extends StatelessWidget {
  final String username; // Accept the username as a parameter

  const WelcomePage({super.key, required this.username});

  final List<String> days = const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bgsi.jpg'),
            fit:
                BoxFit.cover, // Adjust to BoxFit.cover or BoxFit.fill as needed
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, Colors.grey.shade200],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(25),
                      bottomRight: Radius.circular(25),
                    ),
                  ),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png', // Replace with your logo path
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Selamat Datang, $username', // Display the username dynamically
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: ListView.builder(
                    itemCount: days.length,
                    itemBuilder: (context, index) {
                      final day = days[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8.0),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => SchedulePage(day: day),
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff027DFD),
                                    Color.fromARGB(255, 212, 233, 255),
                                  ], // Gradient colors
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16.0, horizontal: 24.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        day,
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                        ),
                                      ),
                                      const SizedBox(height: 4.0),
                                      Text(
                                        'Details for $day',
                                        style: const TextStyle(
                                          fontSize: 14,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const Icon(
                                    Icons.arrow_forward_ios,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SchedulePage extends StatefulWidget {
  final String day;

  const SchedulePage({super.key, required this.day});

  @override
  _SchedulePageState createState() => _SchedulePageState();
}

class _SchedulePageState extends State<SchedulePage> {
  final List<Map<String, dynamic>> schedule = [];

  @override
  void initState() {
    super.initState();

    // Load the schedule for the specific day from storage
    final storedSchedule = ScheduleStorage().getSchedule(widget.day);

    setState(() {
      if (storedSchedule.isNotEmpty) {
        schedule.addAll(storedSchedule);
      } else {
        // Initialize with default schedule if no stored schedule exists
        schedule.addAll([
          {
            'time': '7:30 - 10:00',
            'subject': 'Tambah Matkul',
            'tasks': <String>[]
          },
          {
            'time': '10:15 - 12:50',
            'subject': 'Tambah Matkul',
            'tasks': <String>[]
          },
          {
            'time': '13:30 - 16:00',
            'subject': 'Tambah Matkul',
            'tasks': <String>[]
          },
          {
            'time': '16:00 - 18:00',
            'subject': 'Tambah Matkul',
            'tasks': <String>[]
          },
        ]);
      }
    });
  }

  void showAddTaskDialog(BuildContext context, Map<String, dynamic> item) {
    TextEditingController taskController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Tambahkan Tugas'),
          content: TextField(
            controller: taskController,
            decoration: const InputDecoration(
              labelText: 'Nama Tugas',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (taskController.text.isNotEmpty) {
                  setState(() {
                    item['tasks'].add(taskController.text);
                  });
                  saveSchedule(); // Save after adding a task
                }
                taskController.clear();
                Navigator.of(context).pop();
              },
              child: const Text('Tambah'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Tutup'),
            ),
          ],
        );
      },
    );
  }

  void saveSchedule() {
    ScheduleStorage()
        .saveSchedule(widget.day, schedule); // Save the updated schedule
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Jadwal Tersimpan!')),
    );
  }

  void showSubjectDialog(BuildContext context, int index) {
    TextEditingController subjectController = TextEditingController();
    subjectController.text = schedule[index]['subject'] == 'Tambah Matkul'
        ? ''
        : schedule[index]['subject'];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(schedule[index]['subject'] == 'Tambah Matkul'
              ? 'Masukkan Nama Mata Kuliah'
              : 'Edit Nama Mata Kuliah'),
          content: TextField(
            controller: subjectController,
            decoration: const InputDecoration(
              labelText: 'Nama Mata Kuliah',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                if (subjectController.text.isNotEmpty) {
                  setState(() {
                    schedule[index]['subject'] = subjectController.text;
                  });
                  saveSchedule(); // Save after editing the subject
                }
                Navigator.of(context).pop();
              },
              child: const Text('Simpan'),
            ),
            TextButton(
              onPressed: () {
                setState(() {
                  schedule[index]['subject'] = 'Tambah Matkul';
                });
                Navigator.of(context).pop();
              },
              child: const Text('Hapus'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your logo path
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'ISchedule - ${widget.day}', // Dynamic title with the selected day
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xff027DFD), // Primary color
                Color.fromARGB(255, 212, 233, 255), // Secondary lighter shade
              ],
            ),
          ),
        ),
        backgroundColor: Colors.transparent, // Makes the gradient visible
      ),
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/bgsi.jpg', // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: ListView.builder(
                itemCount: schedule.length,
                itemBuilder: (context, index) {
                  final item = schedule[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Color(0xff027DFD),
                            Color.fromARGB(255, 212, 233, 255),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['time'],
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                          const SizedBox(height: 8),
                          GestureDetector(
                            onTap: () => showSubjectDialog(context, index),
                            child: Container(
                              padding: const EdgeInsets.all(12.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item['subject'],
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 8),
                                  if (item['tasks'].isNotEmpty)
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: item['tasks']
                                          .map<Widget>(
                                            (task) => Row(
                                              children: [
                                                Checkbox(
                                                  value: false,
                                                  onChanged: (bool? value) {
                                                    if (value == true) {
                                                      setState(() {
                                                        item['tasks']
                                                            .remove(task);
                                                      });
                                                    }
                                                  },
                                                ),
                                                Expanded(
                                                  child: Text(task),
                                                ),
                                              ],
                                            ),
                                          )
                                          .toList(),
                                    ),
                                  GestureDetector(
                                    onTap: () =>
                                        showAddTaskDialog(context, item),
                                    child: const Text(
                                      '+ Tambah Tugas',
                                      style: TextStyle(
                                        color: Colors.blue,
                                        fontStyle: FontStyle.italic,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
