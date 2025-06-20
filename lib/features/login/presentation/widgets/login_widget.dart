import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/login_bloc.dart';
import '../bloc/login_event.dart';
import '../bloc/login_state.dart';
import 'package:go_router/go_router.dart';
import 'package:pill_line_a_i/flutter_flow/nav/nav.dart';

const _urlHealthID = 'https://moph.id.th';
const _clientidHealthID = '9adaeaec-f199-44b2-8219-53346114fc7a';
const _secretkeyHealthID = 'KFjr0kc2fdw7p3MTIvHAjmfHqwm0tXmEouvnTGL5';
const _urlProviderID = 'https://provider.id.th';
const _clientidProviderID = '4f85415d-b356-4eb4-aacd-5695a6b9d2bc';
const _secretkeyProviderID = 'jDWetPKKH4aPmCRFhb91GKTyBUDuRwES';

class LoginWidget extends StatefulWidget {
  const LoginWidget({Key? key}) : super(key: key);

  @override
  State<LoginWidget> createState() => _LoginWidgetState();
}

class _LoginWidgetState extends State<LoginWidget> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<LoginBloc, LoginState>(
      listener: (context, state) {
        log('state: $state');
        if (state is LoginFailure) {
          log('Login failure: \u001b[31m${state.error}');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.error)),
          );
          if (GoRouter.of(context).getCurrentLocation() != '/login') {
            context.go('/login');
          }
        }
        if (state is LoginSuccess) {
          print('Navigating to /ex_notdata');
          context.go('/ex_notdata');
        }
      },
      builder: (context, state) {
        return Scaffold(
          body: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  'เข้าสู่ระบบด้วย Provider MOPH',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                state is LoginLoading
                    ? const CircularProgressIndicator()
                    : ElevatedButton.icon(
                        icon: const Icon(Icons.login),
                        label: const Text('Login ด้วย Provider MOPH'),
                        onPressed: () {
                          context.read<LoginBloc>().add(LoginWithMophOAuthPressed(context: context));
                        },
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class OrganizationSelectDialog extends StatelessWidget {
  final List<dynamic> orgList;
  const OrganizationSelectDialog({super.key, required this.orgList});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('เลือกโรงพยาบาล'),
      content: SizedBox(
        width: double.maxFinite,
        child: ListView.builder(
          shrinkWrap: true,
          itemCount: orgList.length,
          itemBuilder: (context, index) {
            final org = orgList[index];
            return ListTile(
              title: Text(org['hname_th'] ?? org['organization_name'] ?? 'ไม่ทราบชื่อ'),
              subtitle: Text('รหัส: ${org['hcode'] ?? org['organization_code'] ?? '-'}'),
              onTap: () => Navigator.of(context).pop(org),
            );
          },
        ),
      ),
    );
  }
}
