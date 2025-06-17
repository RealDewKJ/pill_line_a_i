import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pill_line_a_i/features/not_found/presentation/widgets/not_found_widget.dart';
import '../bloc/not_found_bloc.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({Key? key}) : super(key: key);

  static const String routeName = 'not_found';
  static const String routePath = '/not_found';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<NotFoundBloc>(),
      child: const NotFoundWidget(),
    );
  }
}
