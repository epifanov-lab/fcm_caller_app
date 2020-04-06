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
    System.out.println("@@@@@ a.FcmService.onMessageReceived: " + message);

    if (message.getData().size() > 0) {
      System.out.println("@@@@@ a.Message data payload: " + message.getData());
      startCallFgService(message.getData());
    }

    if (message.getNotification() != null) {
      System.out.println("@@@@@ a.Message Notification Body: " + message.getNotification().getBody());
    }
  }

  @Override
  public void onNewToken(@NonNull String s) {
    super.onNewToken(s);
    System.out.println("@@@@@ a.FcmService.onNewToken: " + s);
  }

  private void startCallFgService(Map<String, String> data) {
    System.out.println("@@@@@ a.FcmService.startCallFgService");
    Intent intent = new Intent(this, CallFgService.class);
    intent.putExtra("title", data.get("title"));
    intent.putExtra("body", data.get("body"));
    ContextCompat.startForegroundService(this, intent);
  }

}
