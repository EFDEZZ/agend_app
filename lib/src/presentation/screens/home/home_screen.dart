import 'package:agend_app/src/domain/entities/appointment.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: Text("Recordatorios"),
      //   actions: [
      //     // IconButton(onPressed: (){}, icon: Icon(Icons.add)),
      //     // IconButton(onPressed: (){}, icon: Icon(Icons.search)),
      //   ],
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            pinned: true,
            floating: false,
            expandedHeight: 160,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              title: Text("Recordatorios"),
            ),
          ),
          SliverList(delegate: SliverChildBuilderDelegate((context, index) {
            
            final appointment = appointments[index];
            return Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.service,),
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
        );
          },
          childCount: appointments.length))
        ],
      ),
      floatingActionButton: IconButton.filled(
        onPressed: (){}, 
        icon: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Icon(Icons.add, size: 35,),
        )),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _HomeView extends StatelessWidget {
  const _HomeView();

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme;
    return ListView.builder(
      itemCount: appointments.length,
      itemBuilder: (context, index) {
        final appointment = appointments[index];
        return Container(
          margin: EdgeInsets.only(left: 5, right: 5, top: 5),
          child: Card(
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(appointment.service, style: textStyle.titleMedium),
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
        );
      }, 
      );
  }
}