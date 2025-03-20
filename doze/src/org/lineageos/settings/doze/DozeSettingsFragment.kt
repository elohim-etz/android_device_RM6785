/*
 * Copyright (C) 2021-2024 The LineageOS Project
 * SPDX-License-Identifier: Apache-2.0
 */

package org.lineageos.settings.doze

import android.app.Activity
import android.app.AlertDialog
import android.content.Context
import android.os.Bundle
import android.os.Handler
import android.os.Looper
import android.widget.CompoundButton
import androidx.preference.*

import com.android.settingslib.widget.MainSwitchPreference

class DozeSettingsFragment : PreferenceFragmentCompat(), Preference.OnPreferenceChangeListener,
    CompoundButton.OnCheckedChangeListener {
    private lateinit var alwaysOnDisplayPreference: SwitchPreference
    private lateinit var switchBar: MainSwitchPreference

    private var pickUpPreference: ListPreference? = null

    private val handler = Handler(Looper.getMainLooper())

    override fun onCreatePreferences(savedInstanceState: Bundle?, rootKey: String?) {
        setPreferencesFromResource(R.xml.doze_settings, rootKey)

        val prefs = requireActivity().getSharedPreferences("doze_settings", Context.MODE_PRIVATE)
        if (savedInstanceState == null && !prefs.getBoolean("first_help_shown", false)) {
            AlertDialog.Builder(requireContext())
                .setTitle(R.string.doze_settings_help_title)
                .setMessage(R.string.doze_settings_help_text)
                .setNegativeButton(R.string.dialog_ok) { _, _ ->
                    prefs.edit().putBoolean("first_help_shown", true).apply()
                }
                .show()
        }

        val dozeEnabled = Utils.isDozeEnabled(requireContext())
        switchBar = findPreference(Utils.DOZE_ENABLE)!!
        switchBar.addOnSwitchChangeListener(this)
        switchBar.isChecked = dozeEnabled

        alwaysOnDisplayPreference = findPreference(Utils.ALWAYS_ON_DISPLAY)!!
        alwaysOnDisplayPreference.isEnabled = dozeEnabled
        alwaysOnDisplayPreference.isChecked = Utils.isAlwaysOnEnabled(requireContext())
        alwaysOnDisplayPreference.onPreferenceChangeListener = this

        val pickupSensorCategory =
            preferenceScreen.findPreference<PreferenceCategory>(Utils.CATEGORY_PICKUP_SENSOR)!!
        if (getString(R.string.pickup_sensor_type).isEmpty()) {
            preferenceScreen.removePreference(pickupSensorCategory)
        }

        pickUpPreference = findPreference(Utils.GESTURE_PICK_UP_KEY)
        pickUpPreference?.isEnabled = dozeEnabled
        pickUpPreference?.onPreferenceChangeListener = this

        // Hide AOD if not supported and set all its dependents otherwise
        if (!Utils.alwaysOnDisplayAvailable(requireContext())) {
            preferenceScreen.removePreference(alwaysOnDisplayPreference)
        } else {
            pickupSensorCategory.dependency = Utils.ALWAYS_ON_DISPLAY
        }
    }

    override fun onPreferenceChange(preference: Preference, newValue: Any?): Boolean {
        if (preference.key == Utils.ALWAYS_ON_DISPLAY) {
            Utils.enableAlwaysOn(requireContext(), newValue as Boolean)
        }
        handler.post { Utils.checkDozeService(requireContext()) }
        return true
    }

    override fun onCheckedChanged(buttonView: CompoundButton, isChecked: Boolean) {
        Utils.enableDoze(requireContext(), isChecked)
        Utils.checkDozeService(requireContext())

        switchBar.isChecked = isChecked

        if (!isChecked) {
            Utils.enableAlwaysOn(requireContext(), false)
            alwaysOnDisplayPreference.isChecked = false
        }

        alwaysOnDisplayPreference.isEnabled = isChecked
        pickUpPreference?.isEnabled = isChecked
    }

}
