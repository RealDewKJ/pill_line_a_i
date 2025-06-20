import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:pill_line_a_i/utils/helper/shared_preference/shared_preference_helper.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:pill_line_a_i/services/ehp_endpoint/ehp_api.dart';
import 'package:pill_line_a_i/core/di/service_locator.dart';
import 'package:jwt_decode/jwt_decode.dart';
import 'package:pill_line_a_i/flutter_flow/nav/nav.dart';

enum PinEntryMode { set, confirm }

class PinPage extends StatelessWidget {
  const PinPage({Key? key}) : super(key: key);

  void _onForgotPin(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('ลืมรหัส PIN?'),
        content: const Text('คุณต้องการกลับไปหน้าเข้าสู่ระบบและล้างข้อมูลการเข้าสู่ระบบทั้งหมดหรือไม่?'),
        actions: [
          TextButton(onPressed: () => Navigator.of(context).pop(false), child: const Text('ยกเลิก')),
          TextButton(onPressed: () => Navigator.of(context).pop(true), child: const Text('ตกลง')),
        ],
      ),
    );
    if (confirmed == true) {
      context.read<PinBloc>().add(PinForgot());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => PinBloc()..add(PinInit()),
      child: Scaffold(
        appBar: AppBar(title: const Text('PIN')),
        body: BlocConsumer<PinBloc, PinState>(
          listener: (context, state) {
            if (state is PinSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('PIN ถูกต้อง/บันทึกสำเร็จ')),
              );
              context.go('/ex_notdata');
            } else if (state is PinFailure) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(state.error)),
              );
              if (state.error.contains('login ใหม่')) {
                if (GoRouter.of(context).getCurrentLocation() != '/login') {
                  context.go('/login');
                }
              }
            } else if (state is PinForgotSuccess) {
              context.go('/login');
            }
          },
          builder: (context, state) {
            String label = '';
            bool isObscure = true;
            bool showButton = false;
            if (state is PinSetFirst) {
              label = 'กรุณาตั้งรหัส PIN 6 หลัก';
              showButton = state.pin.length == 6;
            } else if (state is PinSetConfirm) {
              label = 'กรุณายืนยันรหัส PIN';
              showButton = state.pin.length == 6;
            } else if (state is PinCheck) {
              label = 'กรุณากรอกรหัส PIN';
              showButton = state.pin.length == 6;
            } else if (state is PinLoading) {
              label = 'กำลังดำเนินการ...';
            }
            return Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(label, style: const TextStyle(fontSize: 20)),
                  const SizedBox(height: 32),
                  if (state is PinLoading)
                    const CircularProgressIndicator()
                  else ...[
                    TextField(
                      key: ValueKey(state.runtimeType),
                      keyboardType: TextInputType.number,
                      maxLength: 6,
                      obscureText: isObscure,
                      decoration: const InputDecoration(
                        border: OutlineInputBorder(),
                        labelText: 'PIN',
                        counterText: '',
                      ),
                      onChanged: (value) => context.read<PinBloc>().add(PinChanged(value)),
                    ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: showButton ? () => context.read<PinBloc>().add(PinSubmitted()) : null,
                        child: const Text('ยืนยัน'),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => _onForgotPin(context),
                      child: const Text('ลืมรหัส PIN?'),
                    ),
                  ],
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// --- BLoC ---
class PinBloc extends Bloc<PinEvent, PinState> {
  String? _firstPin;
  String? _pinFromPref;
  PinEntryMode? _mode;
  final _secureStorage = const FlutterSecureStorage();

  PinBloc() : super(PinLoading()) {
    on<PinInit>((event, emit) async {
      emit(PinLoading());
      final pin = SharedPrefHelper.prefs.getString('pincode');
      _pinFromPref = pin;
      if (pin == null) {
        _mode = PinEntryMode.set;
        emit(PinSetFirst(''));
      } else {
        _mode = PinEntryMode.confirm;
        emit(PinCheck(''));
      }
    });
    on<PinChanged>((event, emit) {
      if (_mode == PinEntryMode.set) {
        if (state is PinSetFirst) {
          emit(PinSetFirst(event.pin));
        } else if (state is PinSetConfirm) {
          emit(PinSetConfirm(event.pin));
        }
      } else if (_mode == PinEntryMode.confirm) {
        emit(PinCheck(event.pin));
      }
    });
    on<PinSubmitted>((event, emit) async {
      if (_mode == PinEntryMode.set) {
        if (state is PinSetFirst) {
          _firstPin = (state as PinSetFirst).pin;
          emit(PinSetConfirm(''));
        } else if (state is PinSetConfirm) {
          final confirmPin = (state as PinSetConfirm).pin;
          if (_firstPin == confirmPin) {
            emit(PinLoading());
            await SharedPrefHelper.prefs.setString('pincode', confirmPin);
            // Save username/password to secure storage (must be set from login flow)
            final username = SharedPrefHelper.prefs.getString('profile_cid') ?? '';
            final password = SharedPrefHelper.prefs.getString('profile_password') ?? '';
            if (username.isNotEmpty && password.isNotEmpty) {
              await _secureStorage.write(key: 'username', value: username);
              await _secureStorage.write(key: 'password', value: password);
            }
            emit(PinSuccess());
          } else {
            emit(PinFailure('PIN ไม่ตรงกัน กรุณาตั้งใหม่'));
            emit(PinSetFirst(''));
          }
        }
      } else if (_mode == PinEntryMode.confirm) {
        final enteredPin = (state as PinCheck).pin;
        if (enteredPin == _pinFromPref) {
          // Check JWT expiry
          final token = SharedPrefHelper.prefs.getString('apiUserJWT');
          if (token == null || Jwt.isExpired(token)) {
            emit(PinLoading());
            // Try to refresh JWT using secure storage
            final username = await _secureStorage.read(key: 'username');
            final password = await _secureStorage.read(key: 'password');
            if (username != null && password != null) {
              try {
                final ehpApi = serviceLocator<EHPApi>();
                final response = await ehpApi.getUserOTP(username, password);
                // final response = await ehpApi.getUserJWT(username, password);
                if (response.statusCode == 200 && response.data['result'] != null) {
                  await SharedPrefHelper.prefs.setString('apiUserJWT', response.data['result']);
                  emit(PinSuccess());
                } else {
                  emit(PinFailure('Token หมดอายุ และไม่สามารถขอใหม่ได้ กรุณา login ใหม่'));
                }
              } catch (e) {
                emit(PinFailure('เกิดข้อผิดพลาดในการขอ JWT ใหม่'));
              }
            } else {
              emit(PinFailure('Token หมดอายุ กรุณา login ใหม่'));
            }
          } else {
            emit(PinSuccess());
          }
        } else {
          emit(PinFailure('PIN ไม่ถูกต้อง'));
          emit(PinCheck(''));
        }
      }
    });
    on<PinForgot>((event, emit) async {
      emit(PinLoading());
      await _secureStorage.deleteAll();
      // Clear relevant SharedPrefHelper keys
      final keysToClear = [
        'pincode',
        'apiUserJWT',
        'providerAccessToken',
        'provider_id',
        'provider_special_title_th',
        'provider_firstname_th',
        'provider_name_th',
        'provider_hname_th',
        'provider_hcode9',
        'provider_position_std_id',
        'provider_position_std_type_id',
        'profile_full_name',
        'profile_cid',
        'profile_hname',
        'profile_password',
      ];
      for (final key in keysToClear) {
        await SharedPrefHelper.prefs.remove(key);
      }
      emit(PinForgotSuccess());
    });
  }
}

abstract class PinEvent {}

class PinInit extends PinEvent {}

class PinChanged extends PinEvent {
  final String pin;
  PinChanged(this.pin);
}

class PinSubmitted extends PinEvent {}

class PinForgot extends PinEvent {}

abstract class PinState {}

class PinLoading extends PinState {}

class PinSetFirst extends PinState {
  final String pin;
  PinSetFirst(this.pin);
}

class PinSetConfirm extends PinState {
  final String pin;
  PinSetConfirm(this.pin);
}

class PinCheck extends PinState {
  final String pin;
  PinCheck(this.pin);
}

class PinSuccess extends PinState {}

class PinFailure extends PinState {
  final String error;
  PinFailure(this.error);
}

class PinForgotSuccess extends PinState {}
