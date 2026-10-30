import 'package:flutter/material.dart';

void main() => runApp(const ZenithApp());

class ZenithApp extends StatefulWidget {
  const ZenithApp({super.key});
  @override
  State<ZenithApp> createState() => _ZenithAppState();
}

class _ZenithAppState extends State<ZenithApp> {
  bool _isDark = true;
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Zenith Spaces',
      themeMode: _isDark ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(useMaterial3: true, brightness: Brightness.light, colorSchemeSeed: const Color(0xFF6366F1), scaffoldBackgroundColor: const Color(0xFFF5F3FF)),
      darkTheme: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: const Color(0xFF8B5CF6), scaffoldBackgroundColor: const Color(0xFF080B18)),
      home: ZenithHomePage(isDark: _isDark, onToggleTheme: () => setState(() => _isDark = !_isDark)),
    );
  }
}

class ZenithHomePage extends StatefulWidget {
  final bool isDark;
  final VoidCallback onToggleTheme;
  const ZenithHomePage({super.key, required this.isDark, required this.onToggleTheme});
  @override
  State<ZenithHomePage> createState() => _ZenithHomePageState();
}

class _ZenithHomePageState extends State<ZenithHomePage> {
  int _selectedCat = 0;
  bool _isSaved = false;
  final _cats = ['All Hubs', 'Private Pods', 'Co-Work Desks', 'Boardrooms', 'Skyline Lounges'];

  final _spaces = [
    {'title': 'Apex SkyLounge', 'loc': 'Downtown • Floor 42', 'price': r'$45/h', 'icon': Icons.apartment_rounded, 'color': const Color(0xFF8B5CF6), 'cap': '18'},
    {'title': 'Quiet Focus Pod', 'loc': 'Silicon Quarter', 'price': r'$18/h', 'icon': Icons.sensor_door_rounded, 'color': const Color(0xFF06B6D4), 'cap': '2'},
    {'title': 'Nexus Boardroom', 'loc': 'Tech Boulevard', 'price': r'$65/h', 'icon': Icons.meeting_room_rounded, 'color': const Color(0xFF10B981), 'cap': '14'},
    {'title': 'CyberDesk Co-Work', 'loc': 'Level 3 Hub', 'price': r'$12/h', 'icon': Icons.laptop_mac_rounded, 'color': const Color(0xFFF59E0B), 'cap': '30'},
  ];

  final _bookings = [
    {'title': 'Apex SkyLounge', 'time': 'Today • 2:00 PM - 5:00 PM', 'status': 'CONFIRMED', 'color': Colors.greenAccent},
    {'title': 'Quiet Focus Pod', 'time': 'Tomorrow • 10:00 AM - 1:00 PM', 'status': 'UPCOMING', 'color': Colors.cyanAccent},
  ];

  @override
  Widget build(BuildContext context) {
    final isWide = MediaQuery.of(context).size.width >= 700;
    return Scaffold(
      appBar: AppBar(
        elevation: 0, backgroundColor: Colors.transparent,
        title: Row(children: [
          Container(padding: const EdgeInsets.all(9), decoration: BoxDecoration(gradient: const LinearGradient(colors: [Color(0xFF8B5CF6), Color(0xFF06B6D4)]), borderRadius: BorderRadius.circular(12), boxShadow: [BoxShadow(color: const Color(0xFF8B5CF6).withOpacity(0.5), blurRadius: 12)]), child: const Icon(Icons.hub_rounded, color: Colors.white, size: 19)),
          const SizedBox(width: 10),
          const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [Text('ZENITH', style: TextStyle(fontWeight: FontWeight.w900, fontSize: 17, letterSpacing: 1.5)), Text('SPACES', style: TextStyle(fontSize: 9, letterSpacing: 3, color: Colors.grey))]),
        ]),
        actions: [
          Container(margin: const EdgeInsets.only(right: 8), decoration: BoxDecoration(color: widget.isDark ? Colors.white.withOpacity(0.06) : Colors.black.withOpacity(0.05), borderRadius: BorderRadius.circular(14)), child: IconButton(icon: Icon(widget.isDark ? Icons.light_mode_rounded : Icons.dark_mode_rounded), onPressed: widget.onToggleTheme)),
        ],
      ),
      body: Stack(children: [
        Positioned(top: -100, right: -80, child: _glowCircle(250, const Color(0xFF8B5CF6))),
        Positioned(top: 350, left: -130, child: _glowCircle(300, const Color(0xFF06B6D4))),
        Positioned(bottom: -120, right: 30, child: _glowCircle(260, const Color(0xFFEC4899))),
        SafeArea(
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: isWide ? 32 : 16, vertical: 12),
            child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              _buildHero(), const SizedBox(height: 20),
              _buildSectionTitle('Your Space Dashboard', 'A quick look at your activity'),
              const SizedBox(height: 12), _buildMetrics(isWide), const SizedBox(height: 22),
              _buildCategories(), const SizedBox(height: 22),
              _buildSectionTitle('Discover Spaces', 'Find your perfect environment'),
              const SizedBox(height: 12), _buildGrid(isWide), const SizedBox(height: 22),
              _buildBookings(), const SizedBox(height: 20),
            ]),
          ),
        ),
      ]),
    );
  }

  Widget _glowCircle(double size, Color color) {
    return IgnorePointer(child: Container(width: size, height: size, decoration: BoxDecoration(shape: BoxShape.circle, gradient: RadialGradient(colors: [color.withOpacity(0.16), color.withOpacity(0.0)]))));
  }

  Widget _buildSectionTitle(String title, String subtitle) {
    return Row(children: [
      Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w800, letterSpacing: -0.3)),
        const SizedBox(height: 3), Text(subtitle, style: const TextStyle(color: Colors.grey, fontSize: 11)),
      ])),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: const Color(0xFF8B5CF6).withOpacity(0.12)),
        child: const Row(children: [Icon(Icons.auto_awesome, size: 12, color: Colors.purpleAccent), SizedBox(width: 4), Text('LIVE', style: TextStyle(fontSize: 9, fontWeight: FontWeight.bold, color: Colors.purpleAccent))]),
      ),
    ]);
  }

  Widget _buildHero() {
    return Stack(clipBehavior: Clip.none, children: [
      Container(
        width: double.infinity, padding: const EdgeInsets.all(22),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(28),
          gradient: const LinearGradient(colors: [Color(0xFF312E81), Color(0xFF7C3AED), Color(0xFF0891B2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
          boxShadow: [BoxShadow(color: const Color(0xFF7C3AED).withOpacity(0.35), blurRadius: 25, offset: const Offset(0, 10))],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(children: [
            Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: Colors.white.withOpacity(0.15), borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white24)), child: const Row(mainAxisSize: MainAxisSize.min, children: [Icon(Icons.star_rounded, color: Colors.amberAccent, size: 13), SizedBox(width: 4), Text('FEATURED HUB', style: TextStyle(color: Colors.white, fontSize: 9, fontWeight: FontWeight.bold, letterSpacing: 1))])),
            const Spacer(), const Icon(Icons.wifi_rounded, color: Colors.white70, size: 17),
          ]),
          const SizedBox(height: 20),
          const Text('Zenith SkyLounge', style: TextStyle(color: Colors.white, fontSize: 27, fontWeight: FontWeight.w900, letterSpacing: -0.7)),
          const SizedBox(height: 5), Text('360° Bay Skyline • Financial District', style: TextStyle(color: Colors.white70, fontSize: 12)),
          const SizedBox(height: 18),
          Row(children: [
            const Text(r'$45', style: TextStyle(color: Colors.white, fontSize: 26, fontWeight: FontWeight.w900)),
            const Text('/hour', style: TextStyle(color: Colors.white60, fontSize: 11)),
            const Spacer(),
            ElevatedButton.icon(style: ElevatedButton.styleFrom(backgroundColor: Colors.white, foregroundColor: const Color(0xFF6D28D9), elevation: 0, padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 12), shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14))), onPressed: () => _showBookModal('Zenith SkyLounge', r'$45/hr'), icon: const Icon(Icons.bolt_rounded, size: 16), label: const Text('RESERVE', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w900))),
          ]),
        ]),
      ),
      Positioned(
        top: 14, right: 14,
        child: Container(decoration: BoxDecoration(color: Colors.black.withOpacity(0.18), shape: BoxShape.circle), child: IconButton(icon: Icon(_isSaved ? Icons.bookmark_rounded : Icons.bookmark_outline_rounded, color: Colors.white), onPressed: () => setState(() => _isSaved = !_isSaved))),
      ),
    ]);
  }

  Widget _buildMetrics(bool isWide) {
    final items = [
      {'val': '3', 'lbl': 'Active Passes', 'icon': Icons.qr_code_2, 'col': const Color(0xFF8B5CF6)},
      {'val': '48.5', 'lbl': 'Hours Booked', 'icon': Icons.timer_outlined, 'col': const Color(0xFF0EA5E9)},
      {'val': '8', 'lbl': 'Saved Spaces', 'icon': Icons.bookmark_rounded, 'col': const Color(0xFFEC4899)},
      {'val': '1,450', 'lbl': 'Credits', 'icon': Icons.stars_rounded, 'col': const Color(0xFFF59E0B)},
    ];

    Widget card(Map<String, dynamic> m) {
      final Color color = m['col'] as Color;
      return Expanded(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 4), padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: widget.isDark ? Colors.white.withOpacity(0.045) : Colors.white.withOpacity(0.8), border: Border.all(color: color.withOpacity(0.18)), boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 15, offset: const Offset(0, 6))]),
          child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Container(width: 38, height: 38, decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.35), color.withOpacity(0.08)]), borderRadius: BorderRadius.circular(12)), child: Icon(m['icon'] as IconData, color: color, size: 19)),
            const SizedBox(height: 10), Text(m['val'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 19)),
            const SizedBox(height: 2), Text(m['lbl'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
          ]),
        ),
      );
    }

    return isWide ? Row(children: items.map(card).toList()) : Column(children: [Row(children: [card(items[0]), card(items[1])]), const SizedBox(height: 8), Row(children: [card(items[2]), card(items[3])])]);
  }

  Widget _buildCategories() {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(22), color: widget.isDark ? Colors.white.withOpacity(0.035) : Colors.white.withOpacity(0.75), border: Border.all(color: Colors.white.withOpacity(0.08))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Row(children: [Icon(Icons.tune_rounded, size: 17, color: Colors.purpleAccent), SizedBox(width: 7), Text('Explore Categories', style: TextStyle(fontWeight: FontWeight.w800, fontSize: 14))]),
        const SizedBox(height: 11),
        Wrap(spacing: 7, runSpacing: 7, children: List.generate(_cats.length, (i) => ChoiceChip(label: Text(_cats[i], style: TextStyle(fontSize: 10, fontWeight: _selectedCat == i ? FontWeight.bold : FontWeight.normal)), selected: _selectedCat == i, selectedColor: const Color(0xFF8B5CF6).withOpacity(0.25), side: BorderSide(color: _selectedCat == i ? const Color(0xFF8B5CF6) : Colors.grey.withOpacity(0.15)), onSelected: (_) => setState(() => _selectedCat = i)))),
      ]),
    );
  }

  Widget _buildGrid(bool isWide) {
    return GridView.builder(
      shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: isWide ? 2 : 1, crossAxisSpacing: 12, mainAxisSpacing: 12, childAspectRatio: isWide ? 2.25 : 2.5),
      itemCount: _spaces.length,
      itemBuilder: (ctx, i) {
        final s = _spaces[i];
        final Color color = s['color'] as Color;
        return Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(24),
            onTap: () => _showBookModal(s['title'] as String, s['price'] as String),
            child: Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(24), gradient: LinearGradient(colors: [color.withOpacity(widget.isDark ? 0.12 : 0.08), widget.isDark ? Colors.white.withOpacity(0.035) : Colors.white.withOpacity(0.8)], begin: Alignment.topLeft, end: Alignment.bottomRight), border: Border.all(color: color.withOpacity(0.22)), boxShadow: [BoxShadow(color: color.withOpacity(0.08), blurRadius: 18, offset: const Offset(0, 7))]),
              child: Row(children: [
                Container(width: 58, height: 58, decoration: BoxDecoration(gradient: LinearGradient(colors: [color, color.withOpacity(0.45)]), borderRadius: BorderRadius.circular(18), boxShadow: [BoxShadow(color: color.withOpacity(0.35), blurRadius: 12)]), child: Icon(s['icon'] as IconData, color: Colors.white, size: 27)),
                const SizedBox(width: 13),
                Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, mainAxisAlignment: MainAxisAlignment.center, children: [
                  Row(children: [
                    Expanded(child: Text(s['title'] as String, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 14), maxLines: 1, overflow: TextOverflow.ellipsis)),
                    Container(padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3), decoration: BoxDecoration(color: color.withOpacity(0.15), borderRadius: BorderRadius.circular(8)), child: Text('${s["cap"]} SEATS', style: TextStyle(color: color, fontSize: 7, fontWeight: FontWeight.w900))),
                  ]),
                  const SizedBox(height: 4), Text(s['loc'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
                  const SizedBox(height: 7),
                  Row(children: [
                    Text(s['price'] as String, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 12)),
                    const SizedBox(width: 7), const Text('•', style: TextStyle(color: Colors.grey)), const SizedBox(width: 7),
                    const Text('AVAILABLE', style: TextStyle(color: Colors.greenAccent, fontSize: 8, fontWeight: FontWeight.bold)),
                  ]),
                ])),
                const SizedBox(width: 5),
                Container(width: 30, height: 30, decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.arrow_forward_rounded, color: color, size: 16)),
              ]),
            ),
          ),
        );
      },
    );
  }

  Widget _buildBookings() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      _buildSectionTitle('Upcoming Bookings', 'Your reserved spaces'),
      const SizedBox(height: 12),
      ListView.builder(
        shrinkWrap: true, physics: const NeverScrollableScrollPhysics(),
        itemCount: _bookings.length,
        itemBuilder: (ctx, i) {
          final b = _bookings[i];
          final Color color = b['color'] as Color;
          return Container(
            margin: const EdgeInsets.only(bottom: 10), padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20), color: widget.isDark ? Colors.white.withOpacity(0.04) : Colors.white.withOpacity(0.85), border: Border.all(color: color.withOpacity(0.15))),
            child: Row(children: [
              Container(width: 45, height: 45, decoration: BoxDecoration(gradient: LinearGradient(colors: [color.withOpacity(0.25), color.withOpacity(0.05)]), borderRadius: BorderRadius.circular(14)), child: Icon(Icons.confirmation_number_rounded, color: color, size: 21)),
              const SizedBox(width: 12),
              Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Text(b['title'] as String, style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13)),
                const SizedBox(height: 3), Text(b['time'] as String, style: const TextStyle(color: Colors.grey, fontSize: 10)),
              ])),
              Container(padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5), decoration: BoxDecoration(color: color.withOpacity(0.12), borderRadius: BorderRadius.circular(20)), child: Text(b['status'] as String, style: TextStyle(color: color, fontWeight: FontWeight.w900, fontSize: 8))),
            ]),
          );
        },
      ),
    ]);
  }

  void _showBookModal(String title, String price) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('🚀 Reserved ' + title + ' • ' + price), behavior: SnackBarBehavior.floating, duration: const Duration(seconds: 2)));
  }
}
