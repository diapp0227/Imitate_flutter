package com.example.imitate_android.BaseHome

import androidx.compose.foundation.layout.Arrangement
import androidx.compose.foundation.layout.Box
import androidx.compose.foundation.layout.Column
import androidx.compose.foundation.layout.fillMaxSize
import androidx.compose.foundation.layout.padding
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.Add
import androidx.compose.material3.FloatingActionButton
import androidx.compose.material3.Icon
import androidx.compose.runtime.Composable
import androidx.compose.runtime.mutableStateOf
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.unit.dp
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.example.imitate_android.BalanceRecordRepository
import com.example.imitate_android.BaseHome.TopHome.BalanceView
import com.example.imitate_android.BaseHome.TopHome.BalanceViewType
import kotlinx.coroutines.launch


@Composable
fun TopHomeView(viewModel: TopHomeViewModel = TopHomeViewModel()) {

    Box(
        modifier = Modifier
            .fillMaxSize(),
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

        // プラスボタン押下時
        FloatingActionButton(
            onClick = {
//                val data: Map<String, Any> = mapOf(
//                    "type" to "支出",
//                    "incomeCategory" to "",
//                    "expenseCategory" to "食費",
//                    "amount" to 1200,
//                    "memo" to "昼ごはん",
//                    "date" to "2026-01-02",
//                    "createdAt" to "2026-01-02",
//                    "gameFlag" to false
//                )
//                viewModel.insertRecord(data)
//                viewModel.selectAllData()
            },
            modifier = Modifier
                .align(Alignment.BottomEnd)
                .padding(16.dp)
        ) {
            Icon(
                imageVector = Icons.Default.Add,
                contentDescription = "Add"
            )
        }
    }
}

class TopHomeViewModel : ViewModel() {

    private val _uiState = mutableStateOf<TopHomeUiState>(TopHomeUiState.Idle)
    // TODO: compose側から参照してステータス判定し、表示を出し分ける
    val uiState = _uiState

    fun selectAllData() {
        viewModelScope.launch {
            _uiState.value = TopHomeUiState.Loading
            try {
                val data = BalanceRecordRepository.selectAll()
                _uiState.value = TopHomeUiState.Success(data)
            } catch (e: Exception) {
                _uiState.value = TopHomeUiState.Error(e.message ?: "不明なエラー")
            }
        }
    }

    fun insertRecord(data: Map<String, Any>) {
        viewModelScope.launch {
            _uiState.value = TopHomeUiState.Loading
            try {
                val data = BalanceRecordRepository.insert(data)
            } catch (e: Exception) {

            }
        }
    }
}

sealed class TopHomeUiState {
    object Idle : TopHomeUiState()
    object Loading : TopHomeUiState()
    data class Success(val data: List<Map<String, Any>>) : TopHomeUiState()
    data class Error(val message: String) : TopHomeUiState()
}