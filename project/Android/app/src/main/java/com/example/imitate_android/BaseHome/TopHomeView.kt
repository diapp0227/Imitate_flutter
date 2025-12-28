package com.example.imitate_android.BaseHome

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxWidth
import androidx.compose.runtime.Composable
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import com.example.imitate_android.BaseHome.TopHome.BalanceView
import com.example.imitate_android.BaseHome.TopHome.BalanceViewType

@Composable
fun TopHomeView() {

    Box(
        modifier = Modifier
            .fillMaxWidth(),
        contentAlignment = Alignment.TopCenter
    ) {
        Column(
            verticalArrangement = Arrangement.spacedBy((8).dp)
        ) {
            BalanceView(
                type = BalanceViewType.INCOME,
                amount = "200000"
            )
            BalanceView(
                type = BalanceViewType.EXPENSES,
                amount = "200000"
            )
        }
    }
}