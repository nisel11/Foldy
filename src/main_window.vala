/* Copyright 2024 <<DEVELOPER-NAME>>
 *
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, version 3
 *
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program.  If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */


[GtkTemplate (ui = "<<RESOURCES-PATH>>ui/main_window.ui")]
public class <<APP-NAMESPACE>>.MainWindow : Adw.ApplicationWindow {

    const ActionEntry[] ACTION_ENTRIES = {
        { "preferences", on_preferences_action },
        { "about", on_about_action },
    };

    public MainWindow (<<APP-NAMESPACE>>.Application app) {
        Object (application: app);
    }

    construct {
        var settings = new Settings (Config.APP_ID);

        add_action_entries (ACTION_ENTRIES, this);

        settings.bind ("window-width", this, "default-width", SettingsBindFlags.DEFAULT);
        settings.bind ("window-height", this, "default-height", SettingsBindFlags.DEFAULT);
        settings.bind ("window-maximized", this, "maximized", SettingsBindFlags.DEFAULT);
    }

    void on_preferences_action () {
        message ("Hello, stranger…");
    }

    void on_about_action () {
        var about = new Adw.AboutDialog () {
            application_name = "<<APP-NAME>>",
            application_icon = Config.APP_ID_DYN,
            developer_name = "<<DEVELOPER-NAME>>",
            version = Config.VERSION,
            // Translators: NAME <EMAIL.COM> /n NAME <EMAIL.COM>
            translator_credits = _("translator-credits"),
            license_type = Gtk.License.GPL_3_0,
            copyright = "© 2024 <<DEVELOPER-NAME>>",
            release_notes_version = Config.VERSION
        };

        about.present (this);
    }
}
