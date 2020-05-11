import 'package:flutter/material.dart';

class AuthForm extends StatefulWidget {
  final void Function(
    String email,
    String password,
    bool _isRegistration,
    BuildContext ctx,
  ) submitFn;

  final bool isLoading;
  AuthForm(this.submitFn, this.isLoading);

  @override
  _AuthFormState createState() => _AuthFormState();
}

class _AuthFormState extends State<AuthForm> {
  bool _isRegistration = true;
  final _formKey = GlobalKey<FormState>();
  final _passwordKey = GlobalKey<FormFieldState>();
  String _email;
  String _password;

  void _trySave() {
    final isValid = _formKey.currentState.validate();
    FocusScope.of(context).unfocus();
    if (isValid) {
      _formKey.currentState.save();
      widget.submitFn(_email, _password, _isRegistration, context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Card(
        margin: EdgeInsets.all(16),
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  TextFormField(
                    key: ValueKey('email'),
                    validator: (value) {
                      bool isValid = RegExp(
                              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                          .hasMatch(value);
                      if (!isValid) return "Некорректный адрес";
                      return null;
                    },
                    onSaved: (value) => _email = value.trim(),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Адрес электронной почты',
                    ),
                  ),
                  TextFormField(
                    key: _passwordKey,
                    validator: (value) {
                      String val = value.trim();
                      if (val == "") return "Введите пароль";
                      if (val.length < 6) return "Слишком короткий пароль";
                      return null;
                    },
                    onSaved: (value) {
                      _password = value.trim();
                    },
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                    ),
                    obscureText: true,
                  ),
                  if (_isRegistration)
                    TextFormField(
                      key: ValueKey('password2'),
                      validator: (value) {
                        String val = value.trim();
                        if (val == "") return "Введите пароль еще раз";
                        if (value != _passwordKey.currentState.value)
                          return "Пароли не совпадают";
                        return null;
                      },
                      onSaved: (value) {
                        _password = value.trim();
                      },
                      decoration: InputDecoration(
                        labelText: 'Пароль',
                      ),
                      obscureText: true,
                    ),
                  SizedBox(height: 12),
                  if (widget.isLoading) CircularProgressIndicator(),
                  if (!widget.isLoading)
                    RaisedButton(
                      onPressed: _trySave,
                      child: Text(
                          _isRegistration ? "Зарегистрироваться" : "Войти"),
                    ),
                  FlatButton(
                    textColor: Theme.of(context).accentColor,
                    onPressed: () =>
                        setState(() => _isRegistration = !_isRegistration),
                    child: Text(_isRegistration ? "Войти" : "Регистрация"),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
