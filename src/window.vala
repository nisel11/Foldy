/* Copyright 2024 Rirusha
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


[GtkTemplate (ui = "/io/github/Rirusha/Foldy/ui/window.ui")]
public class Foldy.Window : Adw.ApplicationWindow {

    const ActionEntry[] ACTION_ENTRIES = {
        { "preferences", on_preferences_action },
        { "about", on_about_action },
    };

    public Window (Foldy.Application app) {
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
            application_name = "Foldy",
            application_icon = Config.APP_ID_DYN,
            developer_name = "Rirusha",
            version = Config.VERSION,
            // Translators: NAME <EMAIL.COM> /n NAME <EMAIL.COM>
            translator_credits = _("translator-credits"),
            license_type = Gtk.License.GPL_3_0,
            copyright = "© 2024 Rirusha",
            release_notes_version = Config.VERSION
        };

        about.present (this);
    }
}
