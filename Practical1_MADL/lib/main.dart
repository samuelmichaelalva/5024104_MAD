import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool _isDarkMode = false;

  void _toggleTheme() {
    setState(() {
      _isDarkMode = !_isDarkMode;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Interactive Dashboard',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.deepPurple,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: InteractiveCounterPage(
        isDarkMode: _isDarkMode,
        onToggleTheme: _toggleTheme,
      ),
    );
  }
}

class InteractiveCounterPage extends StatefulWidget {
  final bool isDarkMode;
  final VoidCallback onToggleTheme;

  const InteractiveCounterPage({
    super.key,
    required this.isDarkMode,
    required this.onToggleTheme,
  });

  @override
  State<InteractiveCounterPage> createState() => _InteractiveCounterPageState();
}

class _InteractiveCounterPageState extends State<InteractiveCounterPage> {
  int _counter = 0;
  int _step = 1;
  final int _maxLimit = 100;
  final int _minLimit = -100;
  final List<String> _history = [];

  void _updateCounter(int change, String action) {
    final newValue = _counter + change;
    if (newValue > _maxLimit || newValue < _minLimit) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Limit reached! Value must stay between $_minLimit and $_maxLimit.',
          ),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
      return;
    }
    setState(() {
      _counter = newValue;
      _history.insert(0, '$action by $change → Current: $_counter');
    });
  }

  void _resetCounter() {
    setState(() {
      _counter = 0;
      _step = 1;
      _history.insert(0, 'Reset Counter → Current: 0');
    });
  }

  void _clearHistory() {
    setState(() {
      _history.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Advanced Interactive Counter'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(widget.isDarkMode ? Icons.light_mode : Icons.dark_mode),
            tooltip: 'Toggle Theme',
            onPressed: widget.onToggleTheme,
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display Card
            Card(
              elevation: 6,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 24,
                  horizontal: 20,
                ),
                child: Column(
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, animation) =>
                          ScaleTransition(scale: animation, child: child),
                      child: Icon(
                        _counter == 0
                            ? Icons.exposure_zero
                            : _counter > 0
                            ? Icons.trending_up
                            : Icons.trending_down,
                        key: ValueKey<int>(
                          _counter > 0 ? 1 : (_counter < 0 ? -1 : 0),
                        ),
                        size: 56,
                        color: _counter < 0
                            ? Colors.redAccent
                            : _counter > 0
                            ? Colors.green
                            : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '$_counter',
                      style: theme.textTheme.displayLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: _counter < 0
                            ? Colors.redAccent
                            : _counter > 0
                            ? Colors.green
                            : theme.colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Range Limit: [$_minLimit to $_maxLimit]',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 20),
                    // Step Size Selector
                    const Text(
                      'Select Step Size:',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    SegmentedButton<int>(
                      segments: const [
                        ButtonSegment(value: 1, label: Text('+/- 1')),
                        ButtonSegment(value: 5, label: Text('+/- 5')),
                        ButtonSegment(value: 10, label: Text('+/- 10')),
                      ],
                      selected: {_step},
                      onSelectionChanged: (Set<int> selected) {
                        setState(() {
                          _step = selected.first;
                        });
                      },
                    ),
                    const SizedBox(height: 24),
                    // Action Controls
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        FloatingActionButton.extended(
                          heroTag: 'dec',
                          onPressed: () => _updateCounter(-_step, 'Decremented'),
                          backgroundColor: Colors.redAccent.shade100,
                          icon: const Icon(Icons.remove),
                          label: Text('-$_step'),
                        ),
                        IconButton.filledTonal(
                          onPressed: _resetCounter,
                          tooltip: 'Reset',
                          icon: const Icon(Icons.refresh),
                        ),
                        FloatingActionButton.extended(
                          heroTag: 'inc',
                          onPressed: () => _updateCounter(_step, 'Incremented'),
                          backgroundColor: Colors.greenAccent.shade100,
                          icon: const Icon(Icons.add),
                          label: Text('+$_step'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            // History Log Section
            Card(
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Row(
                          children: [
                            Icon(Icons.history, size: 20),
                            SizedBox(width: 8),
                            Text(
                              'Activity Log',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                        if (_history.isNotEmpty)
                          TextButton(
                            onPressed: _clearHistory,
                            child: const Text('Clear'),
                          ),
                      ],
                    ),
                    const Divider(),
                    _history.isEmpty
                        ? const Padding(
                            padding: EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                'No activity recorded yet.',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: _history.length > 5 ? 5 : _history.length,
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 4.0,
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.circle,
                                      size: 8,
                                      color: Colors.deepPurple,
                                    ),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(
                                        _history[index],
                                        style: const TextStyle(fontSize: 13),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
