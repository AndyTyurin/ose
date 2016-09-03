part of ose;

class RendererLifecycleControllers {
  /// Stream controller for [_onStart] stream.
  final StreamController<StartEvent> onStartCtrl;

  /// Stream controller for [_onStop] stream.
  final StreamController<StopEvent> onStopCtrl;

  /// Stream controller for [_onRender] stream.
  final StreamController<RenderEvent> onRenderCtrl;

  /// Stream controller for [_onPostRender] stream.
  final StreamController<PostRenderEvent> onPostRenderCtrl;

  /// Stream controller for [_onObjectRender] stream.
  final StreamController<ObjectRenderEvent> onObjectRenderCtrl;

  /// Stream controller for [_onObjectPostRender] stream.
  final StreamController<ObjectPostRenderEvent> onObjectPostRenderCtrl;

  RendererLifecycleControllers()
      : onStartCtrl = new StreamController<StartEvent>(),
        onStopCtrl = new StreamController<StopEvent>(),
        onRenderCtrl = new StreamController<RenderEvent>(),
        onPostRenderCtrl = new StreamController<PostRenderEvent>(),
        onObjectRenderCtrl = new StreamController<ObjectRenderEvent>(),
        onObjectPostRenderCtrl = new StreamController<ObjectPostRenderEvent>();
}
