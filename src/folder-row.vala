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

public sealed class Foldy.FolderRow: Adw.ActionRow {

    string _folder_id;
    public string folder_id {
        get {
            return _folder_id;
        }
        construct {
            _folder_id = value;

            title = get_folder_name (value);
            subtitle = value;

            activatable = true;
        }
    }

    public signal void settings_changed ();

    Settings settings;

    public FolderRow (string folder_id) {
        Object (folder_id: folder_id);
    }

    construct {
        settings = new Settings.with_path (
            "org.gnome.desktop.app-folders.folder",
            "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id)
        );

        settings.changed.connect ((key) => {
            settings_changed ();
        });
    }
}
