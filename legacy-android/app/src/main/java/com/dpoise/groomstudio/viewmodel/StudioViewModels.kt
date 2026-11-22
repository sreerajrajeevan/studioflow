package com.dpoise.groomstudio.viewmodel

import android.net.Uri
import androidx.lifecycle.ViewModel
import androidx.lifecycle.ViewModelProvider
import androidx.lifecycle.viewModelScope
import com.dpoise.groomstudio.data.repository.StudioProfileRepository
import com.dpoise.groomstudio.domain.model.StudioProfile
import com.dpoise.groomstudio.util.LogoStorage
import kotlinx.coroutines.flow.MutableStateFlow
import kotlinx.coroutines.flow.StateFlow
import kotlinx.coroutines.flow.asStateFlow
import kotlinx.coroutines.launch

/** Root-level profile state: drives first-run gating + dynamic theming. */
class StudioProfileViewModel(
    private val repository: StudioProfileRepository
) : ViewModel() {

    /** null = still loading from disk; Loaded(null) = setup not done yet. */
    sealed interface GateState {
        data object Loading : GateState
        data class Loaded(val profile: StudioProfile?) : GateState
    }

    val gateState: StateFlow<GateState> = repository.observeProfile()
        .let { flow ->
            val state = MutableStateFlow<GateState>(GateState.Loading)
            viewModelScope.launch {
                flow.collect { state.value = GateState.Loaded(it) }
            }
            state.asStateFlow()
        }

    class Factory(private val repo: StudioProfileRepository) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T =
            StudioProfileViewModel(repo) as T
    }
}

/** First-run wizard state (5 steps). Saving writes the single profile row. */
class SetupViewModel(
    private val repository: StudioProfileRepository,
    private val logoStorage: LogoStorage
) : ViewModel() {

    private val _step = MutableStateFlow(0)
    val step: StateFlow<Int> = _step.asStateFlow()

    private val _form = MutableStateFlow(ProfileFormState())
    val form: StateFlow<ProfileFormState> = _form.asStateFlow()

    private val _saving = MutableStateFlow(false)
    val saving: StateFlow<Boolean> = _saving.asStateFlow()

    private val _saveError = MutableStateFlow<String?>(null)
    val saveError: StateFlow<String?> = _saveError.asStateFlow()

    fun update(transform: (ProfileFormState) -> ProfileFormState) {
        _form.value = transform(_form.value)
    }

    fun next() {
        if (_step.value < LAST_STEP) _step.value += 1
    }

    fun back() {
        if (_step.value > 0) _step.value -= 1
    }

    fun onLogoPicked(uri: Uri?) {
        if (uri == null) return
        viewModelScope.launch {
            val oldPath = _form.value.logoPath
            val stored = logoStorage.saveFromUri(uri)
            if (stored != null) {
                _form.value = _form.value.copy(logoPath = stored)
                if (oldPath != null && oldPath != stored) logoStorage.delete(oldPath)
            } else {
                _saveError.value = "That image could not be read. Try a different logo file."
            }
        }
    }

    fun removeLogo() {
        viewModelScope.launch {
            logoStorage.delete(_form.value.logoPath)
            _form.value = _form.value.copy(logoPath = null)
        }
    }

    fun finish() {
        if (!_form.value.allValid || _saving.value) return
        _saving.value = true
        viewModelScope.launch {
            runCatching { repository.save(_form.value.toProfile()) }
                .onFailure { _saveError.value = it.message ?: "Setup could not be saved." }
            _saving.value = false
            // On success the root gate observes the new profile and navigates
            // to the dashboard automatically — nothing else to do here.
        }
    }

    companion object {
        const val LAST_STEP = 4 // 0-based: Details, Logo, Branding, Payments, Confirm
    }

    class Factory(
        private val repo: StudioProfileRepository,
        private val logoStorage: LogoStorage
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T =
            SetupViewModel(repo, logoStorage) as T
    }
}

/** Business Settings editor — loads the live profile, saves edits back. */
class SettingsViewModel(
    private val repository: StudioProfileRepository,
    private val logoStorage: LogoStorage
) : ViewModel() {

    private val _form = MutableStateFlow<ProfileFormState?>(null)
    val form: StateFlow<ProfileFormState?> = _form.asStateFlow()

    private val _savedMessage = MutableStateFlow<String?>(null)
    val savedMessage: StateFlow<String?> = _savedMessage.asStateFlow()

    private var existing: StudioProfile? = null

    init {
        viewModelScope.launch {
            repository.observeProfile().collect { profile ->
                if (profile != null && existing == null) {
                    existing = profile
                    _form.value = ProfileFormState.fromProfile(profile)
                }
            }
        }
    }

    fun update(transform: (ProfileFormState) -> ProfileFormState) {
        _form.value = _form.value?.let(transform)
    }

    fun onLogoPicked(uri: Uri?) {
        if (uri == null) return
        viewModelScope.launch {
            val oldPath = _form.value?.logoPath
            val stored = logoStorage.saveFromUri(uri)
            if (stored != null) {
                _form.value = _form.value?.copy(logoPath = stored)
                if (oldPath != null && oldPath != stored) logoStorage.delete(oldPath)
            }
        }
    }

    fun removeLogo() {
        viewModelScope.launch {
            logoStorage.delete(_form.value?.logoPath)
            _form.value = _form.value?.copy(logoPath = null)
        }
    }

    fun save() {
        val current = _form.value ?: return
        if (!current.allValid) return
        viewModelScope.launch {
            runCatching { repository.save(current.toProfile(existing)) }
                .onSuccess {
                    existing = repository.getProfile()
                    _savedMessage.value = "Settings saved."
                }
                .onFailure { _savedMessage.value = it.message ?: "Could not save settings." }
        }
    }

    fun clearSavedMessage() {
        _savedMessage.value = null
    }

    class Factory(
        private val repo: StudioProfileRepository,
        private val logoStorage: LogoStorage
    ) : ViewModelProvider.Factory {
        @Suppress("UNCHECKED_CAST")
        override fun <T : ViewModel> create(modelClass: Class<T>): T =
            SettingsViewModel(repo, logoStorage) as T
    }
}
