import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fix_mates_servicer/view_model/booking_detail_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class RevenueScreen extends StatefulWidget {
  @override
  _RevenueScreenState createState() => _RevenueScreenState();
}

class _RevenueScreenState extends State<RevenueScreen> {
  DateTime? startDate;
  DateTime? endDate;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Revenue Details'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Date Range Filter
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context, true),
                  child: Text(startDate == null
                      ? 'Start Date'
                      : DateFormat('yyyy-MM-dd').format(startDate!)),
                ),
                ElevatedButton(
                  onPressed: () => _selectDate(context, false),
                  child: Text(endDate == null
                      ? 'End Date'
                      : DateFormat('yyyy-MM-dd').format(endDate!)),
                ),
              ],
            ),
            SizedBox(height: 20),
            Expanded(
              child: Obx(() {
                // Assume you fetch and filter payments in controller
                final bookingController = Get.find<BookingDetailController>();
                if (bookingController.isLoading.value) {
                  return Center(child: CircularProgressIndicator());
                }

                // Filter payments by selected date range
                final filteredPayments = bookingController.bookings
                    .where((booking) =>
                        booking['status'] == 'completed' &&
                        _isWithinDateRange(
                            booking['endTime'], startDate, endDate))
                    .toList();

                if (filteredPayments.isEmpty) {
                  return Center(
                    child:
                        Text('No payments available for the selected dates.'),
                  );
                }

                return ListView.builder(
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    final booking = filteredPayments[index];
                    return Card(
                      child: ListTile(
                        title: Text(
                          'Booking: ${booking['bookingId']}',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Text(
                            'Amount: ₹${booking['price']} \nDate: ${DateFormat('yyyy-MM-dd').format(booking['endTime'].toDate())}'),
                      ),
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context, bool isStartDate) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );

    if (pickedDate != null) {
      setState(() {
        if (isStartDate) {
          startDate = pickedDate;
        } else {
          endDate = pickedDate;
        }
      });
    }
  }

  bool _isWithinDateRange(Timestamp timestamp, DateTime? start, DateTime? end) {
    if (start == null && end == null) return true;
    final date = timestamp.toDate();
    if (start != null && date.isBefore(start)) return false;
    if (end != null && date.isAfter(end)) return false;
    return true;
  }
}
