import 'package:flutter/material.dart';
import 'package:travel/models/category_model.dart';

List categoryData = [
  CategoryModel(
    name: 'Hotels',
    routeName: 'hotel',
    icon: Icons.apartment_outlined,
  ),
  CategoryModel(
    name: 'Cars',
    routeName: 'car',
    icon: Icons.local_taxi_outlined,
  ),
  CategoryModel(
    name: 'Packages',
    routeName: 'package',
    icon: Icons.redeem_outlined,
  ),
  CategoryModel(
    name: 'Duty Free',
    routeName: 'duty',
    icon: Icons.shopping_bag_outlined,
  ),
  CategoryModel(
    name: 'Restaurant',
    routeName: 'restaurant',
    icon: Icons.restaurant_outlined,
  ),
  CategoryModel(
    name: 'Activity',
    routeName: 'activity',
    icon: Icons.calendar_month_outlined,
  ),
  CategoryModel(
    name: 'Home Stay',
    routeName: 'homestay',
    icon: Icons.home_outlined,
  ),
  CategoryModel(
    name: 'Ticket',
    routeName: 'ticket',
    icon: Icons.airplane_ticket_outlined,
  ),
  CategoryModel(
    name: 'Other',
    routeName: 'other',
    icon: Icons.navigate_next,
  ),
];
