import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() => runApp(
  ChangeNotifierProvider(
    create: (_) => UserData(),
    child: const MyApp(),
  ),
);

class UserData extends ChangeNotifier {
  String name = '', email = '', role = 'Operator';
  bool submitted = false;
  final roles = ['Operator', 'Commander', 'Scientist', 'Engineer'];

  void submit() {
    submitted = true;
    notifyListeners();
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.deepPurple,
      ),
      home: const QuantumPage(),
    );
  }
}

class QuantumPage extends StatelessWidget {
  const QuantumPage({super.key});

  @override
  Widget build(BuildContext context) {
    final data = context.watch<UserData>();
    final formKey = GlobalKey<FormState>();

    InputDecoration field(String label, IconData icon) => InputDecoration(
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.purpleAccent),
      filled: true,
      fillColor: Colors.white.withOpacity(.07),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xff080414),
      body: Container(
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            colors: [
              Color(0xff40106b),
              Color(0xff11051d),
              Color(0xff030208),
            ],
            radius: 1.3,
          ),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(22),
            child: Column(
              children: [
                const SizedBox(height: 25),
                const Icon(
                  Icons.hub_rounded,
                  size: 65,
                  color: Colors.purpleAccent,
                ),
                const Text(
                  'QUANTUM',
                  style: TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 7,
                  ),
                ),
                const Text(
                  'DATA PORTAL',
                  style: TextStyle(
                    color: Colors.grey,
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 30),
                Card(
                  color: Colors.white.withOpacity(.06),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(22),
                    child: Form(
                      key: formKey,
                      child: Column(
                        children: [
                          const Text(
                            'IDENTITY CONFIGURATION',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 2,
                            ),
                          ),
                          const SizedBox(height: 22),
                          TextFormField(
                            decoration: field(
                              'Codename',
                              Icons.rocket_launch,
                            ),
                            onChanged: (v) => data.name = v,
                            validator: (v) =>
                                v!.isEmpty ? 'Enter codename' : null,
                          ),
                          const SizedBox(height: 18),
                          TextFormField(
                            decoration: field(
                              'Email',
                              Icons.alternate_email,
                            ),
                            keyboardType: TextInputType.emailAddress,
                            onChanged: (v) => data.email = v,
                            validator: (v) =>
                                !v!.contains('@') ? 'Enter valid email' : null,
                          ),
                          const SizedBox(height: 18),
                          DropdownButtonFormField<String>(
                            value: data.role,
                            decoration: field(
                              'Clearance Level',
                              Icons.security,
                            ),
                            items: data.roles
                                .map(
                                  (r) => DropdownMenuItem(
                                    value: r,
                                    child: Text(r),
                                  ),
                                )
                                .toList(),
                            onChanged: (v) {
                              if (v != null) {
                                data.role = v;
                                data.notifyListeners();
                              }
                            },
                          ),
                          const SizedBox(height: 25),
                          SizedBox(
                            width: double.infinity,
                            height: 55,
                            child: ElevatedButton.icon(
                              onPressed: () {
                                if (formKey.currentState!.validate()) {
                                  data.submit();
                                }
                              },
                              icon: const Icon(Icons.bolt),
                              label: const Text('ACTIVATE SEQUENCE'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.deepPurple,
                                foregroundColor: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 25),
                if (data.submitted)
                  Card(
                    color: Colors.green.withOpacity(.08),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(25),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(22),
                      child: Column(
                        children: [
                          const Icon(
                            Icons.check_circle,
                            color: Colors.greenAccent,
                            size: 60,
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'TRANSMISSION SUCCESSFUL',
                            style: TextStyle(
                              color: Colors.greenAccent,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 15),
                          Text('Codename: ${data.name}'),
                          Text('Email: ${data.email}'),
                          Text('Clearance: ${data.role}'),
                        ],
                      ),
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
