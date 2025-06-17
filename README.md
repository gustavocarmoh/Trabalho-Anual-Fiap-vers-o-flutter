
# NutriXpert 🥗📱

NutriXpert é um aplicativo de nutrição inteligente, desenvolvido em Flutter, com foco em oferecer uma experiência personalizada para os usuários. Ele permite que pessoas criem um perfil, definam metas, compartilhem informações sobre saúde e recebam sugestões alinhadas ao seu estilo de vida.

## ✨ Funcionalidades

- Registro e login de usuários
- Recuperação de senha
- Formulário de perfil nutricional
- Interface intuitiva e responsiva
- Navegação com barra inferior
- Visual moderno com identidade visual em lilás
- Validações de formulário integradas

## 📱 Telas principais

- Tela de login
- Cadastro de conta
- Recuperação de conta
- Dashboard com navegação inferior
- Perfil com dados do usuário
- Tela de planos personalizados

## 🛠️ Tecnologias utilizadas

- **Flutter** 3.x
- **Dart**
- **Google Fonts**
- **Mask Text Input Formatter**
- **country_icons** para bandeiras
- Design responsivo e modular com widgets reutilizáveis

## 📂 Estrutura do projeto

```
lib/
├── components/
│   ├── custom_app_bar.dart
│   ├── custom_bottom_nav_bar.dart
├── pages/
│   ├── login_page.dart
│   ├── create_account_page.dart
│   ├── account_lost_page.dart
│   ├── dashboard_page.dart
│   ├── profile_page.dart
├── main.dart
```

## 🚀 Como rodar o projeto

1. Clone o repositório:
   ```bash
   git clone https://github.com/seu-usuario/nutrixpert.git
   cd nutrixpert
   ```

2. Instale as dependências:
   ```bash
   flutter pub get
   ```

3. Execute o app:
   ```bash
   flutter run
   ```

## 📦 Dependências principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  google_fonts: ^6.1.0
  mask_text_input_formatter: ^2.5.0
  country_icons: ^2.0.0
```

## 📌 TODO

- [ ] Integração com backend (Firebase ou API REST)
- [ ] Cadastro de metas nutricionais
- [ ] Inteligência artificial para sugestões automáticas

---

**NutriXpert** – Seu app expert em nutrição 💜
