import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

void main() {
  runApp(const ISchedule());
}

class ISchedule extends StatelessWidget {
  const ISchedule({super.key});

  @override
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ISchedule',
      debugShowCheckedModeBanner: false,
      home: const LogoScreen(),
      routes: {
        '/welcome': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return WelcomePage(username: args['username']);
        },
        '/todo': (context) {
          final args = ModalRoute.of(context)!.settings.arguments
              as Map<String, dynamic>;
          return ToDoListPage(username: args['username']);
        },
        '/login': (context) => const LoginPage(),
      },
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
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      body: Stack(
        children: [
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color.fromARGB(255, 255, 255, 255)
                          .withOpacity(0.98),
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
                                  color: Color.fromARGB(255, 193, 193, 193),
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        if (errorMessage != null)
                          Text(
                            errorMessage!,
                            style: const TextStyle(color: Colors.red),
                          ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _usernameController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 10),
                        TextField(
                          controller: _passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                        ),
                        const SizedBox(height: 20),
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

  int getSubjectCount(String day) {
    final schedule = getSchedule(day);
    return schedule.where((item) => item['subject'] != 'Tambah Matkul').length;
  }

  int getTaskCountForDay(String day) {
    final schedule = getSchedule(day);
    int taskCount = 0;

    for (var item in schedule) {
      var tasks = item['tasks'];
      if (tasks is List) {
        taskCount += tasks.length;
      }
    }

    return taskCount;
  }
}

class _LogoScreenState extends State<LogoScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 0.9, end: 1.1).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
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
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: const Color.fromARGB(255, 240, 242, 245),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ScaleTransition(
              scale: _animation,
              child: Image.asset(
                'assets/images/logo.png',
                width: 120,
                height: 120,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.error,
                  size: 80,
                  color: Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 20),
            ShaderMask(
              shaderCallback: (bounds) => const LinearGradient(
                colors: [Color(0xff027DFD), Color.fromARGB(255, 0, 70, 146)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ).createShader(Rect.fromLTWH(0, 0, bounds.width, bounds.height)),
              child: const Text(
                "ISchedule",
                style: TextStyle(
                  fontFamily: 'montserrat',
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
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
  final String username;

  const WelcomePage({super.key, required this.username});

  final List<String> days = const ['Senin', 'Selasa', 'Rabu', 'Kamis', 'Jumat'];

  @override
  Widget build(BuildContext context) {
    final ScheduleStorage storage = ScheduleStorage();

    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0, // Default to Home
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              '/welcome',
              arguments: {'username': username}, // Pass username here
            );
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              '/todo',
              arguments: {'username': username}, // Pass username here
            );
          } else if (index == 2) {
            _showLogoutDialog(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'To-Do List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
      body: Container(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                      color: const Color.fromARGB(223, 255, 255, 255),
                      borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(25),
                        bottomRight: Radius.circular(25),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ]),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/logo.png',
                        width: 50,
                        height: 50,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Selamat Datang, $username',
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
                      final subjectCount = storage.getSubjectCount(day);
                      final taskCount = storage.getTaskCountForDay(day) as int;
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
                              ).then((_) {
                                (context as Element).markNeedsBuild();
                              });
                            },
                            borderRadius: BorderRadius.circular(10),
                            child: Ink(
                              decoration: BoxDecoration(
                                color: const Color(0xff25328C),
                                gradient: LinearGradient(
                                  colors: [
                                    Color(0xff027DFD),
                                    Color.fromARGB(255, 0, 70, 146),
                                  ],
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
                                        '$subjectCount Mata Kuliah, $taskCount tugas',
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

void _showLogoutDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: const Text('Konfirmasi Logout'),
        content: const Text('Apakah anda ingin Log Out?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushReplacementNamed(context, '/login');
            },
            child: const Text('Log Out'),
          ),
        ],
      );
    },
  );
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
    final storedSchedule = ScheduleStorage().getSchedule(widget.day);

    setState(() {
      if (storedSchedule.isNotEmpty) {
        schedule.addAll(storedSchedule);
      } else {
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
    ScheduleStorage().saveSchedule(widget.day, schedule);
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
                  saveSchedule();
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
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'ISchedule - ${widget.day}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(223, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
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
                        color: Color(0xff25328C),
                        gradient: LinearGradient(
                          colors: [
                            Color(0xff027DFD),
                            Color.fromARGB(255, 0, 70, 146),
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

class ToDoListPage extends StatefulWidget {
  final String username;

  const ToDoListPage({Key? key, required this.username}) : super(key: key);

  @override
  State<ToDoListPage> createState() => _ToDoListPageState();
}

class _ToDoListPageState extends State<ToDoListPage> {
  final List<ToDoItem> _toDoList = [];
  final TextEditingController _controller = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadToDoList();
  }

  Future<void> _loadToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String? todoString = prefs.getString('todo_list');

    if (todoString != null) {
      final List<dynamic> jsonData = json.decode(todoString);
      setState(() {
        _toDoList.clear();
        _toDoList.addAll(jsonData.map((item) => ToDoItem.fromMap(item)));
      });
    }
  }

  Future<void> _saveToDoList() async {
    final prefs = await SharedPreferences.getInstance();
    final String jsonString =
        json.encode(_toDoList.map((item) => item.toMap()).toList());
    prefs.setString('todo_list', jsonString);
  }

  void _addToDo(String title) {
    setState(() {
      _toDoList.add(ToDoItem(title: title));
      _saveToDoList();
    });
    _controller.clear();
  }

  void _toggleDone(int index) {
    setState(() {
      _toDoList[index].isDone = !_toDoList[index].isDone;
      _saveToDoList();
    });
  }

  void _deleteToDo(int index) {
    setState(() {
      _toDoList.removeAt(index);
      _saveToDoList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final toDoItems = _toDoList.where((item) => !item.isDone).toList();
    final doneItems = _toDoList.where((item) => item.isDone).toList();

    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 240, 242, 245),
      appBar: AppBar(
        title: Row(
          children: [
            Image.asset(
              'assets/images/logo.png',
              height: 24,
              width: 24,
            ),
            const SizedBox(width: 8),
            Text(
              'To-Do List',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            color: Color.fromARGB(223, 255, 255, 255),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: const Offset(0, 4),
              )
            ],
          ),
        ),
        backgroundColor: Colors.transparent,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(12.0),
              child: TextField(
                controller: _controller,
                decoration: InputDecoration(
                  hintText: 'Tambahkan item baru...',
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.add_circle,
                        color: Colors.indigoAccent),
                    onPressed: () {
                      if (_controller.text.isNotEmpty) {
                        _addToDo(_controller.text);
                      }
                    },
                  ),
                ),
              ),
            ),
            _buildCard('To-Do', toDoItems),
            _buildCard('Done', doneItems, isDone: true),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Default to To-Do List
        selectedItemColor: Colors.indigoAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 0) {
            Navigator.pushReplacementNamed(
              context,
              '/welcome',
              arguments: {
                'username': widget.username
              }, // Use widget.username here
            );
          } else if (index == 1) {
            Navigator.pushReplacementNamed(
              context,
              '/todo',
              arguments: {
                'username': widget.username
              }, // Use widget.username here
            );
          } else if (index == 2) {
            _showLogoutDialog(context);
          }
        },
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.checklist),
            label: 'To-Do List',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.logout),
            label: 'Logout',
          ),
        ],
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Konfirmasi Logout'),
          content: const Text('Apakah anda ingin Log Out?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Batal'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/login');
              },
              child: const Text('Log Out'),
            ),
          ],
        );
      },
    );
  }

  Widget _buildCard(String title, List<ToDoItem> items, {bool isDone = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 3,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Divider(),
            ...items.map((item) => ListTile(
                  leading: Checkbox(
                    value: item.isDone,
                    activeColor: Colors.indigoAccent,
                    onChanged: (value) => _toggleDone(_toDoList.indexOf(item)),
                  ),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontSize: 16,
                      decoration:
                          item.isDone ? TextDecoration.lineThrough : null,
                    ),
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.redAccent),
                    onPressed: () => _deleteToDo(_toDoList.indexOf(item)),
                  ),
                )),
          ],
        ),
      ),
    );
  }
}

class ToDoItem {
  String title;
  bool isDone;

  ToDoItem({required this.title, this.isDone = false});

  Map<String, dynamic> toMap() {
    return {'title': title, 'isDone': isDone};
  }

  factory ToDoItem.fromMap(Map<String, dynamic> map) {
    return ToDoItem(
      title: map['title'],
      isDone: map['isDone'],
    );
  }
}
