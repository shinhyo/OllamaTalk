import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'base_cubit.dart';

abstract class BaseScreen<T extends BaseCubit> extends StatelessWidget {
  const BaseScreen({super.key});

  @protected
  T createViewModel(BuildContext context);

  @protected
  Widget buildScaffold(BuildContext context);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: createViewModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: buildScaffold(context),
      ),
    );
  }
}

abstract class BaseStatefulScreen<T extends BaseCubit> extends StatefulWidget {
  const BaseStatefulScreen({super.key});

  @protected
  T createViewModel(BuildContext context);

  @protected
  Widget buildScaffold(BuildContext context);

  @override
  State<BaseStatefulScreen<T>> createState() => _BaseStatefulScreenState<T>();
}

class _BaseStatefulScreenState<T extends BaseCubit>
    extends State<BaseStatefulScreen<T>> {
  late T _viewModel;

  @override
  void initState() {
    super.initState();
    _viewModel = widget.createViewModel(context);
  }

  @override
  void dispose() {
    _viewModel.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => _viewModel,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: widget.buildScaffold(context),
      ),
    );
  }
}
