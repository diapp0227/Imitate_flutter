package com.example.imitate_android.BaseHome.TopHome

import androidx.compose.foundation.background
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.Row
import androidx.compose.foundation.layout.Spacer
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.foundation.layout.height
import androidx.compose.foundation.layout.padding
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material3.MaterialTheme
import androidx.compose.material3.Text
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.graphics.Color


enum class BalanceViewType {
    INCOME,
    EXPENSES;

    val title: String
        get() = when (this) {
            INCOME -> "今月の収入"
            EXPENSES -> "今月の支出"
        }

    val backgroundColor: Color
        get() = when (this) {
            INCOME -> Color.Green
            EXPENSES -> Color.Red
        }
}

@Composable
fun BalanceView(type: BalanceViewType,
                amount: String,
                modifier: Modifier = Modifier
) {
    Box(
        modifier = Modifier.fillMaxWidth(),
        contentAlignment = Alignment.Center
    ) {
        Column(
            modifier = modifier
                .clip(RoundedCornerShape(12.dp))
                .background(type.backgroundColor)
                .padding(16.dp)
                .fillMaxWidth(0.9f)
        ) {
            Text(
                text = type.title,
                style = MaterialTheme.typography.labelMedium,
                color = Color.White.copy(alpha = 0.9f)
            )

            Spacer(modifier = Modifier.height(8.dp))

            Row {
                Text(
                    text = "¥",
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )

                Text(
                    text = amount,
                    style = MaterialTheme.typography.titleLarge,
                    fontWeight = FontWeight.Bold,
                    color = Color.White
                )
            }
        }
    }
}