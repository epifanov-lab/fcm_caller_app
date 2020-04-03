package com.lab.fcmcallerapp;

import android.content.Context;
import android.media.MediaPlayer;

/**
 * @author Konstantin Epifanov
 * @since 28.02.2020
 */
public class AudioPlayer {

  private MediaPlayer mMediaPlayer;

  public void stop() {
    if (mMediaPlayer != null) {
      mMediaPlayer.release();
      mMediaPlayer = null;
    }
  }

  public void play(Context c, int rid) {
    stop();

    mMediaPlayer = MediaPlayer.create(c, rid);
    mMediaPlayer.setVolume(0.75f, 0.75f);
    mMediaPlayer.setOnCompletionListener(mediaPlayer -> stop());

    mMediaPlayer.start();
  }

}
