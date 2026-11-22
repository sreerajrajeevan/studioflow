package com.dpoise.groomstudio.viewmodel

import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.dpoise.groomstudio.domain.model.DashboardStats
import com.dpoise.groomstudio.domain.usecase.GetDashboardStatsUseCase
import com.dpoise.groomstudio.util.SampleData
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.flow.catch
import kotlinx.coroutines.launch

data class DashboardUiState(
    val isLoading: Boolean = true,
    val stats: DashboardStats = SampleData.dashboardStats,
    val recentTransactions: List<SampleData.SampleTransaction> = SampleData.recentTransactions,
    val attendanceSummary: List<SampleData.SampleAttendanceRow> = SampleData.attendanceSummary,
    /** True while the numbers on screen are sample placeholders (Task 1). */
    val showingSampleData: Boolean = true,
    val errorMessage: String? = null
)

/**
 * Task 1: state is driven by labelled SAMPLE data so the design can be
 * reviewed end-to-end. The real [GetDashboardStatsUseCase] flow is already
 * wired in [startObservingRealStats] — it stays dormant until billing and
 * attendance writes exist, at which point the sample provider is removed
 * and `showingSampleData` flips to false.
 */
class DashboardViewModel(
    private val getDashboardStats: GetDashboardStatsUseCase
) : ViewModel() {

    private val _uiState = MutableStateFlow(DashboardUiState())
    val uiState: StateFlow<DashboardUiState> = _uiState.asStateFlow()

    init {
        // Simulate the (instant, offline) first load without faking a network call.
        _uiState.value = DashboardUiState(isLoading = false)
    }

    /** Ready for later tasks: observe the real Room-backed stats. */
    fun startObservingRealStats() {
        viewModelScope.launch {
            getDashboardStats()
                .catch { e ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        errorMessage = e.message ?: "Could not load dashboard data."
                    )
                }
                .collect { stats ->
                    _uiState.value = _uiState.value.copy(
                        isLoading = false,
                        stats = stats,
                        showingSampleData = stats.isSampleData,
                        errorMessage = null
                    )
                }
        }
    }

    fun clearError() {
        _uiState.value = _uiState.value.copy(errorMessage = null)
    }

    class Factory(private val useCase: GetDashboardStatsUseCase) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T {
            require(modelClass.isAssignableFrom(DashboardViewModel::class.java)) {
                "Unknown ViewModel class: ${modelClass.name}"
            }
            return DashboardViewModel(useCase) as T
        }
    }
}
