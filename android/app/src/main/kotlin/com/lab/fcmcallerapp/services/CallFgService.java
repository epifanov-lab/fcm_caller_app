package com.lab.fcmcallerapp.services;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import com.lab.fcmcallerapp.CallReceiveActivity;
import com.lab.fcmcallerapp.FlutterAppActivity;
import com.lab.fcmcallerapp.R;
import com.lab.fcmcallerapp.utils.AudioManager;
import com.lab.fcmcallerapp.utils.CommonUtils;

import static com.lab.fcmcallerapp.CallReceiveActivity.CALL_COMMAND_KEY;
import static com.lab.fcmcallerapp.CallReceiveActivity.CALL_DEFAULT;


/**
 * @author Konstantin Epifanov
 * @since 28.02.2020
 */
public class CallFgService extends Service {
  public static final String CHANNEL_ID = "calls";

  @Override
  public void onCreate() {
    super.onCreate();
  }

  @Override
  public int onStartCommand(Intent intent, int flags, int startId) {
    System.out.println("@@@@@ a.CallFgService.onStartCommand");

    registerPushAwakeChannel(this);

    String name = intent.getStringExtra("name");
    String body = intent.getStringExtra("body");

    Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
      .setContentTitle(name)
      .setContentText(body)
      .setSmallIcon(R.drawable.ic_launcher_foreground)
      .setPriority(NotificationCompat.PRIORITY_HIGH)
      .setCategory(NotificationCompat.CATEGORY_CALL)
      .setFullScreenIntent(obtainIntent(this, CALL_DEFAULT, intent), true)
      .build();

    startForeground(999, notification);

    CommonUtils.startActivity(this, FlutterAppActivity.class, intent);

    AudioManager.get().play(this, R.raw.simple_bell_7, 0.75f);

    return START_NOT_STICKY;
  }

  private static PendingIntent obtainIntent(Context context, int code, Intent transitIntent) {
    Intent intent = new Intent(context, FlutterAppActivity.class);
    Bundle bundle = new Bundle();
    bundle.putInt(CALL_COMMAND_KEY, code);
    transitIntent.getExtras().keySet()
      .forEach((key) -> intent.putExtra(key, transitIntent.getStringExtra(key)));
    return PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT, bundle);
  }

  @Override
  public void onDestroy() {
    AudioManager.get().stop();
    super.onDestroy();
  }

  @Nullable
  @Override
  public IBinder onBind(Intent intent) {
    return null;
  }


  public static void registerPushAwakeChannel(Context context) {
    //TODO NOTIFICATIONS CHANNELS

    NotificationChannel serviceChannel = new NotificationChannel(
      CHANNEL_ID, "Foreground Service Channel",
      NotificationManager.IMPORTANCE_HIGH
    );

    NotificationManager manager = context.getSystemService(NotificationManager.class);
    manager.createNotificationChannel(serviceChannel);
  }

}