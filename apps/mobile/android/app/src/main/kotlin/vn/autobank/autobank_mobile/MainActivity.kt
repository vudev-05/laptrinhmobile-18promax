package vn.autobank.autobank_mobile

import android.content.BroadcastReceiver
import android.content.Context
import android.content.Intent
import android.content.IntentFilter
import android.provider.Settings
import androidx.annotation.NonNull
import androidx.localbroadcastmanager.content.LocalBroadcastManager
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.EventChannel
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    private val EVENT_CHANNEL = "vn.autobank.mobile/notifications"
    private val METHOD_CHANNEL = "vn.autobank.mobile/permissions"
    
    private var eventSink: EventChannel.EventSink? = null

    private val notificationReceiver = object : BroadcastReceiver() {
        override fun onReceive(context: Context?, intent: Intent?) {
            if (intent?.action == "vn.autobank.NOTIFICATION") {
                val title = intent.getStringExtra("title") ?: ""
                val text = intent.getStringExtra("text") ?: ""
                val packageName = intent.getStringExtra("package") ?: ""
                
                val notificationData = mapOf(
                    "title" to title,
                    "text" to text,
                    "package" to packageName
                )
                
                eventSink?.success(notificationData)
            }
        }
    }

    override fun configureFlutterEngine(@NonNull flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        
        // Setup MethodChannel for checking/requesting permissions
        MethodChannel(flutterEngine.dartExecutor.binaryMessenger, METHOD_CHANNEL).setMethodCallHandler { call, result ->
            if (call.method == "isNotificationListenerEnabled") {
                val enabled = Settings.Secure.getString(contentResolver, "enabled_notification_listeners").contains(packageName)
                result.success(enabled)
            } else if (call.method == "openNotificationListenerSettings") {
                startActivity(Intent("android.settings.ACTION_NOTIFICATION_LISTENER_SETTINGS"))
                result.success(true)
            } else {
                result.notImplemented()
            }
        }

        // Setup EventChannel for streaming notifications to Flutter
        EventChannel(flutterEngine.dartExecutor.binaryMessenger, EVENT_CHANNEL).setStreamHandler(
            object : EventChannel.StreamHandler {
                override fun onListen(arguments: Any?, events: EventChannel.EventSink?) {
                    eventSink = events
                    LocalBroadcastManager.getInstance(this@MainActivity)
                        .registerReceiver(notificationReceiver, IntentFilter("vn.autobank.NOTIFICATION"))
                }

                override fun onCancel(arguments: Any?) {
                    eventSink = null
                    LocalBroadcastManager.getInstance(this@MainActivity)
                        .unregisterReceiver(notificationReceiver)
                }
            }
        )
    }
}
