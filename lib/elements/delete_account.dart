import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:moonlinks/api/auth_service.dart';
import 'package:moonlinks/api/pay.dart';
import 'package:moonlinks/functions/secure_storage.dart';
import 'package:moonlinks/l10n/app_localizations.dart';
import 'package:moonlinks/main.dart';
import 'package:moonlinks/menu/utils/menu_provider.dart';
import 'package:moonlinks/utils/cart_riverpod.dart';
import 'package:moonlinks/utils/subscribed_services_riverpod.dart';

class DeleteAccount extends ConsumerStatefulWidget {
  const DeleteAccount({super.key});

  @override
  ConsumerState<DeleteAccount> createState() => _DeleteAccountState();
}

class _DeleteAccountState extends ConsumerState<DeleteAccount> {
  final payAPI = Pay();
  bool _isLoading = false;

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        icon: const Icon(Icons.warning_amber_rounded,
            color: Colors.red, size: 48),
        title: Text(
          AppLocalizations.of(context)!.delete_account_title,
          style: const TextStyle(
            color: Colors.red,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        content: Text(
          AppLocalizations.of(context)!.delete_account_warning,
          style: const TextStyle(color: Colors.black87),
          textAlign: TextAlign.center,
        ),
        actionsAlignment: MainAxisAlignment.center,
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(
              AppLocalizations.of(context)!.cancel,
              style: const TextStyle(color: Colors.black54),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: _isLoading
                ? null
                : () async {
                    setState(() => _isLoading = true);
                    try {
                      await payAPI.deleteAccount();
                      if (context.mounted) {
                        Navigator.pop(context);
                        await logout();
                      }
                    } catch (e) {
                      if (context.mounted) {
                        Navigator.pop(context);
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text(
                              AppLocalizations.of(context)!
                                  .delete_account_error,
                            ),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    } finally {
                      if (mounted) setState(() => _isLoading = false);
                    }
                  },
            child: Text(AppLocalizations.of(context)!.delete_account_confirm),
          ),
        ],
      ),
    );
  }

  Future<void> logout() async {
    final token = await readToken();
    if (token != null && token.isNotEmpty) {
      await AuthService().logout(token);
    }
    await deleteToken();
    ref.read(subServicesProvider.notifier).removeAll();
    await ref.read(menuProvider.notifier).resetAll();
    ref.read(cartProvider.notifier).removeAll();
    if (context.mounted) {
      // ← add this check
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Main()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.red,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      onPressed: _confirmDelete,
      icon: const Icon(Icons.delete_forever),
      label: Text(
        AppLocalizations.of(context)!.delete_account_button,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
      ),
    ));
  }
}
