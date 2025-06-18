import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/bloc/ex_notdata_bloc.dart';
import 'package:pill_line_a_i/features/ex_notdata/presentation/widgets/ex_notdata_widget.dart';

class ExNotDataPage extends StatelessWidget {
  const ExNotDataPage({super.key});

  static const String routeName = 'ex_notdata';
  static const String routePath = '/ex_notdata';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<ExNotDataBloc>(),
      child: const ExNotDataWidget(),
    );
  }
}
