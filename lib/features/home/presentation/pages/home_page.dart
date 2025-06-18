import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pill_line_a_i/features/home/presentation/widgets/home_page_widget.dart';
import '../bloc/home_bloc.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  static const String routeName = 'home';
  static const String routePath = '/home';

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => serviceLocator<HomeBloc>()..add(LoadHomeData()),
      child: const HomePageWidget(),
    );
  }
}
