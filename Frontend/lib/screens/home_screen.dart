import 'package:flutter/material.dart';
import 'map_screen.dart';
import 'logs_screen.dart';
import 'video_screen.dart';
import 'package:intl/intl.dart';
import 'package:intl/intl.dart';
import 'dart:async';
import '../services/api.dart';
import '../screens/auth_screen.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
// ─────────────────────────────────────────────
//  Breakpoint helpers
// ─────────────────────────────────────────────
class _BP {
  static bool isMobile(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width < 600;
  static bool isTablet(BuildContext ctx) {
    final w = MediaQuery.of(ctx).size.width;
    return w >= 600 && w < 1024;
  }
  static bool isDesktop(BuildContext ctx) =>
      MediaQuery.of(ctx).size.width >= 1024;
}

// ─────────────────────────────────────────────
//  Reusable widgets
// ─────────────────────────────────────────────

/// A card container used throughout the dashboard
class SectionContainer extends StatelessWidget {
  const SectionContainer({
    super.key,
    required this.title,
    required this.child,
    this.padding = const EdgeInsets.all(20),
  });

  final String title;
  final Widget child;
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: padding,
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17,
            ),
          ),
          const SizedBox(height: 18),
          child,
        ],
      ),
    );
  }
}

/// Stat card used in the 4-up grid
class DashboardCard extends StatelessWidget {
  const DashboardCard({
    super.key,
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final Color color;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF141414),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: const TextStyle(color: Colors.white54, fontSize: 12),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  value,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: TextStyle(
                      color: color,
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// A single nav item for the sidebar
class SidebarItem extends StatelessWidget {
  const SidebarItem({
    super.key,
    required this.icon,
    required this.label,
    required this.isSelected,
    required this.isExpanded,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isSelected;
  final bool isExpanded;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        margin: EdgeInsets.symmetric(
          horizontal: isExpanded ? 10 : 4,
          vertical: 4,
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isExpanded ? 14 : 0,
          vertical: 12,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? const Color(0xFF1E3A5F)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
        ),
        child: SizedBox(
          width: double.infinity,
          child: Row(
            mainAxisAlignment: isExpanded
                ? MainAxisAlignment.start
                : MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: isExpanded ? 22 : 20,
                color: isSelected
                    ? Colors.blueAccent
                    : Colors.white70,
              ),

              if (isExpanded && MediaQuery.of(context).size.width > 0) ...[
                const SizedBox(width: 12),

                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    softWrap: false,
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white
                          : Colors.white70,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.normal,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HomeScreen
// ─────────────────────────────────────────────
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _index = 0;
  bool _sidebarExpanded = true;
  double currentSpeed = 0.0;

  double? latitude;
  double? longitude;

  bool cameraConnected = false;
  bool engineRunning = true;

  List<String> dangerLogs = [];
  int dangerEvents = 0;
  bool lastCollisionState = false;
  Timer? _liveTimer;
  DateTime? systemStartedTime;
  DateTime? gpsConnectedTime;
  DateTime? cameraReadyTime;
  bool get gpsConnected =>
      latitude != null &&
          longitude != null;

  static const double _expandedWidth = 220;
  static const double _collapsedWidth = 85;

  List<Widget> get _screens => [
    DashboardScreen(
      currentSpeed: currentSpeed,
      latitude: latitude,
      longitude: longitude,
      cameraConnected: cameraConnected,
      engineRunning: engineRunning,
      dangerLogs: dangerLogs,
      dangerEvents: dangerEvents,
      systemStartedTime: systemStartedTime,
      gpsConnectedTime: gpsConnectedTime,
      cameraReadyTime: cameraReadyTime,
    ),
    const MapScreen(),
    const LogsScreen(),
    const VideoScreen(),
  ];

  final _navItems = const [
    (Icons.home, "Home"),
    (Icons.map_outlined, "Map"),
    (Icons.list_alt, "Logs"),
    (Icons.videocam_outlined, "Camera"),
  ];

  void _setIndex(int i) => setState(() => _index = i);
  @override
  void initState() {
    super.initState();

    _loadLiveData();
    systemStartedTime = DateTime.now();

    _liveTimer = Timer.periodic(
      const Duration(seconds: 1),
          (_) => _loadLiveData(),
    );
  }

  Future<void> _loadLiveData() async {
    try {
      final live = await ApiService.getLive();

      if (!mounted) return;

      final gps = live["gps"] ?? {};

      setState(() {
        latitude = gps["lat"];
        longitude = gps["lon"];

        if (latitude != null &&
            longitude != null &&
            gpsConnectedTime == null) {
          gpsConnectedTime = DateTime.now();
        }

        cameraConnected = live["online"] ?? false;

        if (cameraConnected &&
            cameraReadyTime == null) {
          cameraReadyTime = DateTime.now();
        }

        final objects = live["objects"] as List? ?? [];

        dangerLogs = objects
            .map((e) => e["label"]?.toString() ?? "Unknown")
            .toList();

        // ===== Collision Counter =====
        final bool collision = live["collision"] ?? false;

        if (collision && !lastCollisionState) {
          dangerEvents++;
        }

        lastCollisionState = collision;
      });
    } catch (e) {
      debugPrint("LIVE UPDATE ERROR: $e");
    }
  }
  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (_) => const AuthScreen(),
      ),
          (route) => false,
    );
  }

  @override
  void dispose() {
    _liveTimer?.cancel();
    super.dispose();
  }

  // ── Sidebar (desktop / tablet) ──────────────
  Widget _buildSidebar() {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 260),
      curve: Curves.easeInOut,
      width: _sidebarExpanded ? _expandedWidth : _collapsedWidth,
      clipBehavior: Clip.hardEdge,
      decoration: const BoxDecoration(
        color: Color(0xFF0D0D0D),
      ),
      child: SafeArea(
        child: Column(
          children: [
            // Toggle button
            Align(
              alignment: _sidebarExpanded
                  ? Alignment.centerRight
                  : Alignment.center,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 16, 8, 8),
                child: IconButton(
                  icon: Icon(
                    _sidebarExpanded
                        ? Icons.chevron_left
                        : Icons.chevron_right,
                    color: Colors.white54,
                    size: 22,
                  ),
                  onPressed: () {
                    setState(() {
                      _sidebarExpanded = !_sidebarExpanded;
                    });
                  },
                ),
              ),
            ),

            // Navigation items
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    for (int i = 0; i < _navItems.length; i++)
                      SidebarItem(
                        icon: _navItems[i].$1,
                        label: _navItems[i].$2,
                        isSelected: _index == i,
                        isExpanded: _sidebarExpanded,
                        onTap: () => _setIndex(i),
                      ),

                    SidebarItem(
                      icon: Icons.logout,
                      label: "Logout",
                      isSelected: false,
                      isExpanded: _sidebarExpanded,
                      onTap: _logout,
                    ),
                  ],
                ),
              ),
            ),

            // Emergency section
            AnimatedSize(
              duration: const Duration(milliseconds: 250),
              curve: Curves.easeInOut,
              child: _sidebarExpanded
                  ? _buildEmergencyExpanded()
                  : _buildEmergencyCollapsed(),
            ),

            const SizedBox(height: 12),
          ],
        ),
      ),
    );
  }
  Widget _buildEmergencyExpanded() {
    return Container(
      key: const ValueKey('expanded'),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF1A1A1A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Icon(
                Icons.phone,
                color: Colors.red[400],
                size: 18,
              ),
              const SizedBox(width: 8),

              Expanded(
                child: Text(
                  "Emergency",
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: Colors.red[400],
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          _emergencyRow(
            Icons.local_police_outlined,
            "Police",
            "112",
          ),

          const SizedBox(height: 10),

          _emergencyRow(
            Icons.medical_services_outlined,
            "Ambulance",
            "108",
          ),

          const SizedBox(height: 10),

          _emergencyRow(
            Icons.local_fire_department_outlined,
            "Fire Service",
            "101",
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyCollapsed() {
    return Padding(
      key: const ValueKey('collapsed'),
      padding: const EdgeInsets.only(bottom: 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.local_police_outlined, color: Colors.white38, size: 20),
          const SizedBox(height: 8),
          Icon(Icons.medical_services_outlined,
              color: Colors.white38, size: 20),
          const SizedBox(height: 8),
          Icon(Icons.local_fire_department_outlined,
              color: Colors.white38, size: 20),
        ],
      ),
    );
  }

  Widget _emergencyRow(IconData icon, String label, String number) {
    return Row(
      children: [
        Icon(icon, color: Colors.white54, size: 17),
        const SizedBox(width: 8),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(label,
                  style:
                  const TextStyle(color: Colors.white54, fontSize: 11)),
              Text(number,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13)),
            ],
          ),
        ),
      ],
    );
  }

  // ── Drawer (mobile) ─────────────────────────
  Widget _buildDrawer() {
    return Drawer(
      backgroundColor: const Color(0xFF0D0D0D),
      child: SafeArea(
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.fromLTRB(16, 20, 16, 12),
              child: Text(
                "Accident Detection",
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              ),
            ),
            const Divider(color: Colors.white12, height: 1),
            const SizedBox(height: 8),
            for (int i = 0; i < _navItems.length; i++)
              SidebarItem(
                icon: _navItems[i].$1,
                label: _navItems[i].$2,
                isSelected: _index == i,
                isExpanded: true,
                onTap: () {
                  _setIndex(i);
                  Navigator.pop(context);
                },
              ),
            const Spacer(),
            _buildEmergencyExpanded(),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = _BP.isMobile(context);

    if (isMobile) {
      return Scaffold(
        backgroundColor: const Color(0xFF0A0A0A),
        drawer: _buildDrawer(),
        appBar: AppBar(
          backgroundColor: const Color(0xFF0D0D0D),
          foregroundColor: Colors.white,
          elevation: 0,
          title: const Text(
            "Accident Detection",
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
          ),
        ),
        body: _screens[_index],
      );
    }

    // Tablet / Desktop: sidebar + content
    return Scaffold(
      body: Row(
        children: [
          _buildSidebar(),
          Expanded(child: _screens[_index]),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  DashboardScreen
// ─────────────────────────────────────────────
class DashboardScreen extends StatelessWidget {
  final double currentSpeed;
  final double? latitude;
  final double? longitude;
  final bool cameraConnected;
  final bool engineRunning;

  final List<String> dangerLogs;
  final int dangerEvents; // <-- ADD THIS

  final DateTime? systemStartedTime;
  final DateTime? gpsConnectedTime;
  final DateTime? cameraReadyTime;

  const DashboardScreen({
    super.key,
    required this.currentSpeed,
    required this.latitude,
    required this.longitude,
    required this.cameraConnected,
    required this.engineRunning,
    required this.dangerLogs,
    required this.dangerEvents, // <-- ADD THIS
    required this.systemStartedTime,
    required this.gpsConnectedTime,
    required this.cameraReadyTime,
  });
  bool get gpsConnected =>
      latitude != null &&
          longitude != null;

  String _formatTime(DateTime time) {
    return DateFormat('hh:mm:ss a').format(time);
  }

  // ── Helper widgets ───────────────────────────

  Widget _statusRow(String title, String status, Color color) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(title,
                style:
                const TextStyle(color: Colors.white70, fontSize: 13)),
          ),
          Text(
            status,
            style: TextStyle(
                color: color, fontWeight: FontWeight.w600, fontSize: 13),
          ),
        ],
      ),
    );
  }

  Widget _activityTile(
      IconData icon, Color color, String title, String time) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 11),
      child: Row(
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(width: 14),
          Expanded(
            child: Text(title,
                style: const TextStyle(color: Colors.white, fontSize: 13)),
          ),
          Text(time,
              style:
              const TextStyle(color: Colors.white38, fontSize: 12)),
        ],
      ),
    );
  }

  Widget _quickStatItem({
    required IconData icon,
    required Color color,
    required String label,
    required String value,
    String? sublabel,
  }) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, color: color, size: 28),
        const SizedBox(height: 6),
        Text(label,
            style:
            const TextStyle(color: Colors.white54, fontSize: 12)),
        const SizedBox(height: 3),
        Text(
          value,
          style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 17),
        ),
        if (sublabel != null) ...[
          const SizedBox(height: 2),
          Text(sublabel,
              style: const TextStyle(
                  color: Colors.white38, fontSize: 11)),
        ],
      ],
    );
  }

  // ── Stat cards grid (responsive) ─────────────
  Widget _buildStatCards(BuildContext context) {
    final cards = [
      DashboardCard(
        icon: Icons.speed,
        title: "Speed",
        value: "${currentSpeed.toStringAsFixed(1)} km/h",
        color: Colors.cyan,
        subtitle: gpsConnected
            ? "Live GPS"
            : "Waiting for GPS",
      ),

      DashboardCard(
        icon: Icons.gps_fixed,
        title: "GPS",
        value: gpsConnected
            ? "Connected"
            : "Offline",
        color: gpsConnected
            ? Colors.green
            : Colors.red,
        subtitle: gpsConnected
            ? "${latitude!.toStringAsFixed(5)}, ${longitude!.toStringAsFixed(5)}"
            : "No location",
      ),

      DashboardCard(
        icon: Icons.videocam,
        title: "Camera",
        value: cameraConnected
            ? "Online"
            : "Offline",
        color: cameraConnected
            ? Colors.purple
            : Colors.red,
        subtitle: cameraConnected
            ? "Feed active"
            : "No signal",
      ),

      DashboardCard(
        icon: Icons.warning_amber_rounded,
        title: "Alerts",
        value: (
            (!gpsConnected ? 1 : 0) +
                (!cameraConnected ? 1 : 0) +
                (!engineRunning ? 1 : 0)
        ).toString(),
        color: (
            (!gpsConnected ? 1 : 0) +
                (!cameraConnected ? 1 : 0) +
                (!engineRunning ? 1 : 0)
        ) > 0
            ? Colors.red
            : Colors.green,
        subtitle: (
            (!gpsConnected ? 1 : 0) +
                (!cameraConnected ? 1 : 0) +
                (!engineRunning ? 1 : 0)
        ) == 0
            ? "System healthy"
            : "System issue detected",
      ),
    ];

    return LayoutBuilder(builder: (context, constraints) {
      final width = constraints.maxWidth;
      int columns;
      if (width >= 900) {
        columns = 4;
      } else if (width >= 540) {
        columns = 2;
      } else {
        columns = 1;
      }

      return GridView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: columns,
          crossAxisSpacing: 14,
          mainAxisSpacing: 14,
          childAspectRatio: 2.0,
        ),
        itemCount: cards.length,
        itemBuilder: (_, i) => cards[i],
      );
    });
  }

  // ── Vehicle Overview + Quick Stats ────────────
  Widget _buildOverviewSection(BuildContext context) {
    final isMobile = _BP.isMobile(context);
    final isTablet = _BP.isTablet(context);

    final vehicleOverview = SectionContainer(
      title: "Vehicle Overview",
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Vehicle status icon
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.12),
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: Colors.blue.withOpacity(0.25),
                    width: 2,
                  ),
                ),
                child: const Icon(
                  Icons.directions_car,
                  color: Colors.blue,
                  size: 38,
                ),
              ),
              const SizedBox(height: 10),

              const Text(
                "Vehicle",
                style: TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),

              const Text(
                "Monitoring",
                style: TextStyle(
                  color: Colors.blue,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),

          const SizedBox(width: 28),

          Expanded(
            child: Column(
              children: [
                _statusRow(
                  "GPS Location",
                  gpsConnected ? "Connected" : "Offline",
                  gpsConnected ? Colors.green : Colors.red,
                ),

                _statusRow(
                  "Camera Feed",
                  cameraConnected ? "Online" : "Offline",
                  cameraConnected ? Colors.green : Colors.red,
                ),

                _statusRow(
                  "Detection Engine",
                  "Running",
                  Colors.blue,
                ),

                _statusRow(
                  "Current Speed",
                  "${currentSpeed.toStringAsFixed(1)} km/h",
                  Colors.orange,
                ),
              ],
            ),
          ),
        ],
      ),
    );

    final quickStats = SectionContainer(
      title: "Trip Statistics",
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            child: _quickStatItem(
              icon: Icons.speed,
              color: Colors.orange,
              label: "Average Speed",
              value: "${currentSpeed.toStringAsFixed(1)}",
              sublabel: "km/h",
            ),
          ),

          Container(
            width: 1,
            height: 70,
            color: Colors.white10,
          ),

          Expanded(
            child: _quickStatItem(
              icon: Icons.warning_amber_rounded,
              color: Colors.red,
              label: "Danger Events",
              value: dangerEvents.toString(),
              sublabel: "Today",
            ),
          ),
        ],
      ),
    );

    if (isMobile) {
      return Column(
        children: [
          vehicleOverview,
          const SizedBox(height: 16),
          quickStats,
        ],
      );
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          flex: isTablet ? 6 : 6,
          child: vehicleOverview,
        ),
        const SizedBox(width: 16),
        Expanded(
          flex: isTablet ? 4 : 4,
          child: quickStats,
        ),
      ],
    );
  }

  // ── Recent Activity ──────────────────────────
  Widget _buildRecentActivity() {
    final now = DateTime.now();

    return SectionContainer(
      title: "Recent Activity",
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _activityTile(
            Icons.check_circle,
            Colors.green,
            "System Started",
            systemStartedTime == null
                ? "--"
                : _formatTime(systemStartedTime!),
          ),
          const Divider(color: Colors.white10, height: 1),

          _activityTile(
            Icons.gps_fixed,
            Colors.blue,
            "GPS Connected",
            gpsConnectedTime == null
                ? "--"
                : _formatTime(gpsConnectedTime!),
          ),
          const Divider(color: Colors.white10, height: 1),

          _activityTile(
            Icons.videocam,
            Colors.purple,
            "Camera Ready",
            cameraReadyTime == null
                ? "--"
                : _formatTime(cameraReadyTime!),
          ),
        ],
      ),
    );
  }

  // ── Main build ───────────────────────────────
  @override
  Widget build(BuildContext context) {
    final isMobile = _BP.isMobile(context);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.all(isMobile ? 16 : 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              _buildHeader(context),
              const SizedBox(height: 20),

              // Monitoring Active Banner
              _buildMonitoringBanner(context),
              const SizedBox(height: 20),

              // Stat cards
              _buildStatCards(context),
              const SizedBox(height: 20),

              // System Overview + Quick Stats
              _buildOverviewSection(context),
              const SizedBox(height: 20),

              // Recent Activity
              _buildRecentActivity(),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
  Widget _buildHeader(BuildContext context) {
    final isMobile = _BP.isMobile(context);
    final now = DateTime.now();
    final bool isDayTime = now.hour >= 6 && now.hour < 18;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Accident Detection",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: isMobile ? 20 : 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 3),
              const Row(
                children: [
                  Text(
                    "Welcome back, User",
                    style: TextStyle(
                      color: Colors.white60,
                      fontSize: 13,
                    ),
                  ),
                  SizedBox(width: 5),
                  Text(
                    "👋",
                    style: TextStyle(fontSize: 13),
                  ),
                ],
              ),
            ],
          ),
        ),

        if (!isMobile) ...[
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                DateFormat('hh:mm a').format(now),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                DateFormat('dd MMM yyyy').format(now),
                style: const TextStyle(
                  color: Colors.white54,
                  fontSize: 12,
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
        ],

        Container(
          padding: const EdgeInsets.all(9),
          decoration: BoxDecoration(
            color: const Color(0xFF1A1A1A),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.white10),
          ),
          child: Icon(
            isDayTime
                ? Icons.wb_sunny_rounded
                : Icons.dark_mode_outlined,
            color: isDayTime
                ? Colors.amber
                : Colors.white70,
            size: 20,
          ),
        ),
      ],
    );
  }
  Widget _buildMonitoringBanner(BuildContext context) {
    final isMobile = _BP.isMobile(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: const LinearGradient(
          colors: [Color(0xFF0D4D2A), Color(0xFF1A6B3A)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.15),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.shield_rounded,
                color: Colors.white, size: 26),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Monitoring Active",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 3),
                Text(
                  "System is running normally",
                  style: TextStyle(
                      color: Colors.white.withOpacity(0.7), fontSize: 13),
                ),
              ],
            ),
          ),
          // Heartbeat – only on wider screens to avoid overflow
          if (!isMobile)
            SizedBox(
              width: 160,
              height: 44,
              child: CustomPaint(painter: HeartbeatPainter()),
            ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
//  HeartbeatPainter (unchanged logic)
// ─────────────────────────────────────────────
class HeartbeatPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.green.withOpacity(0.6)
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;

    final path = Path();
    final midY = size.height / 2;

    path.moveTo(0, midY);
    path.lineTo(size.width * 0.2, midY);
    path.lineTo(size.width * 0.25, midY - 8);
    path.lineTo(size.width * 0.3, midY + 8);
    path.lineTo(size.width * 0.35, midY - 20);
    path.lineTo(size.width * 0.4, midY + 15);
    path.lineTo(size.width * 0.45, midY);
    path.lineTo(size.width * 0.55, midY);
    path.lineTo(size.width * 0.6, midY - 6);
    path.lineTo(size.width * 0.65, midY + 6);
    path.lineTo(size.width * 0.7, midY - 18);
    path.lineTo(size.width * 0.75, midY + 12);
    path.lineTo(size.width * 0.8, midY);
    path.lineTo(size.width, midY);

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}