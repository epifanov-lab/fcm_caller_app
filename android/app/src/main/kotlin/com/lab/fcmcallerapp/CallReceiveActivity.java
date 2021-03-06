package com.lab.fcmcallerapp;

import android.app.Activity;
import android.app.KeyguardManager;
import android.content.Context;
import android.content.Intent;
import android.os.Build;
import android.os.Bundle;
import android.view.WindowManager;
import android.widget.TextView;

import com.lab.fcmcallerapp.utils.CommonUtils;

public class CallReceiveActivity extends Activity {

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

    String userName = getIntent().getStringExtra("userName");
    String body = getIntent().getStringExtra("body");

    ((TextView) findViewById(R.id.tv_caller)).setText(userName);

    findViewById(R.id.btn_dismiss).setOnClickListener((v) -> dismiss());
    findViewById(R.id.btn_answer).setOnClickListener((v) -> answer());

    CommonUtils.logCurrentFcmToken();
  }

  private void dismiss() {
    CommonUtils.stopForegroundService(this);
    if (isTaskRoot()) CommonUtils.startActivity(this, FlutterAppActivity.class);
    finish();
  }

  private void answer() {
    dismiss();
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

}