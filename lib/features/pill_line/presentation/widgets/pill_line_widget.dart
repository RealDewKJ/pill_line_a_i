import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/pill_line_bloc.dart';

class PillLineWidget extends StatelessWidget {
  const PillLineWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<PillLineBloc, PillLineState>(
      builder: (context, state) {
        if (state is PillLineLoading) {
          return const Center(child: CircularProgressIndicator());
        } else if (state is PillLineLoaded) {
          return ListView.builder(
            itemCount: state.pillLines.length,
            itemBuilder: (context, index) {
              final pillLine = state.pillLines[index];
              return ListTile(
                title: Text(pillLine.name),
                subtitle: Text(pillLine.status),
                trailing: Text(pillLine.lastUpdated.toString()),
              );
            },
          );
        } else if (state is PillLineError) {
          return Center(child: Text(state.message));
        }
        return const SizedBox();
      },
    );
  }
}
