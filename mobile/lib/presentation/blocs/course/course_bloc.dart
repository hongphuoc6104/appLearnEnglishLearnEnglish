import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/usecases/get_courses_usecase.dart';
import '../../../domain/repositories/course_repository.dart';
import 'course_event.dart';
import 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  final GetCoursesUseCase getCoursesUseCase;
  final CourseRepository courseRepository;

  CourseBloc({
    required this.getCoursesUseCase,
    required this.courseRepository,
  }) : super(const CourseInitial()) {
    on<LoadCourses>(_onLoadCourses);
    on<LoadCourseUnits>(_onLoadCourseUnits);
  }

  Future<void> _onLoadCourses(LoadCourses event, Emitter<CourseState> emit) async {
    emit(const CourseLoading());
    final result = await getCoursesUseCase();
    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (courses) => emit(CoursesLoaded(courses)),
    );
  }

  Future<void> _onLoadCourseUnits(LoadCourseUnits event, Emitter<CourseState> emit) async {
    emit(const CourseLoading());
    final result = await courseRepository.getCourseUnits(event.courseId);
    result.fold(
      (failure) => emit(CourseError(failure.message)),
      (units) => emit(CourseUnitsLoaded(courseId: event.courseId, units: units)),
    );
  }
}
