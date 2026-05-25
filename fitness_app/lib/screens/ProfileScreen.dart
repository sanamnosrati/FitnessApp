import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    const eaten = 400;
    const burned = 100;
    const goal = 1200;
    const protein = 32;
    final progress = eaten / goal;

    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FB),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _profileHeader(),
              const SizedBox(height: 18),
              _bodyData(),
              const SizedBox(height: 18),
              _calorieCircle(progress, eaten, burned, goal, protein),
              const SizedBox(height: 18),
              _todayLog(),
              const SizedBox(height: 18),
              _settingsMenu(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _profileHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6A5AE0), Color(0xFF8B7CFF)],
        ),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Row(
        children: [
          const CircleAvatar(
            radius: 38,
            backgroundColor: Colors.white24,
            child: Icon(Icons.person, color: Colors.white, size: 42),
          ),
          const SizedBox(width: 16),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Sanam Hadadnosrati",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 21,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  "sanam@email.com",
                  style: TextStyle(color: Colors.white70),
                ),
                SizedBox(height: 8),
                Text(
                  "Goal: Lose Weight",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.edit, color: Colors.white),
          ),
        ],
      ),
    );
  }

  Widget _bodyData() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.7,
      children: const [
        _InfoCard(title: "Gender", value: "Female", icon: Icons.female),
        _InfoCard(title: "Age", value: "19", icon: Icons.cake),
        _InfoCard(title: "Height", value: "165 cm", icon: Icons.height),
        _InfoCard(title: "Weight", value: "62 kg", icon: Icons.monitor_weight),
        _InfoCard(title: "Goal Weight", value: "57 kg", icon: Icons.flag),
        _InfoCard(title: "Phone", value: "Optional", icon: Icons.phone),
      ],
    );
  }

  Widget _calorieCircle(
    double progress,
    int eaten,
    int burned,
    int goal,
    int protein,
  ) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF111827),
        borderRadius: BorderRadius.circular(28),
      ),
      child: Column(
        children: [
          const Row(
            children: [
              Icon(Icons.local_fire_department, color: Colors.orangeAccent),
              SizedBox(width: 8),
              Text(
                "Today’s Calories",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: 160,
            height: 160,
            child: Stack(
              alignment: Alignment.center,
              children: [
                CircularProgressIndicator(
                  value: progress,
                  strokeWidth: 15,
                  backgroundColor: Colors.white12,
                  valueColor: const AlwaysStoppedAnimation(Color(0xFF8B7CFF)),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "$eaten kcal",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 25,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    Text(
                      "of $goal kcal",
                      style: const TextStyle(color: Colors.white60),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "-$burned burned",
                      style: const TextStyle(color: Colors.greenAccent),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 18),
          Row(
            children: [
              Expanded(child: _DarkMini(title: "Protein", value: "$protein g")),
              const SizedBox(width: 12),
              Expanded(
                child: _DarkMini(
                  title: "Remaining",
                  value: "${goal - eaten + burned} kcal",
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _todayLog() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Today",
          style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 12),
        _logTile(Icons.directions_walk, "30 min Walk", "-100 kcal", "Activity"),
        _logTile(
          Icons.breakfast_dining,
          "Breakfast",
          "+400 kcal",
          "32g Protein",
        ),
        _logTile(
          Icons.calendar_month,
          "Last 15 days",
          "View history",
          "Nutrition & activity",
        ),
      ],
    );
  }

  Widget _settingsMenu() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          _menuTile(Icons.bookmark, "Saved"),
          _menuTile(Icons.language, "Language"),
          _menuTile(Icons.notifications, "Notifications"),
          _menuTile(Icons.help_outline, "Help Center: your-email@example.com"),
          _menuTile(Icons.logout, "Logout", red: true),
        ],
      ),
    );
  }

  Widget _logTile(IconData icon, String title, String value, String subtitle) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: const Color(0xFF6A5AE0).withOpacity(0.12),
            child: Icon(icon, color: const Color(0xFF6A5AE0)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
              Text(
                subtitle,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _menuTile(IconData icon, String title, {bool red = false}) {
    return ListTile(
      leading: Icon(
        icon,
        color: red ? Colors.redAccent : const Color(0xFF6A5AE0),
      ),
      title: Text(
        title,
        style: TextStyle(
          color: red ? Colors.redAccent : Colors.black87,
          fontWeight: FontWeight.w600,
        ),
      ),
      trailing: const Icon(Icons.chevron_right),
      onTap: () {},
    );
  }
}

class _InfoCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;

  const _InfoCard({
    required this.title,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF6A5AE0)),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                title,
                style: const TextStyle(color: Colors.black45, fontSize: 12),
              ),
              Text(value, style: const TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
        ],
      ),
    );
  }
}

class _DarkMini extends StatelessWidget {
  final String title;
  final String value;

  const _DarkMini({required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white60)),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
