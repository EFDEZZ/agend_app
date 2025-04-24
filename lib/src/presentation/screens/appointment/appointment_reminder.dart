import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:agend_app/src/presentation/screens/screens.dart';
import 'package:agend_app/src/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';

class AppointmentReminder extends StatelessWidget {
  const AppointmentReminder({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: CustomDrawer(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      body: CustomScrollView(
        slivers: [
          CustomSliverAppbar(title: 'Reminders'),
          _HomeView(),
        ],
      ),
      floatingActionButton: IconButton.filled(
        onPressed: () {
          showModalBottomSheet(
            isScrollControlled: true,
            context: context,
            builder: (context) {
              return AppointmentRegister();
            },
          );
        },
        icon: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(Icons.add, size: 35),
        ),
      ),
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    return SliverList(
      delegate: SliverChildBuilderDelegate((context, index) {
        final appointment = appointments[index];
        return Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Card(
            elevation: 3,
            child: InkWell(
              borderRadius: BorderRadius.circular(15),
              onTap: () {},
              child: Padding(
                padding: const EdgeInsets.all(30.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(appointment.service),
                    Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(appointment.formattedDate),

                        // Text(appointment.formattedTime)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      }, childCount: appointments.length),
    );
  }
}
