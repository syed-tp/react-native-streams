package com.streams

import android.graphics.Color
import com.facebook.react.module.annotations.ReactModule
import com.facebook.react.uimanager.SimpleViewManager
import com.facebook.react.uimanager.ThemedReactContext
import com.facebook.react.uimanager.ViewManagerDelegate
import com.facebook.react.uimanager.annotations.ReactProp
import com.facebook.react.viewmanagers.StreamsViewManagerInterface
import com.facebook.react.viewmanagers.StreamsViewManagerDelegate

@ReactModule(name = StreamsViewManager.NAME)
class StreamsViewManager : SimpleViewManager<StreamsView>(),
  StreamsViewManagerInterface<StreamsView> {
  private val mDelegate: ViewManagerDelegate<StreamsView>

  init {
    mDelegate = StreamsViewManagerDelegate(this)
  }

  override fun getDelegate(): ViewManagerDelegate<StreamsView>? {
    return mDelegate
  }

  override fun getName(): String {
    return NAME
  }

  public override fun createViewInstance(context: ThemedReactContext): StreamsView {
    return StreamsView(context)
  }

  @ReactProp(name = "color")
  override fun setColor(view: StreamsView?, color: String?) {
    view?.setBackgroundColor(Color.parseColor(color))
  }

  companion object {
    const val NAME = "StreamsView"
  }
}
