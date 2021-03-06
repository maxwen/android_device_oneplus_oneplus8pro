/*
* Copyright (C) 2016 The OmniROM Project
*
* This program is free software: you can redistribute it and/or modify
* it under the terms of the GNU General Public License as published by
* the Free Software Foundation, either version 2 of the License, or
* (at your option) any later version.
*
* This program is distributed in the hope that it will be useful,
* but WITHOUT ANY WARRANTY; without even the implied warranty of
* MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
* GNU General Public License for more details.
*
* You should have received a copy of the GNU General Public License
* along with this program. If not, see <http://www.gnu.org/licenses/>.
*
*/
package org.omnirom.device;

import android.os.Bundle;
import android.content.ComponentName;
import android.content.Intent;
import android.content.SharedPreferences;
import android.content.pm.PackageManager;
import androidx.preference.PreferenceCategory;
import androidx.preference.PreferenceFragment;
import androidx.preference.PreferenceManager;
import androidx.preference.PreferenceScreen;
import androidx.preference.ListPreference;
import androidx.preference.SwitchPreference;
import androidx.preference.TwoStatePreference;
import androidx.preference.Preference;
import android.provider.Settings;
import android.text.TextUtils;

import com.android.internal.util.omni.PackageUtils;

public class DeviceSettings extends PreferenceFragment implements
        Preference.OnPreferenceChangeListener {

    public static final String KEY_VIBSTRENGTH = "vib_strength";

    private static final String KEY_SLIDER_MODE_TOP = "slider_mode_top";
    private static final String KEY_SLIDER_MODE_CENTER = "slider_mode_center";
    private static final String KEY_SLIDER_MODE_BOTTOM = "slider_mode_bottom";
    private static final String KEY_CATEGORY_GRAPHICS = "graphics";
    private static final String KEY_CATEGORY_REFRESH = "refresh";
    private static final String KEY_CATEGORY_AUDIO = "audio";
    private static final String KEY_CATEGORY_VIBRATOR = "vibrator";

    public static final String KEY_SRGB_SWITCH = "srgb";
    public static final String KEY_HBM_SWITCH = "hbm";
    public static final String KEY_PROXI_SWITCH = "proxi";
    public static final String KEY_DCD_SWITCH = "dcd";
    public static final String KEY_DCI_SWITCH = "dci";
    public static final String KEY_NIGHT_SWITCH = "night";
    public static final String KEY_WIDE_SWITCH = "wide";

    public static final String KEY_FPS_INFO = "fps_info";
    private static final String KEY_ENABLE_DOLBY_ATMOS = "enable_dolby_atmos";
    private static final String KEY_DOLBY_ATMOS_CONFIG = "dolby_atmos";
    private static final String DOLBY_ATMOS_PKG = "com.dolby.daxservice";

    public static final String SLIDER_DEFAULT_VALUE = "2,1,0";

    public static final String KEY_SETTINGS_PREFIX = "device_setting_";

    private VibratorStrengthPreference mVibratorStrength;
    private ListPreference mSliderModeTop;
    private ListPreference mSliderModeCenter;
    private ListPreference mSliderModeBottom;
    private static TwoStatePreference mHBMModeSwitch;
    private static TwoStatePreference mDCDModeSwitch;
    private static SwitchPreference mFpsInfo;
    private SwitchPreference mEnableDolbyAtmos;

    @Override
    public void onCreatePreferences(Bundle savedInstanceState, String rootKey) {
        final SharedPreferences prefs = PreferenceManager.getDefaultSharedPreferences(this.getContext());
        setPreferencesFromResource(R.xml.main, rootKey);
        final PreferenceScreen prefScreen = getPreferenceScreen();

        final PreferenceCategory vibCategory =
                (PreferenceCategory) prefScreen.findPreference(KEY_CATEGORY_VIBRATOR);
        mVibratorStrength = (VibratorStrengthPreference) findPreference(KEY_VIBSTRENGTH);
        if (!VibratorStrengthPreference.isSupported()) {
            prefScreen.removePreference(vibCategory);
        }

        mSliderModeTop = (ListPreference) findPreference(KEY_SLIDER_MODE_TOP);
        mSliderModeTop.setOnPreferenceChangeListener(this);
        int sliderModeTop = getSliderAction(0);
        int valueIndex = mSliderModeTop.findIndexOfValue(String.valueOf(sliderModeTop));
        mSliderModeTop.setValueIndex(valueIndex);
        mSliderModeTop.setSummary(mSliderModeTop.getEntries()[valueIndex]);

        mSliderModeCenter = (ListPreference) findPreference(KEY_SLIDER_MODE_CENTER);
        mSliderModeCenter.setOnPreferenceChangeListener(this);
        int sliderModeCenter = getSliderAction(1);
        valueIndex = mSliderModeCenter.findIndexOfValue(String.valueOf(sliderModeCenter));
        mSliderModeCenter.setValueIndex(valueIndex);
        mSliderModeCenter.setSummary(mSliderModeCenter.getEntries()[valueIndex]);

        mSliderModeBottom = (ListPreference) findPreference(KEY_SLIDER_MODE_BOTTOM);
        mSliderModeBottom.setOnPreferenceChangeListener(this);
        int sliderModeBottom = getSliderAction(2);
        valueIndex = mSliderModeBottom.findIndexOfValue(String.valueOf(sliderModeBottom));
        mSliderModeBottom.setValueIndex(valueIndex);
        mSliderModeBottom.setSummary(mSliderModeBottom.getEntries()[valueIndex]);

        mHBMModeSwitch = (TwoStatePreference) findPreference(KEY_HBM_SWITCH);
        mHBMModeSwitch.setEnabled(HBMModeSwitch.isSupported());
        mHBMModeSwitch.setChecked(HBMModeSwitch.isCurrentlyEnabled(this.getContext()));
        mHBMModeSwitch.setOnPreferenceChangeListener(new HBMModeSwitch(getContext()));

        mDCDModeSwitch = (TwoStatePreference) findPreference(KEY_DCD_SWITCH);
        mDCDModeSwitch.setEnabled(DCDModeSwitch.isSupported());
        mDCDModeSwitch.setChecked(DCDModeSwitch.isCurrentlyEnabled(this.getContext()));
        mDCDModeSwitch.setOnPreferenceChangeListener(new DCDModeSwitch(getContext()));

        mFpsInfo = (SwitchPreference) findPreference(KEY_FPS_INFO);
        mFpsInfo.setChecked(prefs.getBoolean(KEY_FPS_INFO, false));
        mFpsInfo.setOnPreferenceChangeListener(this);

        final PreferenceCategory audioCategory =
                (PreferenceCategory) prefScreen.findPreference(KEY_CATEGORY_AUDIO);
        mEnableDolbyAtmos = (SwitchPreference) findPreference(KEY_ENABLE_DOLBY_ATMOS);
        mEnableDolbyAtmos.setOnPreferenceChangeListener(this);
        if (!isDolbyAtmosInstalled()) {
            prefScreen.removePreference(audioCategory);
        } else if (!isOpSoundTunerInstalled()) {
            audioCategory.removePreference(audioCategory.findPreference(KEY_DOLBY_ATMOS_CONFIG));
        }
    }

    @Override
    public boolean onPreferenceTreeClick(Preference preference) {
        return super.onPreferenceTreeClick(preference);
    }

    @Override
    public boolean onPreferenceChange(Preference preference, Object newValue) {
        if (preference == mSliderModeTop) {
            String value = (String) newValue;
            int sliderMode = Integer.valueOf(value);
            setSliderAction(0, sliderMode);
            int valueIndex = mSliderModeTop.findIndexOfValue(value);
            mSliderModeTop.setSummary(mSliderModeTop.getEntries()[valueIndex]);
        } else if (preference == mSliderModeCenter) {
            String value = (String) newValue;
            int sliderMode = Integer.valueOf(value);
            setSliderAction(1, sliderMode);
            int valueIndex = mSliderModeCenter.findIndexOfValue(value);
            mSliderModeCenter.setSummary(mSliderModeCenter.getEntries()[valueIndex]);
        } else if (preference == mSliderModeBottom) {
            String value = (String) newValue;
            int sliderMode = Integer.valueOf(value);
            setSliderAction(2, sliderMode);
            int valueIndex = mSliderModeBottom.findIndexOfValue(value);
            mSliderModeBottom.setSummary(mSliderModeBottom.getEntries()[valueIndex]);
        } else if (preference == mFpsInfo) {
            boolean enabled = (Boolean) newValue;
            Intent fpsinfo = new Intent(this.getContext(), org.omnirom.device.FPSInfoService.class);
            if (enabled) {
                this.getContext().startService(fpsinfo);
            } else {
                this.getContext().stopService(fpsinfo);
            }
        } else if (preference == mEnableDolbyAtmos) {
            boolean enabled = (Boolean) newValue;
            Intent daxService = new Intent();
            ComponentName name = new ComponentName(DOLBY_ATMOS_PKG, DOLBY_ATMOS_PKG + ".DaxService");
            daxService.setComponent(name);
            if (enabled) {
                // enable service component and start service
                this.getContext().getPackageManager().setComponentEnabledSetting(name,
                        PackageManager.COMPONENT_ENABLED_STATE_DEFAULT, 0);
                this.getContext().startService(daxService);
            } else {
                // disable service component and stop service
                this.getContext().stopService(daxService);
                this.getContext().getPackageManager().setComponentEnabledSetting(name,
                        PackageManager.COMPONENT_ENABLED_STATE_DISABLED, 0);
            }
        }
        return true;
    }

    private int getSliderAction(int position) {
        String value = Settings.System.getString(getContext().getContentResolver(),
                    Settings.System.OMNI_BUTTON_EXTRA_KEY_MAPPING);
        final String defaultValue = SLIDER_DEFAULT_VALUE;

        if (value == null) {
            value = defaultValue;
        } else if (value.indexOf(",") == -1) {
            value = defaultValue;
        }
        try {
            String[] parts = value.split(",");
            return Integer.valueOf(parts[position]);
        } catch (Exception e) {
        }
        return 0;
    }

    private void setSliderAction(int position, int action) {
        String value = Settings.System.getString(getContext().getContentResolver(),
                    Settings.System.OMNI_BUTTON_EXTRA_KEY_MAPPING);
        final String defaultValue = SLIDER_DEFAULT_VALUE;

        if (value == null) {
            value = defaultValue;
        } else if (value.indexOf(",") == -1) {
            value = defaultValue;
        }
        try {
            String[] parts = value.split(",");
            parts[position] = String.valueOf(action);
            String newValue = TextUtils.join(",", parts);
            Settings.System.putString(getContext().getContentResolver(),
                    Settings.System.OMNI_BUTTON_EXTRA_KEY_MAPPING, newValue);
        } catch (Exception e) {
        }
    }

    private boolean isDolbyAtmosInstalled() {
        return PackageUtils.isAvailableApp(DOLBY_ATMOS_PKG, getActivity());
    }

    private boolean isOpSoundTunerInstalled() {
        return PackageUtils.isAvailableApp("com.oneplus.sound.tuner", getActivity());
    }
}
