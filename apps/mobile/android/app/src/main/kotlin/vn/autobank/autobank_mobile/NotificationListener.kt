package vn.autobank.autobank_mobile

import android.app.Notification
import android.content.Intent
import android.service.notification.NotificationListenerService
import android.service.notification.StatusBarNotification
import android.util.Log
import androidx.localbroadcastmanager.content.LocalBroadcastManager

class NotificationListener : NotificationListenerService() {
    override fun onNotificationPosted(sbn: StatusBarNotification) {
        val packageName = sbn.packageName
        val notification = sbn.notification
        val extras = notification.extras
        
        val title = extras.getString(Notification.EXTRA_TITLE) ?: ""
        val text = extras.getCharSequence(Notification.EXTRA_TEXT)?.toString() ?: ""

        // Check for specific banks (e.g., MB Bank, VCB)
        // You can add more package names here
        if (packageName.contains("mbmobile") || packageName.contains("vietcombank")) {
            Log.d("AutoBank", "Bank Notification received: $title - $text")
            
            // Broadcast the notification to the Flutter MainActivity
            val intent = Intent("vn.autobank.NOTIFICATION")
            intent.putExtra("title", title)
            intent.putExtra("text", text)
            intent.putExtra("package", packageName)
            LocalBroadcastManager.getInstance(this).sendBroadcast(intent)
        }
    }

    override fun onNotificationRemoved(sbn: StatusBarNotification) {
        // Not used
    }
}
