import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/correct_writing_usecase.dart';
import 'writing_event.dart';
import 'writing_state.dart';

class WritingBloc extends Bloc<WritingEvent, WritingState> {
  final CorrectWritingUseCase correctWritingUseCase;

  WritingBloc({required this.correctWritingUseCase}) : super(const WritingInitial()) {
    on<SubmitWriting>(_onSubmitWriting);
    on<ResetWriting>(_onResetWriting);
  }

  Future<void> _onSubmitWriting(SubmitWriting event, Emitter<WritingState> emit) async {
    emit(const WritingLoading());
    final result = await correctWritingUseCase(event.text, context: event.context);
    result.fold(
      (failure) => emit(WritingError(failure.message)),
      (writingResult) => emit(WritingCorrected(writingResult)),
    );
  }

  void _onResetWriting(ResetWriting event, Emitter<WritingState> emit) {
    emit(const WritingInitial());
  }
}
