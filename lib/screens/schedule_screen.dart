import 'package:flutter/material.dart';

class ScheduleScreen extends StatefulWidget {
  const ScheduleScreen({Key? key}) : super(key: key);

  @override
  State<ScheduleScreen> createState() => _ScheduleScreenState();
}

class _ScheduleScreenState extends State<ScheduleScreen> {
  final _formKey = GlobalKey<FormState>();
  final _addressController = TextEditingController();
  final _notesController = TextEditingController();
  
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _selectedService = 'Wash & Fold';
  bool _needsPickup = true;

  final List<String> _services = [
    'Wash & Fold',
    'Dry Cleaning',
    'Comforters',
    'Specialty Items',
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Upcoming Pickups Card
            _buildUpcomingPickupsCard(),
            const SizedBox(height: 24),
            
            // Schedule New Pickup Card
            _buildScheduleNewPickupCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildUpcomingPickupsCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.schedule,
                color: Color(0xFF3B82F6),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Upcoming Pickups',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Pickup items
          _buildPickupItem(
            'July 5, 2025 - 9:00 AM',
            'Scheduled',
            '123 Main St, Anytown',
            Colors.blue,
          ),
          const Divider(height: 24),
          _buildPickupItem(
            'July 12, 2025 - 2:00 PM',
            'Confirmed',
            '123 Main St, Anytown',
            Colors.green,
          ),
        ],
      ),
    );
  }

  Widget _buildPickupItem(String date, String status, String address, Color statusColor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          date,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: statusColor.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  color: statusColor,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          address,
          style: const TextStyle(
            fontSize: 14,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            TextButton.icon(
              onPressed: () {
                _showEditPickupDialog(date, status, address);
              },
              icon: const Icon(Icons.edit, size: 16),
              label: const Text('Edit'),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF3B82F6),
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
            const SizedBox(width: 8),
            TextButton.icon(
              onPressed: () {
                _showCancelPickupDialog(date);
              },
              icon: const Icon(Icons.cancel, size: 16),
              label: const Text('Cancel'),
              style: TextButton.styleFrom(
                foregroundColor: Colors.red[600],
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildScheduleNewPickupCard() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.add_circle,
                color: Color(0xFF10B981),
                size: 24,
              ),
              const SizedBox(width: 8),
              const Text(
                'Schedule New Pickup',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          
          // Service Type
          _buildFormField(
            label: 'Service Type',
            child: DropdownButtonFormField<String>(
              value: _selectedService,
              decoration: _inputDecoration('Select service type'),
              items: _services.map((service) {
                return DropdownMenuItem(
                  value: service,
                  child: Text(service),
                );
              }).toList(),
              onChanged: (value) {
                setState(() {
                  _selectedService = value!;
                });
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Date and Time
          Row(
            children: [
              Expanded(
                child: _buildFormField(
                  label: 'Pickup Date',
                  child: TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      _selectedDate != null
                          ? '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}'
                          : 'Select date',
                    ).copyWith(
                      suffixIcon: const Icon(Icons.calendar_today),
                    ),
                    onTap: _selectDate,
                    validator: (value) {
                      if (_selectedDate == null) {
                        return 'Please select a date';
                      }
                      return null;
                    },
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: _buildFormField(
                  label: 'Pickup Time',
                  child: TextFormField(
                    readOnly: true,
                    decoration: _inputDecoration(
                      _selectedTime != null
                          ? _selectedTime!.format(context)
                          : 'Select time',
                    ).copyWith(
                      suffixIcon: const Icon(Icons.access_time),
                    ),
                    onTap: _selectTime,
                    validator: (value) {
                      if (_selectedTime == null) {
                        return 'Please select a time';
                      }
                      return null;
                    },
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          
          // Address
          _buildFormField(
            label: 'Pickup Address',
            child: TextFormField(
              controller: _addressController,
              decoration: _inputDecoration('Enter pickup address'),
              maxLines: 2,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter pickup address';
                }
                return null;
              },
            ),
          ),
          const SizedBox(height: 20),
          
          // Special Instructions
          _buildFormField(
            label: 'Special Instructions (Optional)',
            child: TextFormField(
              controller: _notesController,
              decoration: _inputDecoration('Any special instructions...'),
              maxLines: 3,
            ),
          ),
          const SizedBox(height: 20),
          
          // Pickup/Delivery Options
          CheckboxListTile(
            title: const Text('I need pickup service'),
            subtitle: const Text('Uncheck if you\'ll drop off items yourself'),
            value: _needsPickup,
            onChanged: (value) {
              setState(() {
                _needsPickup = value ?? true;
              });
            },
            activeColor: const Color(0xFF3B82F6),
            contentPadding: EdgeInsets.zero,
          ),
          const SizedBox(height: 24),
          
          // Schedule Button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _schedulePickup,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Schedule Pickup',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFormField({required String label, required Widget child}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF374151),
          ),
        ),
        const SizedBox(height: 8),
        child,
      ],
    );
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFF3B82F6), width: 2),
      ),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
    );
  }

  void _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now().add(const Duration(days: 1)),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
    );
    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  void _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      setState(() {
        _selectedTime = picked;
      });
    }
  }

  void _schedulePickup() {
    if (_formKey.currentState!.validate()) {
      // Handle scheduling logic here
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Pickup scheduled successfully!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    }
  }

  void _showEditPickupDialog(String date, String status, String address) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        final editDateController = TextEditingController(text: date);
        final editAddressController = TextEditingController(text: address);
        
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Text(
            'Edit Pickup',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: editDateController,
                  decoration: const InputDecoration(
                    labelText: 'Date & Time',
                    prefixIcon: Icon(Icons.schedule),
                    border: OutlineInputBorder(),
                  ),
                  readOnly: true,
                  onTap: () async {
                    final pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now().add(const Duration(days: 1)),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );
                    if (pickedDate != null) {
                      final pickedTime = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.now(),
                      );
                      if (pickedTime != null) {
                        editDateController.text = 
                            '${pickedDate.day}/${pickedDate.month}/${pickedDate.year} - ${pickedTime.format(context)}';
                      }
                    }
                  },
                ),
                const SizedBox(height: 16),
                TextFormField(
                  controller: editAddressController,
                  decoration: const InputDecoration(
                    labelText: 'Address',
                    prefixIcon: Icon(Icons.location_on),
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 2,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pickup updated successfully!'),
                    backgroundColor: Color(0xFF10B981),
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
              ),
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showCancelPickupDialog(String date) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.warning, color: Colors.orange),
              SizedBox(width: 8),
              Text('Cancel Pickup'),
            ],
          ),
          content: Text(
            'Are you sure you want to cancel the pickup scheduled for $date?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Keep Pickup'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Pickup cancelled successfully'),
                    backgroundColor: Colors.orange,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              child: const Text('Cancel Pickup'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    _notesController.dispose();
    super.dispose();
  }
}
