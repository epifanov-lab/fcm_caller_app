package com.lab.fcmcallerapp.services;

import android.content.Intent;

import androidx.annotation.NonNull;
import androidx.core.content.ContextCompat;

import com.google.firebase.messaging.FirebaseMessagingService;
import com.google.firebase.messaging.RemoteMessage;

import java.util.Map;

/**
 * @author Konstantin Epifanov
 * @since 28.02.2020
 */
public class FcmService extends FirebaseMessagingService {

  @Override
  public void onMessageReceived(@NonNull RemoteMessage message) {
    super.onMessageReceived(message);
    System.out.println("FcmService.onMessageReceived: " + message);

    if (message.getData().size() > 0) {
      System.out.println("Message data payload: " + message.getData());
      startForegroundService(message.getData());
    }

    if (message.getNotification() != null) {
      System.out.println("Message Notification Body: " + message.getNotification().getBody());
    }
  }

  @Override
  public void onNewToken(@NonNull String s) {
    super.onNewToken(s);
    System.out.println("FcmService.onNewToken: " + s);
  }

  private void startForegroundService(Map<String, String> data) {
    Intent serviceIntent = new Intent(this, ForegroundService.class);
    serviceIntent.putExtra("title", data.get("title"));
    serviceIntent.putExtra("body", data.get("body"));
    ContextCompat.startForegroundService(this, serviceIntent);
  }

}
