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

[GtkTemplate (ui = "/io/github/Rirusha/Foldy/ui/folder-page.ui")]
public sealed class Foldy.FolderPage: BasePage {

    [GtkChild]
    unowned Gtk.Button delete_button;

    public string folder_id { get; construct; }

    Settings settings;

    public FolderPage (Adw.NavigationView nav_view, string folder_id) {
        Object (nav_view: nav_view, folder_id: folder_id);
    }

    construct {
        title = get_folder_name (folder_id);

        row_box.row_activated.connect ((row) => {
            var app_row = (AppRow) row;

            if (!(app_row.app_id in get_folder_apps (folder_id))) {
                refresh ();

                application.show_message (_("Can't open folder settings"));

                return;
            }

            //  SHOW INFO
        });

        delete_button.clicked.connect (() => {
            remove_folder (folder_id);

            nav_view.pop ();
        });

        settings = new Settings.with_path (
            "org.gnome.desktop.app-folders.folder",
            "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id)
        );

        settings.changed.connect ((key) => {
            refresh ();
        });

        unmap.connect (() => {
            if (get_folder_apps (folder_id).length == 0) {
                remove_folder (folder_id);
            }
        });
    }

    protected override void update_list () {
        row_box.remove_all ();

        foreach (string app_id in get_folder_apps (folder_id)) {
            row_box.append (new AppRow (folder_id, app_id));
        }
    }

    protected override bool filter (Gtk.ListBoxRow row, string search_text) {
        var app_row = (AppRow) row;

        return search_text.down () in app_row.app_id.down ();
    }
}
 