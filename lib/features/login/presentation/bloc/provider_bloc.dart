import 'package:flutter_bloc/flutter_bloc.dart';
import 'provider_state.dart';

class ProviderBloc extends Cubit<ProviderState> {
  ProviderBloc() : super(ProviderInitial());

  void setProvider({required Map<String, dynamic> profile, required String token}) {
    emit(ProviderLoaded(profile: profile, token: token));
  }

  void clearProvider() {
    emit(ProviderInitial());
  }
}
