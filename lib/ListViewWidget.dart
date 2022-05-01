import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

Widget listViewItems({
  String? title,
  String? singer,
  String? cover,
  onTap,
})  {
  return InkWell(
    onTap: onTap,
    child: Container(
      padding: EdgeInsets.all(8.0),
      child: Row(
        children: [
          Container(
            height: 80,
            width: 80,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(16.0),
              image: DecorationImage(image: NetworkImage(cover!,),),
            ),
          ),
          SizedBox(
            width: 10.0,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title!,style:TextStyle(fontSize: 18, fontWeight: FontWeight.w800) ,),
              SizedBox(height: 5,),
              Text(singer!,style:TextStyle(fontSize: 14,color: Colors.grey,fontWeight: FontWeight.w800) ,),
            ],
          )
        ],
      ) ,
    ),
  );
}
