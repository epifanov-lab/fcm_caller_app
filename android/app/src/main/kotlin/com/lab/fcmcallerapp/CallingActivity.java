package com.lab.fcmcallerapp;

import android.app.Activity;
import android.app.KeyguardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;

import com.google.firebase.iid.FirebaseInstanceId;
import com.lab.fcmcallerapp.utils.Utils;

public class CallingActivity extends Activity {

  public static final String CALL_COMMAND_KEY = "command";

  public static final int CALL_DEFAULT = 0;
  public static final int CALL_DISMISS = -1;
  public static final int CALL_ANSWER = 1;

  @Override
  protected void onCreate(Bundle savedInstanceState) {
    super.onCreate(savedInstanceState);

    if (Build.VERSION.SDK_INT >= Build.VERSION_CODES.O_MR1) {
      setShowWhenLocked(true);
      setTurnScreenOn(true);
      KeyguardManager keyguardManager = (KeyguardManager) getSystemService(Context.KEYGUARD_SERVICE);
      if (keyguardManager != null) keyguardManager.requestDismissKeyguard(this, null);
    } else {
      getWindow().addFlags(WindowManager.LayoutParams.FLAG_DISMISS_KEYGUARD |
        WindowManager.LayoutParams.FLAG_SHOW_WHEN_LOCKED |
        WindowManager.LayoutParams.FLAG_TURN_SCREEN_ON);
    }

    setContentView(R.layout.activity_caller);

    findViewById(R.id.dismiss).setOnClickListener((v) -> dismiss());
    findViewById(R.id.answer).setOnClickListener((v) -> answer());

    getFcmToken();
  }

  private void answer() {
    Utils.startActivity2(this, FlutterAppActivity.class);
    dismiss();
  }

  private void dismiss() {
    Utils.stopForegroundService(this);
    finish();
  }

  @Override
  protected void onNewIntent(Intent intent) {
    System.out.println("onNewIntent: " + intent);
      int command = intent.getIntExtra("command", CALL_DEFAULT);
      System.out.println("onNewIntent: " + intent + " " + command);
      switch (command) {
        case CALL_ANSWER: answer(); break;
        case CALL_DISMISS: dismiss(); break;
        default: break;
      }
    super.onNewIntent(intent);
  }

  private void getFcmToken() {
    FirebaseInstanceId.getInstance().getInstanceId()
      .addOnCompleteListener(task -> {
        if (!task.isSuccessful()) {
          System.out.println("CallingActivity getFcmToken - failed");
          return;
        }

        // Get new Instance ID token
        String token = task.getResult().getToken();
        System.out.println("CallingActivity.getFcmToken: " + token);
      });
  }

}