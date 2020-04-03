package com.lab.fcmcallerapp.utils;

import android.content.Context;
import android.content.Intent;

import com.google.firebase.iid.FirebaseInstanceId;
import com.lab.fcmcallerapp.services.CallFgService;

/**
 * @author Konstantin Epifanov
 * @since 28.02.2020
 */
public class CommonUtils {

  public static void stopForegroundService(Context context) {
    context.stopService(new Intent(context, CallFgService.class));
  }

  public static void startActivity(Context context, Class activityClass) {
    Intent intent = new Intent(context, activityClass);
    intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
    intent.addFlags(Intent.FLAG_ACTIVITY_SINGLE_TOP);
    context.startActivity(intent);
  }

  public static void logCurrentFcmToken() {
    FirebaseInstanceId.getInstance().getInstanceId()
      .addOnCompleteListener(task -> {
        if (!task.isSuccessful()) {
          System.out.println("@@@@@ getFcmToken - failed");
          return;
        }

        // Get new Instance ID token
        String token = task.getResult().getToken();
        System.out.println("@@@@@ getFcmToken: " + token);
      });
  }
}
