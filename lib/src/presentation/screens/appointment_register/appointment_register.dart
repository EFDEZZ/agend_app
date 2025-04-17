import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppointmentRegister extends StatelessWidget {
  const AppointmentRegister({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      height: 700,
      child: Center(
        child: Column(
          spacing: 5,
          children: [
            SizedBox(height: 10,),
            Text("ADD YOUR APPOINTMENT", style: TextStyle(fontSize: 20),),
            _CustomTextFormField(data: "Client Name"),
            _CustomTextFormField(data: "Client Phone"),
            _CustomTextFormField(data: "Service"),
            _CustomTextFormField(data: "Note", height: 200,),
            
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  TextButton(onPressed: () => context.pop(), child: Text("Cancelar", style: TextStyle(fontSize: 20, color: Colors.red),)),
                  TextButton(onPressed: (){}, child: Text("Guardar", style: TextStyle(fontSize: 20, color: Colors.blue),)),
                ],
              ),
            )
            ])),
    );
  }
}

class _CustomTextFormField extends StatelessWidget {
  final String data;
  final double? height;

  const _CustomTextFormField({
    required this.data, 
    this.height = 80,
    });

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    return SizedBox(
      width: double.infinity,
      height: height,
      child: Container(
        margin: EdgeInsets.only(left: 8, right: 8, top: 10),
        child: Card(
          color: colors.surface,
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextFormField(
              decoration: InputDecoration(
                alignLabelWithHint: false,
                border: InputBorder.none,
                hintText: data,
                hintStyle: TextStyle(
                  // fontSize: 30,
                  color: Colors.grey,
                  fontFamily: "Montserrat",
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
