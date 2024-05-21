import 'package:flutter/material.dart';
import 'package:timeline_tile/timeline_tile.dart';

class Mytimetile extends StatelessWidget {
  final bool isfirst;
  final bool islast;
  final bool ispast;
  final String text;
  const Mytimetile({super.key, required this.isfirst, required this.islast, required this.ispast, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height*0.16,
      child: TimelineTile(
        isFirst: isfirst,
        isLast: islast,
        beforeLineStyle:  LineStyle(color: ispast? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.tertiaryContainer),
        indicatorStyle: IndicatorStyle(
          width:30,
          color: ispast? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.tertiaryContainer,
        ),
        endChild: Container(
          margin: const EdgeInsets.all(25),
          padding:  const EdgeInsets.all(30),
          decoration: BoxDecoration(color: ispast? Theme.of(context).colorScheme.primary: Theme.of(context).colorScheme.tertiaryContainer,
          borderRadius: BorderRadius.circular(15) ),
          child:  Text(text,style: const TextStyle(color: Colors.black,fontSize: 18,fontWeight: FontWeight.bold),),
        ) ,
      ),
    );
  }
}