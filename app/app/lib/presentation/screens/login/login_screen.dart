import 'package:app/backend/login/login_backend.dart';
import 'package:app/presentation/screens/home/home_screen.dart';
import 'package:app/presentation/widgets/login/login_text_field.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher_string.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final TextEditingController _urlMoodle = TextEditingController();
  final FocusNode _focusNode = FocusNode();
  String savedMoodle = 'https://moodleexample.com';
  bool saveEmailOption = false;
  bool loging = false;
  bool? isValid;
  bool loading = false;
  String? _loginError;
  final LoginBackend _loginBackend = LoginBackend();

  @override
  void initState() {
    super.initState();
    _loginBackend.chargeMoodle().then((moodle) {
      setState(() {
        savedMoodle = moodle;
      });
    });
    _loginBackend.loadSavedEmail().then((email) {
      setState(() {
        if (email != null) {
          _emailController.text = email;
        }
      });
    });
    _loginBackend.getSaveOption().then((option) {
      setState(() {
        saveEmailOption = option;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Center(
                  child: Image(
                    image: AssetImage('assets/logoUBU.png'),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Iniciar sesión',
                style: TextStyle(fontSize: 32, fontWeight: FontWeight.w400),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Email',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              LoginTextField(
                fieldLabel: 'Correo universitario',
                controller: _emailController,
                prefixIcon: const Icon(Icons.email),
              ),
              const SizedBox(
                height: 16,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 8),
                child: Text(
                  'Contraseña',
                  style: TextStyle(fontWeight: FontWeight.w500),
                ),
              ),
              LoginTextField(
                fieldLabel: 'Contraseña',
                controller: _passwordController,
                prefixIcon: const Icon(Icons.lock),
                isPassword: true,
              ),
              if (_loginError != null)
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8.0, vertical: 4.0),
                  child: Text(_loginError!,
                      style: const TextStyle(color: Colors.red)),
                ),
              Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    child: const Text(
                      'He olvidado mi contraseña',
                      style: TextStyle(decoration: TextDecoration.underline),
                    ),
                    onTap: () => launchUrlString(
                        'https://ubunet.ubu.es/caducada/olvido.seu'),
                  ),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Checkbox(
                    tristate: false,
                    checkColor: Colors.white,
                    fillColor: WidgetStatePropertyAll(saveEmailOption
                        ? const Color(0xFF212121)
                        : Colors.white),
                    value: saveEmailOption,
                    shape: const CircleBorder(),
                    onChanged: (bool? value) async {
                      if (value == null) return;
                      final prefs = await SharedPreferences.getInstance();
                      prefs.setBool('saveEmail', value);
                      setState(() {
                        saveEmailOption = value;
                      });
                      if (!saveEmailOption) await prefs.remove('email');
                    },
                  ),
                  const Text('Recordar correo universitario',
                      style: TextStyle(fontWeight: FontWeight.w500))
                ],
              ),
              const SizedBox(height: 16),
              Center(
                child: SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        elevation: WidgetStatePropertyAll(5),
                        backgroundColor:
                            WidgetStatePropertyAll(Color(0xFF212121))),
                    onPressed: () async {
                      await onLogin();
                    },
                    child: !loging
                        ? const Text('Iniciar sesión',
                            style: TextStyle(
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                                fontSize: 16))
                        : const CircularProgressIndicator(color: Colors.white),
                  ),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: InkWell(
                      onTap: () {
                        selectMoodle();
                      },
                      child: const Text('Conectarse a Moodle',
                          style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500))),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> selectMoodle() {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Padding(
              padding: MediaQuery.of(context).viewInsets,
              child: SizedBox(
                height: 200,
                child: Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: _urlMoodle,
                          focusNode: _focusNode,
                          decoration: InputDecoration(
                              hintText: savedMoodle,
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(30)),
                              suffixIcon: loading
                                  ? const Padding(
                                      padding: EdgeInsets.all(8.0),
                                      child: CircularProgressIndicator(),
                                    )
                                  : (isValid != null
                                      ? Icon(
                                          isValid!
                                              ? Icons.check
                                              : Icons.cancel_outlined,
                                          color: const Color(0xFF212121))
                                      : null)),
                        ),
                        const SizedBox(height: 16),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      Color(0xFF212121))),
                              onPressed: () async {
                                isValid = await _loginBackend
                                    .checkMoodleServer(_urlMoodle.text);
                                if (isValid != null && isValid!) {
                                  await _loginBackend.saveMoodle(
                                      urlMoodle: _urlMoodle);
                                  final newMoodle =
                                      await _loginBackend.chargeMoodle();
                                  setState(() {
                                    savedMoodle = newMoodle;
                                  });
                                  _urlMoodle.clear();
                                }
                                setModalState(() {});
                              },
                              child: const Text(
                                'Guardar',
                                style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w500),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Future<void> onLogin() async {
    setState(() {
      loging = true;
      _loginError = null;
    });

    try {
      final user = await _loginBackend.loginSetup(
          email: _emailController.text,
          password: _passwordController.text,
          saveEmailOption: saveEmailOption);

      Navigator.of(context).push(
          MaterialPageRoute(builder: (context) => HomeScreen(user: user)));
    } catch (e) {
      setState(() {
        _loginError = 'Correo o contraseña incorrectos';
        loging = false;
      });
    }
  }
}
