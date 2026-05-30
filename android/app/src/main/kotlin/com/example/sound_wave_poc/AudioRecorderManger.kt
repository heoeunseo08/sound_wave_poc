package com.example.sound_wave_poc

import android.Manifest
import android.media.AudioFormat
import android.media.AudioRecord
import android.media.MediaRecorder
import android.os.Handler
import android.os.Looper
import androidx.annotation.RequiresPermission
import kotlin.math.sqrt

class AudioRecorderManger {
    private var recorder: AudioRecord? = null

    private var thread: Thread? = null

    private var recording = false

    private var handler = Handler(Looper.getMainLooper())

    var onAmplitudeUpdate: ((amplitude: Double) -> Unit)? = null

    @RequiresPermission(Manifest.permission.RECORD_AUDIO)
    fun start(): Boolean {
        if (recording) return true

        val bufferSize = AudioRecord.getMinBufferSize(
            44100,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT
        )

        recorder = AudioRecord(
            MediaRecorder.AudioSource.MIC,
            44100,
            AudioFormat.CHANNEL_IN_MONO,
            AudioFormat.ENCODING_PCM_16BIT,
            bufferSize

        )

        recording = true
        recorder?.startRecording()

        thread = Thread {
            val buffer = ShortArray(bufferSize/2)
            while(recording){
                val  count = recorder?.read(buffer, 0, buffer.size) ?: 0

                if(count > 0){
                    var sum = 0.0
                    for (i in 0 until count){
                        var  s = buffer[i].toDouble()
                        sum += s*s
                    }
                    val amplitude = (sqrt(sum/count)/32768.0).coerceIn(0.0, 1.0)

                    handler.post { onAmplitudeUpdate?.invoke(amplitude) }
                }
            }
        }.apply { start() }

        return true
    }
}

//1. x의 최솟값을 0으로 만들게 값을 보정한다. (근사치)
//2. x의 최솟값이 0일 경우 최대값을 파악한다. (근사치)
//3. x의 최대값을 나눈다.
//4. 값을 0 ~ 1 사이로 클램밍한다.