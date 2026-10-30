import 'package:flutter/material.dart';

void main() => runApp(const ExpenseTrackerApp());

class ExpenseTrackerApp extends StatefulWidget {
  const ExpenseTrackerApp({super.key});

  @override
  State<ExpenseTrackerApp> createState() => _ExpenseTrackerAppState();
}

class _ExpenseTrackerAppState extends State<ExpenseTrackerApp>
    with SingleTickerProviderStateMixin {
  int page = 0;

  final title = TextEditingController();
  final money = TextEditingController();

  final List<List<Object>> expenses = [
    ['Groceries', 3200.0, Icons.shopping_basket_rounded, Colors.green],
    ['Movie Tickets', 1200.0, Icons.movie_creation_rounded, Colors.purple],
    ['Doctor Consultation', 1500.0, Icons.medical_services_rounded, Colors.orange],
    ['Electricity Bill', 2450.0, Icons.electrical_services_rounded, Colors.blue],
    ['Fuel', 1800.0, Icons.local_gas_station_rounded, Colors.deepOrange],
  ];

  late AnimationController a;

  @override
  void initState() {
    super.initState();
    a = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 6),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    a.dispose();
    title.dispose();
    money.dispose();
    super.dispose();
  }

  double get spent => expenses.fold(0, (sum, e) => sum + (e[1] as num));

  void add() {
    title.clear();
    money.clear();

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: EdgeInsets.fromLTRB(
          20,
          25,
          20,
          MediaQuery.of(context).viewInsets.bottom + 20,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Add Expense',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            TextField(
              controller: title,
              decoration: const InputDecoration(labelText: 'Expense name'),
            ),
            TextField(
              controller: money,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Amount'),
            ),
            const SizedBox(height: 15),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  final m = double.tryParse(money.text);
                  if (title.text.isEmpty || m == null) return;
                  setState(() => expenses.insert(0, [title.text, m, Icons.payments, Colors.deepPurple]));
                  Navigator.pop(context);
                },
                child: const Text('ADD EXPENSE'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void notifyUser() => showDialog(
        context: context,
        builder: (_) => AlertDialog(
          title: const Text('Notifications'),
          content: const Text(
            'You saved 18% more this month!\n\nShopping expenses are slightly higher this week.',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('OK'),
            ),
          ],
        ),
      );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xfff5f4fc),
      bottomNavigationBar: NavigationBar(
        selectedIndex: page,
        onDestinationSelected: (i) => setState(() => page = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.home), label: 'Home'),
          NavigationDestination(icon: Icon(Icons.bar_chart), label: 'Stats'),
          NavigationDestination(icon: Icon(Icons.wallet), label: 'Wallet'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
      floatingActionButton: page == 0
          ? FloatingActionButton.extended(
              onPressed: add,
              icon: const Icon(Icons.add),
              label: const Text('Expense'),
            )
          : null,
      body: AnimatedBuilder(
        animation: a,
        builder: (_, child) => Stack(
          children: [
            Positioned(
              top: -80 + a.value * 100,
              right: -70,
              child: circle(240),
            ),
            Positioned(
              left: -100,
              top: 300 - a.value * 80,
              child: circle(230),
            ),
            SafeArea(child: page == 0 ? home() : other()),
          ],
        ),
      ),
    );
  }

  Widget circle(double s) => Container(
        width: s,
        height: s,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.deepPurple.withOpacity(.08),
        ),
      );

  Widget home() => SingleChildScrollView(
        padding: const EdgeInsets.all(18),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const CircleAvatar(
                  radius: 26,
                  backgroundColor: Colors.deepPurple,
                  child: Icon(Icons.person, color: Colors.white),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Text(
                    'Good evening \nAbhishek Kulbainur',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
                IconButton(
                  onPressed: notifyUser,
                  icon: const Icon(Icons.notifications_none),
                ),
              ],
            ),
            const SizedBox(height: 20),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xff5146d8), Color(0xff967cff)],
                ),
                borderRadius: BorderRadius.circular(25),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Total Balance', style: TextStyle(color: Colors.white70)),
                  SizedBox(height: 8),
                  Text(
                    '₹62500',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '↗ +12.8%  vs last month',
                    style: TextStyle(color: Colors.white70),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 18),
            Row(
              children: [
                card('Income', '₹62,500', Icons.arrow_downward, Colors.green),
                const SizedBox(width: 10),
                card('Spent', '₹${spent.toStringAsFixed(0)}', Icons.arrow_upward, Colors.red),
              ],
            ),
            const SizedBox(height: 25),
            const Text(
              'Spending Overview',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Container(
              height: 220,
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(22),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [60, 110, 80, 145, 100, 175, 125]
                    .asMap()
                    .entries
                    .map(
                      (e) => Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 3),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              Flexible(
                                child: FractionallySizedBox(
                                  heightFactor: e.value / 175,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      color: Colors.deepPurple,
                                      borderRadius: BorderRadius.circular(7),
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                ['M', 'T', 'W', 'T', 'F', 'S', 'S'][e.key],
                                style: const TextStyle(fontSize: 10, color: Colors.grey),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 25),
            const Text(
              'Recent Transactions',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...expenses.take(4).map(
              (e) => ListTile(
                tileColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                leading: CircleAvatar(
                  backgroundColor: (e[3] as Color).withOpacity(.12),
                  child: Icon(e[2] as IconData, color: e[3] as Color),
                ),
                title: Text(e[0] as String),
                subtitle: const Text('Today • Recent transaction'),
                trailing: Text(
                  '- ₹${(e[1] as num).toStringAsFixed(0)}',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Image.network(
                'https://images.unsplash.com/photo-1554224155-6726b3ff858f?auto=format&fit=crop&w=900&q=80',
                height: 150,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => Container(
                  height: 150,
                  color: Colors.deepPurple.shade100,
                  child: const Icon(Icons.savings, size: 60),
                ),
              ),
            ),
          ],
        ),
      );

  Widget card(String t, String v, IconData i, Color c) => Expanded(
        child: Container(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(i, color: c),
              const SizedBox(height: 5),
              Text(t, style: const TextStyle(color: Colors.grey)),
              Text(
                v,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
              ),
            ],
          ),
        ),
      );

  Widget other() => Center(
        child: Text(
          ['Home', 'Analytics', 'Wallet', 'Profile'][page],
          style: const TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
      );
}
