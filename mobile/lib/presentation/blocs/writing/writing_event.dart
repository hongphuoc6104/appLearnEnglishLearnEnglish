import 'package:equatable/equatable.dart';

abstract class WritingEvent extends Equatable {
  const WritingEvent();
  @override
  List<Object?> get props => [];
}

class SubmitWriting extends WritingEvent {
  final String text;
  final String? context;
  const SubmitWriting({required this.text, this.context});
  @override
  List<Object?> get props => [text, context];
}

class ResetWriting extends WritingEvent {
  const ResetWriting();
}
