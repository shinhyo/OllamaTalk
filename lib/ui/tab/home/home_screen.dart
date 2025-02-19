import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../config/dependencies.dart';
import '../../../i18n/strings.g.dart';
import '../../core/base/base_screen.dart';
import '../../core/base/max_width_container.dart';
import '../../core/themes/icons.dart';
import '../../core/themes/theme_ext.dart';
import '../../routing/router.dart';
import 'home_viewmodel.dart';
import 'widget/home_input_text.dart';
import 'widget/home_tool_bar.dart';

class HomeScreen extends BaseStatefulScreen<HomeViewModel> {
  const HomeScreen({super.key});

  static const label = 'New Chat';

  @override
  HomeViewModel createViewModel(BuildContext context) {
    return getIt<HomeViewModel>();
  }

  @override
  Widget buildScaffold(BuildContext context) {
    return BlocListener<HomeViewModel, UiState>(
      listenWhen: (previous, current) =>
          previous.navigateChatScreen != current.navigateChatScreen,
      listener: (context, state) {
        final toolbarState = state.toolbar;
        if (state.navigateChatScreen != null &&
            state.currentInput.isNotEmpty &&
            toolbarState.prompt != null) {
          ChatScreenRoute(
            question: state.navigateChatScreen,
            model: toolbarState.models[toolbarState.modelIdx],
            chatMode: toolbarState.chatModes[toolbarState.chatModeIdx],
            prompt: toolbarState.prompt,
          ).push(context);
          context.read<HomeViewModel>().clearNavigate();
        }
      },
      child: Scaffold(
        body: Center(
          child: ScrollConfiguration(
            behavior: ScrollConfiguration.of(context).copyWith(
              scrollbars: false,
            ),
            child: SingleChildScrollView(
              primary: false,
              child: MaxWidthContainer(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    context.icon(AppIcons.robot, size: 60),
                    const SizedBox(height: 10),
                    Text(
                      t.home.know,
                      style: context.textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 40),
                    const HomeInputField(),
                    const ChipToolBar(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
