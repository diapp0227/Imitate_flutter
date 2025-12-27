package com.example.imitate_android

import android.os.Bundle
import androidx.activity.ComponentActivity
import androidx.activity.compose.setContent
import androidx.activity.enableEdgeToEdge
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Home
import androidx.compose.material3.Icon
import androidx.compose.material3.NavigationBar
import androidx.compose.material3.NavigationBarItem
import androidx.compose.material3.Scaffold
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.runtime.getValue
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.saveable.rememberSaveable
import androidx.compose.runtime.setValue
import androidx.compose.ui.Modifier
import androidx.compose.ui.graphics.vector.ImageVector
import com.example.imitate_android.BaseHome.GameHomeView
import com.example.imitate_android.BaseHome.HistoryHomeView
import com.example.imitate_android.BaseHome.InputHomeView
import com.example.imitate_android.BaseHome.SettingHomeView
import com.example.imitate_android.BaseHome.TopHomeView
import com.example.imitate_android.ui.theme.Imitate_androidTheme

class BaseHomeActivity : ComponentActivity() {

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        enableEdgeToEdge()

        setContent {
            Imitate_androidTheme {
                BaseHomeScreen()
            }
        }
    }

    data class BottomNavItem(
        val route: String,
        val label: String,
        val icon: ImageVector
    )

    @Composable
    fun BaseHomeScreen() {
        var selectedIndex by rememberSaveable { mutableIntStateOf(0) }

        val items = listOf(
            "ホーム",
            "ホーム",
            "ホーム",
            "ホーム",
            "ホーム"
        )

        val icons = listOf(
            Icons.Default.Home,
            Icons.Default.Home,
            Icons.Default.Home,
            Icons.Default.Home,
            Icons.Default.Home
        )

        Scaffold(
            bottomBar = {
                NavigationBar {
                    items.forEachIndexed { index, label ->
                        NavigationBarItem(
                            selected = selectedIndex == index,
                            onClick = { selectedIndex = index },
                            icon = { Icon(icons[index], contentDescription = label) },
                            label = { Text(label) }
                        )
                    }
                }
            }
        ) { padding ->
            Box(modifier = Modifier.padding(padding)) {
                when (selectedIndex) {
                    0 -> TopHomeView()
                    1 -> InputHomeView()
                    2 -> GameHomeView()
                    3 -> HistoryHomeView()
                    4 -> SettingHomeView()
                }
            }
        }
    }
}