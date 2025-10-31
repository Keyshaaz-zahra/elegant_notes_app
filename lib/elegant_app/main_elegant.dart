import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme.dart';
import 'providers/note_provider.dart';
import 'pages/home_page.dart';
import 'pages/add_note_page.dart';

void main() {
  runApp(const ElegantNotesApp());
}

class ElegantNotesApp extends StatelessWidget {
  const ElegantNotesApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (context) => NoteProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Elegant Notes',
        themeMode: ThemeMode.system, // 🌗 Otomatis light/dark
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        initialRoute: '/',
        routes: {
          '/': (context) => const HomePage(),
          '/add-note': (context) => const AddNotePage(),
        },
        // ✨ Transisi animasi antar halaman (fade + slide)
        onGenerateRoute: (settings) {
          if (settings.name == '/add-note') {
            return PageRouteBuilder(
              pageBuilder: (_, __, ___) => const AddNotePage(),
              transitionsBuilder: (_, animation, __, child) {
                const begin = Offset(0.0, 0.1);
                const end = Offset.zero;
                const curve = Curves.easeInOut;
                var tween = Tween(begin: begin, end: end)
                    .chain(CurveTween(curve: curve));
                return FadeTransition(
                  opacity: animation,
                  child: SlideTransition(
                    position: animation.drive(tween),
                    child: child,
                  ),
                );
              },
            );
          }
          return null;
        },
      ),
    );
  }
}
