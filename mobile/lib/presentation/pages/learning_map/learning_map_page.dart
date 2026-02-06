import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../blocs/course/course_bloc.dart';
import '../../blocs/course/course_event.dart';
import '../../blocs/course/course_state.dart';
import '../../widgets/lesson_node.dart';

class LearningMapPage extends StatefulWidget {
  final String courseId;
  const LearningMapPage({super.key, required this.courseId});
  @override
  State<LearningMapPage> createState() => _LearningMapPageState();
}

class _LearningMapPageState extends State<LearningMapPage> {
  @override
  void initState() { super.initState(); context.read<CourseBloc>().add(LoadCourseUnits(widget.courseId)); }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Learning Path')),
      body: BlocBuilder<CourseBloc, CourseState>(builder: (context, state) {
        if (state is CourseLoading) return const Center(child: CircularProgressIndicator());
        if (state is CourseError) return Center(child: Text(state.message));
        if (state is CourseUnitsLoaded) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(vertical: 32),
            child: Column(children: [
              for (int i = 0; i < state.units.length; i++) ...[
                Padding(padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 8), child: Text(state.units[i].title, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
                ...state.units[i].lessons.asMap().entries.map((entry) {
                  final isEven = entry.key % 2 == 0;
                  return Padding(
                    padding: EdgeInsets.only(left: isEven ? 60 : 120, right: isEven ? 120 : 60, top: 8, bottom: 8),
                    child: LessonNode(lesson: entry.value, status: LessonStatus.available, onTap: () => context.go('/lesson/${entry.value.id}')),
                  );
                }),
                if (i < state.units.length - 1) const Padding(padding: EdgeInsets.symmetric(vertical: 16), child: Divider(indent: 60, endIndent: 60)),
              ],
            ]),
          );
        }
        return const SizedBox.shrink();
      }),
    );
  }
}
