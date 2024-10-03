import 'package:flutter/widgets.dart';

class AspectListenableBuilder<T extends Listenable, K> extends StatefulWidget {
  final T listenable;
  final K Function(T listenable) aspect;
  final bool Function(K previous, K current)? buildWhen;
  final ValueWidgetBuilder<K> builder;
  final Widget? child;

  const AspectListenableBuilder({
    super.key,
    required this.listenable,
    required this.aspect,
    required this.builder,
    this.child,
    this.buildWhen,
  });

  @override
  State<AspectListenableBuilder<T, K>> createState() =>
      _AspectListenableBuilderState<T, K>();
}

class _AspectListenableBuilderState<T extends Listenable, K>
    extends State<AspectListenableBuilder<T, K>> {
  late K _value;

  @override
  void initState() {
    super.initState();
    _value = widget.aspect(widget.listenable);
    widget.listenable.addListener(_listener);
  }

  @override
  void didUpdateWidget(AspectListenableBuilder<T, K> oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (oldWidget.listenable != widget.listenable) {
      oldWidget.listenable.removeListener(_listener);
      widget.listenable.addListener(_listener);
      _value = widget.aspect(widget.listenable);
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(
      context,
      _value,
      widget.child,
    );
  }

  @override
  void dispose() {
    super.dispose();

    widget.listenable.removeListener(_listener);
  }

  void _listener() {
    final previous = _value;
    final current = widget.aspect(widget.listenable);

    final willBuild = widget.buildWhen?.call(previous, current) ?? true;

    if (!willBuild) return;

    setState(() => _value = current);
  }
}
