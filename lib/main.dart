import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../core/app_export.dart';
import '../widgets/custom_error_widget.dart';

/// ===============================================================
/// RIVERPOD x SUPABASE — PROVIDERS (v3)
/// ===============================================================

/// 1) Akses client Supabase secara terpusat via provider
final supabaseClientProvider = Provider<SupabaseClient>(
  (ref) => Supabase.instance.client,
);

/// 2) Stream session Supabase (akan emit setiap ada perubahan auth)
///    - event/session: dari Supabase
///    - kita expose hanya Session? agar mudah dikonsumsi UI
final sessionStreamProvider = StreamProvider<Session?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  // v2+ supabase_flutter: onAuthStateChange -> Stream<AuthState>
  // AuthState punya field .session (Session?)
  return client.auth.onAuthStateChange.map((authState) => authState.session);
});

/// 3) Snapshot session saat ini (sekali baca)
final currentSessionProvider = Provider<Session?>((ref) {
  final client = ref.watch(supabaseClientProvider);
  return client.auth.currentSession;
});

/// (Opsional) Observer untuk debug perubahan provider
final class AppRiverpodObserver extends ProviderObserver {
  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    // contoh logging sederhana:
    debugPrint(
      '[riverpod] ${context.provider} -> $newValue (prev: $previousValue)',
    );

    // Kalau mau akses name:
    // context.provider is a ProviderListenable
    // name dapat diambil via context.provider.runtimeType atau apabila
    // kamu memberi "name" pada provider saat deklarasi, gunakan itu.
  }

  // (opsional) override lain yang valid di v3:
  // @override
  // void didAddProvider(ProviderObserverContext context, Object? value) {}
  //
  // @override
  // void didDisposeProvider(ProviderObserverContext context, Object? value) {}
}

/// ===============================================================
/// ENTRYPOINT
/// ===============================================================

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 🚨 CRITICAL: Custom error handling - DO NOT REMOVE
  ErrorWidget.builder = (FlutterErrorDetails details) {
    return CustomErrorWidget(
      errorDetails: details,
    );
  };

  // 🚨 CRITICAL: Device orientation lock - DO NOT REMOVE
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);

  // 🚨 CRITICAL: Supabase initialize
  await Supabase.initialize(
    url: 'https://kttusitwmhdpnjwtqfgn.supabase.co',
    anonKey: 'sb_publishable_l7bUvCpymXmhQj3VEYd3rg_1S8iU42Q',
  );

  runApp(
    ProviderScope(
      observers: [AppRiverpodObserver()],
      child: const MyApp(),
    ),
  );
}

/// ===============================================================
/// APP ROOT — pakai ConsumerWidget agar bisa watch provider
/// ===============================================================
class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // 1) Dengar perubahan session (login/logout)
    final sessionAsync = ref.watch(sessionStreamProvider);
    // 2) Ambil currentSession sekali untuk fallback saat stream masih loading
    final currentSession = ref.watch(currentSessionProvider);

    // Nilai session final yang dipakai saat build:
    // - bila stream sudah punya data -> pakai itu
    // - kalau belum (loading) -> fallback ke currentSession (bisa null)
    final session = sessionAsync.maybeWhen(
      data: (s) => s,
      orElse: () => currentSession,
    );

    return Sizer(
      builder: (context, orientation, screenType) {
        return MaterialApp(
          title: 'pedulipanganv1',
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: ThemeMode.light,

          // 🚨 CRITICAL: NEVER REMOVE OR MODIFY
          builder: (context, child) {
            return MediaQuery(
              data: MediaQuery.of(context).copyWith(
                textScaler: const TextScaler.linear(1.0),
              ),
              child: child!,
            );
          },
          // 🚨 END CRITICAL SECTION

          debugShowCheckedModeBanner: false,
          routes: AppRoutes.routes,

          /// Anda punya dua opsi untuk routing:
          /// A) Tetap pakai initial bawaan (tidak peduli session)
          /// B) Gate by session: arahkan ke login/home tergantung session
          ///
          /// Di bawah ini contoh B (AuthGate) yang memilih layar awal
          /// berdasar session. Kalau ingin tetap pakai AppRoutes.initial,
          /// ganti 'home:' menjadi 'initialRoute: AppRoutes.initial,'.

          home: AuthGate(
            isLoggedIn: session != null,
            loading: sessionAsync.isLoading && currentSession == null,
          ),
        );
      },
    );
  }
}

/// ===============================================================
/// AUTH GATE — pilih halaman awal berdasar status login
/// - loading: tampilkan splash kecil
/// - logged out: arahkan ke rute login
/// - logged in : arahkan ke rute home
/// ===============================================================
class AuthGate extends StatelessWidget {
  const AuthGate({
    super.key,
    required this.isLoggedIn,
    required this.loading,
  });

  final bool isLoggedIn;
  final bool loading;

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    // NB: Sesuaikan nama rute ini dengan rute di AppRoutes.routes kamu.
    final loggedInRoute = '/home-screen';
    final loggedOutRoute = '/login';

    // MaterialApp butuh widget, jadi kita pakai Navigator untuk redirect
    // dengan Future.microtask agar tidak push saat build berjalan.
    Future.microtask(() {
      final target = isLoggedIn ? loggedInRoute : loggedOutRoute;
      if (ModalRoute.of(context)?.settings.name != target) {
        Navigator.of(context).pushNamedAndRemoveUntil(target, (r) => false);
      }
    });

    // sementara tampilkan splash kosong
    return const Scaffold(body: SizedBox.shrink());
  }
}

/// ===============================================================
/// EXTENSIONS
/// ===============================================================
extension ContextExtension on BuildContext {
  void showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(this).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError
            ? Theme.of(this).colorScheme.error
            : Theme.of(this).snackBarTheme.backgroundColor,
      ),
    );
  }
}
