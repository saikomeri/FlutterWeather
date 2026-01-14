import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_weather/presentation/providers/weather_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isDarkMode = ref.watch(isDarkModeProvider);
    final unit = ref.watch(temperatureUnitProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              theme.colorScheme.primary,
              theme.colorScheme.primary.withOpacity(0.8),
              theme.colorScheme.surface,
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // App bar
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Settings',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 8),

              // Settings list
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Appearance Section
                    _buildSectionHeader('Appearance', theme),
                    const SizedBox(height: 8),
                    _buildSettingCard(
                      theme: theme,
                      children: [
                        _buildSwitchTile(
                          icon: Icons.dark_mode_outlined,
                          title: 'Dark Mode',
                          subtitle: isDarkMode ? 'On' : 'Off',
                          value: isDarkMode,
                          onChanged: (value) {
                            ref.read(isDarkModeProvider.notifier).state = value;
                          },
                          theme: theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // Units Section
                    _buildSectionHeader('Units', theme),
                    const SizedBox(height: 8),
                    _buildSettingCard(
                      theme: theme,
                      children: [
                        _buildRadioTile(
                          icon: Icons.thermostat_outlined,
                          title: 'Celsius (°C)',
                          subtitle: 'Metric system',
                          selected: unit == TemperatureUnit.celsius,
                          onTap: () {
                            ref.read(temperatureUnitProvider.notifier).state =
                                TemperatureUnit.celsius;
                          },
                          theme: theme,
                        ),
                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          height: 1,
                        ),
                        _buildRadioTile(
                          icon: Icons.thermostat,
                          title: 'Fahrenheit (°F)',
                          subtitle: 'Imperial system',
                          selected: unit == TemperatureUnit.fahrenheit,
                          onTap: () {
                            ref.read(temperatureUnitProvider.notifier).state =
                                TemperatureUnit.fahrenheit;
                          },
                          theme: theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),

                    // About Section
                    _buildSectionHeader('About', theme),
                    const SizedBox(height: 8),
                    _buildSettingCard(
                      theme: theme,
                      children: [
                        _buildInfoTile(
                          icon: Icons.info_outline,
                          title: 'Version',
                          value: '1.0.0',
                          theme: theme,
                        ),
                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          height: 1,
                        ),
                        _buildInfoTile(
                          icon: Icons.cloud_outlined,
                          title: 'Data Source',
                          value: 'OpenWeatherMap',
                          theme: theme,
                        ),
                        Divider(
                          color: Colors.white.withOpacity(0.1),
                          height: 1,
                        ),
                        _buildInfoTile(
                          icon: Icons.code,
                          title: 'Built with',
                          value: 'Flutter & Riverpod',
                          theme: theme,
                        ),
                      ],
                    ),
                    const SizedBox(height: 32),

                    // Footer
                    Center(
                      child: Text(
                        'Made with ❤️ by Sai Komeri',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: Colors.white38,
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, ThemeData theme) {
    return Text(
      title.toUpperCase(),
      style: theme.textTheme.labelSmall?.copyWith(
        color: Colors.white54,
        letterSpacing: 1.2,
        fontWeight: FontWeight.w600,
      ),
    );
  }

  Widget _buildSettingCard({
    required ThemeData theme,
    required List<Widget> children,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.08),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
      ),
      trailing: Switch.adaptive(
        value: value,
        onChanged: onChanged,
        activeColor: Colors.white,
        activeTrackColor: Colors.white.withOpacity(0.3),
      ),
    );
  }

  Widget _buildRadioTile({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool selected,
    required VoidCallback onTap,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
      subtitle: Text(
        subtitle,
        style: theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
      ),
      trailing: Container(
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: selected ? Colors.white : Colors.white38,
            width: 2,
          ),
        ),
        child: selected
            ? Center(
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                ),
              )
            : null,
      ),
      onTap: onTap,
    );
  }

  Widget _buildInfoTile({
    required IconData icon,
    required String title,
    required String value,
    required ThemeData theme,
  }) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      leading: Icon(icon, color: Colors.white70),
      title: Text(
        title,
        style: theme.textTheme.bodyLarge?.copyWith(color: Colors.white),
      ),
      trailing: Text(
        value,
        style: theme.textTheme.bodyMedium?.copyWith(color: Colors.white54),
      ),
    );
  }
}
