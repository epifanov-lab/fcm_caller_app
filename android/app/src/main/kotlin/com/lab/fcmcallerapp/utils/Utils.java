package com.lab.fcmcallerapp.utils;

import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.content.Context;
import android.content.Intent;
import android.graphics.Color;

import com.lab.fcmcallerapp.R;
import com.lab.fcmcallerapp.services.ForegroundService;

/**
 * @author Konstantin Epifanov
 * @since 28.02.2020
 */
public class Utils {

  public static void stopForegroundService(Context context) {
    context.stopService(new Intent(context, ForegroundService.class));
  }

  public static void startActivity2(Context context, Class activityClass) {
    Intent intent = new Intent(context, activityClass);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
    context.startActivity(intent);
  }

  public static void registerSpecialNotificationChannel(Context context) {
    NotificationManager manager = (NotificationManager) context.getSystemService(Context.NOTIFICATION_SERVICE);
    String channelId = context.getString(R.string.notification_channel_special_id);

    int importance = NotificationManager.IMPORTANCE_HIGH;

    NotificationChannel channel = new NotificationChannel(channelId, "channel_" + channelId, importance);
    channel.enableLights(true);
    channel.setLightColor(Color.RED);
    channel.enableVibration(true);
    channel.setVibrationPattern(new long[]{100, 200, 300, 400, 500, 400, 300, 200, 400});

    manager.createNotificationChannel(channel);
  }

}
