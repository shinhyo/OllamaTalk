import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../config/dependencies.dart';
import '../../../i18n/strings.g.dart';
import '../../core/themes/colors.dart';
import '../../core/themes/theme_ext.dart';
import '../../core/widget/dialog.dart';
import 'setting_viewmodel.dart';

class SettingScreen extends StatelessWidget {
  const SettingScreen({super.key});

  static const label = 'Setting';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<SettingViewmodel>(),
        child: BlocConsumer<SettingViewmodel, UiState>(
          listener: (BuildContext context, UiState state) {},
          builder: (context, state) {
            if (state.isLoading) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            final textStyle = context.textTheme.bodyMedium?.copyWith(
              color: AppColors.grey,
            );
            return ListView(
              children: [
                _buildHeader(context, title: t.settings.headerOllama),
                _buildSettingItem(
                  context,
                  icon: Icons.link,
                  title: t.settings.serverUrlLabel,
                  trailing: state.baseUrl == null
                      ? null
                      : Text(
                          state.baseUrl!,
                          style: textStyle,
                        ),
                  onTap: () => _showServerUrlDialog(
                    context,
                    serverUrl: state.baseUrl!,
                    onConfirm: (value) {
                      context.read<SettingViewmodel>().updateBaseUrl(value);
                    },
                  ),
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.link,
                  title: t.settings.connectionStatusLabel,
                  trailing: state.uiError != null
                      ? Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.refresh_outlined,
                              color: AppColors.red,
                            ),
                            const SizedBox(width: 4),
                            Text(
                              t.settings.connectionStatusUnavailable,
                              style: textStyle?.copyWith(
                                color: AppColors.red,
                              ),
                            ),
                          ],
                        )
                      : Text(
                          t.settings.connectionStatusConnected,
                          style: textStyle?.copyWith(
                            color: AppColors.grey,
                          ),
                        ),
                  onTap: () => {context.read<SettingViewmodel>().refresh()},
                ),
                _buildHeader(context, title: t.settings.headerApp),
                _buildSettingItem(
                  context,
                  icon: Icons.palette_outlined,
                  title: t.settings.themeLabel,
                  trailing: Text(
                    state.themeMode,
                    style: textStyle,
                  ),
                  onTap: () {
                    _showThemeModeDialog(
                      context,
                      themeList: state.themeModeList,
                      themeMode: state.themeMode,
                      onConfirm: (String value) {
                        context.read<SettingViewmodel>().updateThemeMode(value);
                      },
                    );
                  },
                ),
                _buildSettingItem(
                  context,
                  icon: Icons.new_releases_outlined,
                  title: t.settings.versionLabel,
                  trailing: state.appVersion == null
                      ? null
                      : Text(state.appVersion!, style: textStyle),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildHeader(
    BuildContext context, {
    required String title,
    Widget? trailing,
  }) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 8),
      child: Container(
        padding: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: AppColors.grey.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            Text(
              title,
              style: context.textTheme.titleSmall?.copyWith(
                color: AppColors.grey,
                fontWeight: FontWeight.w600,
              ),
            ),
            const Spacer(),
            if (trailing != null) trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildSettingItem(
    BuildContext context, {
    IconData? icon,
    required String title,
    String? subTitle,
    Widget? trailing,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      child: ListTile(
        // leading: Icon(icon),
        title: Text(
          title,
          style: context.textTheme.bodyMedium,
        ),
        subtitle: subTitle == null
            ? null
            : Text(
                subTitle,
                style: context.textTheme.bodySmall?.copyWith(
                  color: AppColors.grey,
                ),
              ),
        trailing: trailing,
        onTap: onTap,
      ),
    );
  }

  void _showServerUrlDialog(
    BuildContext context, {
    required String serverUrl,
    required ValueChanged<String> onConfirm,
  }) {
    final controller = TextEditingController(text: serverUrl);
    showAppDialog(
      context: context,
      title: t.settings.serverUrlLabel,
      content: TextField(
        controller: controller,
        decoration: InputDecoration(
          hintText: serverUrl,
          helperText: t.settings.serverUrlHint,
        ),
      ),
      onConfirm: () {
        final url = controller.text;
        if (url.isNotEmpty) onConfirm(url);
      },
    );
  }

  void _showThemeModeDialog(
    BuildContext context, {
    required List<String> themeList,
    required String themeMode,
    required ValueChanged<String> onConfirm,
  }) {
    showAppDialog(
      context: context,
      title: t.settings.themeDialogTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: themeList.map((mode) {
          return RadioListTile<String>(
            title: Text(mode),
            value: mode,
            groupValue: themeMode,
            onChanged: (String? value) {
              if (value == null) return;
              onConfirm(value);
              context.pop();
            },
          );
        }).toList(),
      ),
      // onConfirm: onConfirm,
    );
  }
}
