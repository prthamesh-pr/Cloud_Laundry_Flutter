import 'package:flutter/material.dart';
import '../providers/schedule_provider.dart';

class ScheduleTestPage extends StatefulWidget {
  const ScheduleTestPage({Key? key}) : super(key: key);

  @override
  _ScheduleTestPageState createState() => _ScheduleTestPageState();
}

class _ScheduleTestPageState extends State<ScheduleTestPage> {
  final ScheduleProvider _scheduleProvider = ScheduleProvider();

  @override
  void initState() {
    super.initState();
    _loadSchedules();
  }

  void _loadSchedules() {
    _scheduleProvider.fetchSchedules();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Schedule Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadSchedules,
          ),
        ],
      ),
      body: ListenableBuilder(
        listenable: _scheduleProvider,
        builder: (context, child) {
          if (_scheduleProvider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (_scheduleProvider.error != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.error_outline, size: 64, color: Colors.red[300]),
                  const SizedBox(height: 16),
                  Text(
                    'Error: ${_scheduleProvider.error}',
                    style: const TextStyle(color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _loadSchedules,
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final schedules = _scheduleProvider.schedules;

          if (schedules.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.schedule, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No schedules found',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Schedule API is not fully implemented yet',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: schedules.length,
            itemBuilder: (context, index) {
              final schedule = schedules[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(schedule.serviceName),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Date: ${schedule.scheduledDate.toLocal()}'),
                      Text('Time: ${schedule.timeSlot}'),
                      Text('Status: ${schedule.statusDisplayName}'),
                    ],
                  ),
                  trailing: schedule.canCancel
                      ? IconButton(
                          icon: const Icon(Icons.cancel, color: Colors.red),
                          onPressed: () => _cancelSchedule(schedule.id),
                        )
                      : Icon(
                          _getStatusIcon(schedule.status),
                          color: _getStatusColor(schedule.status),
                        ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateScheduleDialog(),
        child: const Icon(Icons.add),
      ),
    );
  }

  IconData _getStatusIcon(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Icons.schedule;
      case 'confirmed':
        return Icons.check_circle;
      case 'completed':
        return Icons.done_all;
      case 'cancelled':
        return Icons.cancel;
      default:
        return Icons.help;
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'scheduled':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'completed':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  void _cancelSchedule(String scheduleId) async {
    final success = await _scheduleProvider.cancelSchedule(scheduleId);
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            success
                ? 'Schedule cancelled successfully'
                : 'Failed to cancel schedule',
          ),
          backgroundColor: success ? Colors.green : Colors.red,
        ),
      );
    }
  }

  void _showCreateScheduleDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Create Schedule'),
        content: const Text(
          'Schedule creation functionality is not fully implemented yet.\n\n'
          'This requires:\n'
          '- Backend schedule API endpoints\n'
          '- Service selection\n'
          '- Address management\n'
          '- Date/time picker',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}
