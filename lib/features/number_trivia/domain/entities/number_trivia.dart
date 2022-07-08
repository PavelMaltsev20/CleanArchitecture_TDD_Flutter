import 'package:equatable/equatable.dart';

class NumberTrivia extends Equatable {
  final int number;
  final String text;

  NumberTrivia({required this.text, required this.number});

  @override
  List<Object> get props => [text, number];
}
