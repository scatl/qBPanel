package com.scatl.qbpanel

import android.content.Intent
import android.os.Bundle
import androidx.core.view.WindowCompat
import io.flutter.embedding.android.FlutterActivity
import io.flutter.embedding.engine.FlutterEngine
import io.flutter.plugin.common.MethodChannel

class MainActivity : FlutterActivity() {
    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        // 内容可画到系统栏后方；避让由 Flutter 的 viewPadding / viewInsets 负责
        WindowCompat.setDecorFitsSystemWindows(window, false)
    }

    override fun configureFlutterEngine(flutterEngine: FlutterEngine) {
        super.configureFlutterEngine(flutterEngine)
        MethodChannel(
            flutterEngine.dartExecutor.binaryMessenger,
            "qbpanel/intent",
        ).setMethodCallHandler { call, result ->
            when (call.method) {
                "clearLaunchIntent" -> {
                    // 处理完 VIEW/SEND 后清掉，避免任务栈恢复时再次当成「打开种子」
                    setIntent(
                        Intent(this, MainActivity::class.java).apply {
                            action = Intent.ACTION_MAIN
                            addCategory(Intent.CATEGORY_LAUNCHER)
                        },
                    )
                    result.success(null)
                }
                else -> result.notImplemented()
            }
        }
    }

    override fun onNewIntent(intent: Intent) {
        super.onNewIntent(intent)
        // singleTop 热启动时更新 Activity Intent，供 receive_intent 读取
        setIntent(intent)
    }
}
