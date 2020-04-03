package com.lab.fcmcallerapp;

import android.app.Notification;
import android.app.NotificationChannel;
import android.app.NotificationManager;
import android.app.PendingIntent;
import android.app.Service;
import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.os.IBinder;
import android.widget.RemoteViews;

import androidx.annotation.Nullable;
import androidx.core.app.NotificationCompat;

import static com.lab.fcmcallerapp.CallingActivity.CALL_ANSWER;
import static com.lab.fcmcallerapp.CallingActivity.CALL_COMMAND_KEY;
import static com.lab.fcmcallerapp.CallingActivity.CALL_DEFAULT;
import static com.lab.fcmcallerapp.CallingActivity.CALL_DISMISS;


/**
 * @author Konstantin Epifanov
 * @since 28.02.2020
 */
public class ForegroundService extends Service {
  public static final String CHANNEL_ID = "ForegroundServiceChannel";
  private AudioPlayer audioPlayer = new AudioPlayer();

  @Override
  public void onCreate() {
    super.onCreate();
  }

  @Override
  public int onStartCommand(Intent intent, int flags, int startId) {
    registerForegroundChannel(this);

    RemoteViews remote = new RemoteViews(getPackageName(), R.layout.notification_call);
    remote.setTextViewText(R.id.title, intent.getStringExtra("title"));
    remote.setTextViewText(R.id.message, intent.getStringExtra("body"));

    remote.setOnClickPendingIntent(R.id.dismiss, obtainIntent(this, CALL_DISMISS));
    remote.setOnClickPendingIntent(R.id.answer, obtainIntent(this, CALL_ANSWER));

    Notification notification = new NotificationCompat.Builder(this, CHANNEL_ID)
      .setCustomContentView(remote)
      .setSmallIcon(R.drawable.ic_launcher_foreground)
      .setPriority(NotificationCompat.PRIORITY_HIGH)
      .setCategory(NotificationCompat.CATEGORY_CALL)
      .setFullScreenIntent(obtainIntent(this, CALL_DEFAULT), true)
      .build();
    startForeground(999, notification);
    Utils.startActivity2(this, CallingActivity.class);

    audioPlayer.play(this, R.raw.simple_bell_7);

    return START_NOT_STICKY;
  }

  static PendingIntent obtainIntent(Context context, int code) {
    Intent intent = new Intent(context, CallingActivity.class);
    Bundle bundle = new Bundle();
    bundle.putInt(CALL_COMMAND_KEY, code);
    return PendingIntent.getActivity(context, 0, intent, PendingIntent.FLAG_CANCEL_CURRENT, bundle);
  }

  @Override
  public void onDestroy() {
    audioPlayer.stop();
    super.onDestroy();
  }

  @Nullable
  @Override
  public IBinder onBind(Intent intent) {
    return null;
  }


  static void registerForegroundChannel(Context context) {
    NotificationChannel serviceChannel = new NotificationChannel(CHANNEL_ID,
      "Foreground Service Channel",
      NotificationManager.IMPORTANCE_DEFAULT
    );

    NotificationManager manager = context.getSystemService(NotificationManager.class);
    manager.createNotificationChannel(serviceChannel);
  }

}