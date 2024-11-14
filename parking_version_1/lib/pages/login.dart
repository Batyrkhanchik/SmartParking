import 'package:flutter/material.dart';
import 'package:flutter_login/flutter_login.dart';

import '../components/Login_base.dart';
// Импортируем класс UserDatabase для работы с базой данных

class LoginPage extends StatelessWidget {
   LoginPage({super.key});

  Duration get loadingTime => const Duration(milliseconds: 2000);

  // Создаём экземпляр базы данных
  final UserDatabase _userDatabase = UserDatabase();

  Future<String?> _authUser(LoginData data) async {
    // Проверяем, существует ли пользователь с таким логином и паролем
    final user = await _userDatabase.getUser(data.name, data.password);
    if (user != null) {
      return null; // Возвращаем null, если вход успешен
    } else {
      return 'Неверный логин или пароль'; // Ошибка при неверных данных
    }
  }

  Future<String?> _recoverPassword(String data) {
    return Future.delayed(loadingTime).then((_) => 'Функция восстановления пароля не реализована.');
  }

  Future<String?> _signupUser(SignupData data) async {
    // Добавляем нового пользователя в базу данных при регистрации
    if (data.name != null && data.password != null) {
      await _userDatabase.insertUser(data.name!, data.password!);
      return null; // Успешная регистрация
    }
    return 'Ошибка регистрации: укажите логин и пароль';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FlutterLogin(
        showDebugButtons: false,
        title: 'Welcome',
        logo: const AssetImage('images/logo-color.png'),
        onLogin: _authUser,
        onRecoverPassword: _recoverPassword,
        onSignup: _signupUser,
        onSubmitAnimationCompleted: () {
          Navigator.of(context).pushReplacementNamed('/home'); // Переход на главную страницу после успешного входа
        },
        theme: LoginTheme(
          primaryColor: Colors.blueAccent,
          accentColor: Colors.lightBlueAccent,
          titleStyle: const TextStyle(color: Colors.black, fontSize: 24),
          cardTheme: CardTheme(
            color: Colors.white,
            elevation: 5,
            margin: const EdgeInsets.symmetric(horizontal: 20),
          ),
        ),
      ),
    );
  }
}
