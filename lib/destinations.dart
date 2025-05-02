import 'package:flutter/material.dart';

class Destination {
  const Destination(this.icon, this.label);
  final IconData icon;
  final String label;
}

const List<Destination> destinations = <Destination>[
  Destination(Icons.attach_money_rounded, 'Donation'),
  Destination(Icons.pets, 'Become adopter'),
  Destination(Icons.home, 'Home'),
  Destination(Icons.home, 'Need a home'),
  Destination(Icons.library_books_outlined, 'Our story'),
];