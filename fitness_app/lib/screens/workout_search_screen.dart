import 'dart:async';

import 'package:flutter/material.dart';

import '../services/workout_api_service.dart';

class WorkoutSearchScreen extends StatefulWidget {
  final double weightKg;

  const WorkoutSearchScreen({super.key, required this.weightKg});

  @override
  State<WorkoutSearchScreen> createState() => _WorkoutSearchScreenState();
}

class _WorkoutSearchScreenState extends State<WorkoutSearchScreen> {
  final TextEditingController _searchController = TextEditingController();

  Timer? _debounce;

  List<Map<String, dynamic>> _activities = [];

  bool _isLoading = false;
  String? _error;

  @override
  void dispose() {
    _debounce?.cancel();
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged(String value) {
    _debounce?.cancel();

    final query = value.trim();

    if (query.length < 2) {
      setState(() {
        _activities = [];
        _error = null;
        _isLoading = false;
      });

      return;
    }

    _debounce = Timer(const Duration(milliseconds: 500), () {
      _search(query);
    });
  }

  Future<void> _search(String query) async {
    setState(() {
      _isLoading = true;
      _error = null;
    });

    try {
      final results = await WorkoutApiService.searchActivities(
        query: query,
        weightKg: widget.weightKg,
        durationMinutes: 60,
      );

      if (!mounted) return;

      setState(() {
        _activities = results;
        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _activities = [];
        _isLoading = false;
        _error = 'Could not search activities.';
      });
    }
  }

  Future<void> _openActivity(Map<String, dynamic> activity) async {
    final result = await showModalBottomSheet<Map<String, dynamic>>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) {
        return _WorkoutDurationSheet(
          activity: activity,
          weightKg: widget.weightKg,
        );
      },
    );

    if (result == null || !mounted) return;

    Navigator.pop(context, result);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F4FF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF7F4FF),
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Add Workout',
          style: TextStyle(
            color: Color(0xFF241C3B),
            fontWeight: FontWeight.w900,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(18, 12, 18, 10),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(color: const Color(0xFFE2D9FF)),
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: _onSearchChanged,
                  autofocus: true,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    icon: Icon(Icons.search_rounded, color: Color(0xFF6C4DCC)),
                    hintText: 'Search activity...',
                  ),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
              child: Row(
                children: [
                  const Icon(
                    Icons.monitor_weight_outlined,
                    size: 18,
                    color: Color(0xFF7A728A),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${widget.weightKg.toStringAsFixed(0)} kg',
                    style: const TextStyle(
                      color: Color(0xFF7A728A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 6),

            Expanded(child: _buildContent()),
          ],
        ),
      ),
    );
  }

  Widget _buildContent() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Text(
            _error!,
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.red,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
      );
    }

    if (_searchController.text.trim().length < 2) {
      return const Center(
        child: Padding(
          padding: EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.directions_run_rounded,
                size: 70,
                color: Color(0xFF6C4DCC),
              ),
              SizedBox(height: 18),
              Text(
                'Search for an activity',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF241C3B),
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Type at least 2 letters.\nFor example: running, cycling, swimming or yoga.',
                textAlign: TextAlign.center,
                style: TextStyle(color: Color(0xFF7A728A), height: 1.5),
              ),
            ],
          ),
        ),
      );
    }

    if (_activities.isEmpty) {
      return const Center(
        child: Text(
          'No activities found.',
          style: TextStyle(color: Color(0xFF7A728A)),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(18, 10, 18, 30),
      itemCount: _activities.length,
      separatorBuilder: (_, __) {
        return const SizedBox(height: 10);
      },
      itemBuilder: (context, index) {
        final activity = _activities[index];

        final name = activity['name']?.toString() ?? 'Activity';

        final calories = (activity['caloriesPerHour'] as num?)?.round() ?? 0;

        return InkWell(
          borderRadius: BorderRadius.circular(22),
          onTap: () {
            _openActivity(activity);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(22),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFE3D8),
                    borderRadius: BorderRadius.circular(17),
                  ),
                  child: const Icon(
                    Icons.local_fire_department_rounded,
                    color: Color(0xFFFF7043),
                  ),
                ),

                const SizedBox(width: 14),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w900,
                          color: Color(0xFF241C3B),
                        ),
                      ),

                      const SizedBox(height: 6),

                      Text(
                        '$calories kcal / hour',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFF7043),
                        ),
                      ),

                      const SizedBox(height: 3),

                      const Text(
                        'API Ninjas',
                        style: TextStyle(
                          fontSize: 11,
                          color: Color(0xFF7A728A),
                        ),
                      ),
                    ],
                  ),
                ),

                const Icon(
                  Icons.chevron_right_rounded,
                  color: Color(0xFF6C4DCC),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _WorkoutDurationSheet extends StatefulWidget {
  final Map<String, dynamic> activity;
  final double weightKg;

  const _WorkoutDurationSheet({required this.activity, required this.weightKg});

  @override
  State<_WorkoutDurationSheet> createState() => _WorkoutDurationSheetState();
}

class _WorkoutDurationSheetState extends State<_WorkoutDurationSheet> {
  int _hours = 0;
  int _minutes = 30;

  int get _totalMinutes {
    return (_hours * 60) + _minutes;
  }

  int get _calories {
    final perHour =
        (widget.activity['caloriesPerHour'] as num?)?.toDouble() ?? 0;

    if (_totalMinutes <= 0) {
      return 0;
    }

    return (perHour * (_totalMinutes / 60)).round();
  }

  @override
  Widget build(BuildContext context) {
    final name = widget.activity['name']?.toString() ?? 'Workout';

    return Container(
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(32)),
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 45,
              height: 5,
              decoration: BoxDecoration(
                color: const Color(0xFFD8D3E5),
                borderRadius: BorderRadius.circular(20),
              ),
            ),

            const SizedBox(height: 20),

            const CircleAvatar(
              radius: 31,
              backgroundColor: Color(0xFFFFE3D8),
              child: Icon(
                Icons.local_fire_department_rounded,
                color: Color(0xFFFF7043),
                size: 32,
              ),
            ),

            const SizedBox(height: 14),

            Text(
              name,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w900,
                color: Color(0xFF241C3B),
              ),
            ),

            const SizedBox(height: 24),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Duration',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w900,
                  color: Color(0xFF241C3B),
                ),
              ),
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _hours,
                    decoration: InputDecoration(
                      labelText: 'Hours',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    items: List.generate(
                      13,
                      (index) => DropdownMenuItem(
                        value: index,
                        child: Text('$index h'),
                      ),
                    ),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _hours = value;
                      });
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: DropdownButtonFormField<int>(
                    value: _minutes,
                    decoration: InputDecoration(
                      labelText: 'Minutes',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(18),
                      ),
                    ),
                    items: List.generate(12, (index) {
                      final minute = index * 5;

                      return DropdownMenuItem(
                        value: minute,
                        child: Text('$minute min'),
                      );
                    }),
                    onChanged: (value) {
                      if (value == null) return;

                      setState(() {
                        _minutes = value;
                      });
                    },
                  ),
                ),
              ],
            ),

            const SizedBox(height: 22),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFFFFF1EB),
                borderRadius: BorderRadius.circular(23),
              ),
              child: Column(
                children: [
                  const Text(
                    'Estimated calories burned',
                    style: TextStyle(
                      color: Color(0xFF7A728A),
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Text(
                    '$_calories kcal',
                    style: const TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                      color: Color(0xFFFF7043),
                    ),
                  ),

                  const SizedBox(height: 5),

                  Text(
                    'for ${_durationText(_totalMinutes)}',
                    style: const TextStyle(color: Color(0xFF7A728A)),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 22),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton.icon(
                onPressed: _totalMinutes <= 0
                    ? null
                    : () {
                        Navigator.pop(context, {
                          'name': name,
                          'duration': _totalMinutes,
                          'calories': _calories,
                          'caloriesPerHour': widget.activity['caloriesPerHour'],
                          'source': widget.activity['source'] ?? 'API Ninjas',
                        });
                      },
                icon: const Icon(Icons.add_rounded),
                label: const Text(
                  'Add Workout',
                  style: TextStyle(fontWeight: FontWeight.w900),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF6C4DCC),
                  foregroundColor: Colors.white,
                  disabledBackgroundColor: const Color(0xFFD8D3E5),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(19),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _durationText(int totalMinutes) {
    final hours = totalMinutes ~/ 60;
    final minutes = totalMinutes % 60;

    if (hours > 0 && minutes > 0) {
      return '${hours}h ${minutes}min';
    }

    if (hours > 0) {
      return '${hours}h';
    }

    return '${minutes}min';
  }
}
