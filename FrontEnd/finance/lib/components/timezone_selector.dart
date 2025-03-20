import 'package:flutter/material.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class TimezoneSelector extends StatefulWidget {
  final String selectedTimezone;

  const TimezoneSelector({
    Key? key,
    required this.selectedTimezone,
  }) : super(key: key);

  @override
  State<TimezoneSelector> createState() => _TimezoneSelectorState();
}

class _TimezoneSelectorState extends State<TimezoneSelector> {
  late TextEditingController _searchController;
  List<String> _filteredTimezones = [];
  List<String> _allTimezones = [];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
    tz.initializeTimeZones();
    _allTimezones = tz.timeZoneDatabase.locations.keys.toList()
      ..sort((a, b) => a.compareTo(b));
    _filteredTimezones = _allTimezones;
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _filterTimezones(String query) {
    setState(() {
      _filteredTimezones = _allTimezones.where((timezone) {
        final lowercaseQuery = query.toLowerCase();
        return timezone.toLowerCase().contains(lowercaseQuery);
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              'Select Timezone',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                hintText: 'Search timezone...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: _filterTimezones,
            ),
            const SizedBox(height: 16),
            Container(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.5,
              ),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: _filteredTimezones.length,
                itemBuilder: (context, index) {
                  final timezone = _filteredTimezones[index];
                  return ListTile(
                    title: Text(timezone),
                    trailing: timezone == widget.selectedTimezone
                        ? const Icon(Icons.check, color: Colors.green)
                        : null,
                    onTap: () {
                      Navigator.pop(context, timezone);
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
} 