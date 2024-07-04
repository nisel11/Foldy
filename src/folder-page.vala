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
        selection_button.visible = true;

        page_title = get_folder_name (folder_id);
        page_subtitle = folder_id;

        row_box.row_activated.connect ((row) => {
            var app_row = (AppRow) row;

            if (!(app_row.app_info.get_id () in get_folder_apps (folder_id))) {
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

        update_list_async.begin ();
    }

    async void update_list_async () {
        var app_infos = AppInfo.get_all ();
        var folder_apps = get_folder_apps (folder_id);

        foreach (AppInfo app_info in app_infos) {
            if (app_info.get_id () in folder_apps) {
                var app_row = new AppRow (folder_id, app_info);

                selection_button.bind_property (
                    "active",
                    app_row, "selection-enabled",
                    BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE);

                row_box.append (app_row);

                Idle.add (update_list_async.callback);
                yield;
            }
        }
    }

    protected override bool filter (Gtk.ListBoxRow row, string search_text) {
        var app_row = (AppRow) row;

        return search_text.down () in app_row.app_info.get_id ().down ();
    }
}
