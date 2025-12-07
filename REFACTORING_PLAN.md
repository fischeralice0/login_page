# План рефакторинга Login Page

## Текущие проблемы

1. **Монолитный main.dart** (563 строки) - вся логика UI в одном файле
2. **BLoC содержит бизнес-логику** - валидация, API-вызовы находятся в sign_bloc.dart
3. **Отсутствие архитектурных слоёв** - нет разделения на data/domain/presentation
4. **Виджеты в методах** - все create* методы должны быть отдельными виджетами

## Целевая архитектура
class FirebaseApi implements AuthApiI {
 @override
 Future<List<Email> getEmailById() async {
  return '';
 }
}

abstract class AuthApiI {
  Future<List<Email> getEmailById();
}


```
lib/
├── core/
│   ├── constants/
│   │   ├── app_colors.dart
│   │   └── app_images.dart
│   └── validators/
│       ├── email_validator.dart
│       ├── password_validator.dart
│       └── username_validator.dart
├── data/
│   ├── datasources/
│   │   └── auth_remote_datasource.dart (моковый API)
├── features/login
│   ├── bloc/
│   │   ├── auth_bloc.dart
│   │   ├── auth_event.dart
│   │   └── auth_state.dart
│   ├── pages/
│   │   └── login_page.dart
│   └── widgets/
│       ├── logo_widget.dart
│       ├── welcome_text_widget.dart
│       ├── sign_type_toggle.dart
│       ├── input_field_widget.dart
│       ├── primary_button_widget.dart
│       ├── divider_with_text.dart
│       ├── social_auth_buttons.dart
│       └── success_widget.dart
└── main.dart
```

## Этапы рефакторинга

### 1. Подготовка структуры проекта
- [ ] Создать папки: core, data, presentation
- [ ] Создать подпапки согласно архитектуре

### 2. Слой Core (общие компоненты)
- [ ] Переместить colors_and_images.dart в core/constants/
- [ ] Разделить на app_colors.dart и app_images.dart
- [ ] Создать EmailValidator в core/validators/
- [ ] Создать PasswordValidator в core/validators/
- [ ] Создать UsernameValidator в core/validators/

### 3. Слой Data (работа с данными)
- [ ] Создать AuthRemoteDataSource с моковыми методами (data/datasources/)
  - mockSignIn()
  - mockSignUp()
  - mockCheckEmail() - проверка email exist

### 4. Рефакторинг BLoC
- [ ] Разделить sign_bloc.dart на auth_bloc.dart, auth_event.dart, auth_state.dart
- [ ] Убрать валидацию из BLoC, использовать валидаторы
- [ ] Убрать методы checkMailAddress, checkPassword, checkData

### 5. Извлечение виджетов из main.dart
- [ ] Создать LogoWidget (из createLogo)
- [ ] Создать WelcomeTextWidget (из createTexts)
- [ ] Создать SignTypeToggle (из createSignInSignUpButton)
- [ ] Создать InputFieldWidget (из label) - универсальное поле ввода
- [ ] Создать PrimaryButton (из blueButton)
- [ ] Создать LoadingIndicator (из load)
- [ ] Создать DividerWithText (из createOrLine)
- [ ] Создать SocialAuthButtons (из createOrButtons)
- [ ] Создать SuccessWidget (из createSuccess)

### 6. Рефакторинг LoginPage
- [ ] Переместить MyLoginPage в presentation/pages/
- [ ] Упростить build метод, использовать новые виджеты
- [ ] Удалить все методы create*

### 7. Финальная чистка
- [ ] Удалить старые файлы (colors_and_images.dart, sign_bloc.dart)
- [ ] Проверить импорты во всех файлах
- [ ] Удалить неиспользуемый код
- [ ] Убрать print() statements

### 8. Тестирование
- [ ] Проверить работу Sign In флоу
- [ ] Проверить работу Sign Up флоу
- [ ] Проверить валидацию полей
- [ ] Проверить переключение между Sign In/Sign Up
- [ ] Проверить loading состояния

## Заметки
- Можно выполнять поэтапно, код будет работать после каждого этапа
- Рекомендуется использовать отдельную ветку Git для рефакторинга
- После каждого этапа делать коммит
