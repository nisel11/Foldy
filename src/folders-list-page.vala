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

[GtkTemplate (ui = "/io/github/Rirusha/Foldy/ui/folders-list-page.ui")]
public sealed class Foldy.FoldersListPage : BasePage {

    [GtkChild]
    unowned Gtk.Button create_new_button;

    Settings settings;

    public FoldersListPage (Adw.NavigationView nav_view) {
        Object (nav_view: nav_view);
    }

    construct {
        row_box.row_activated.connect ((row) => {
            var folder_row = (FolderRow) row;

            if (!(folder_row.folder_id in get_folders ())) {
                refresh ();

                Foldy.Application.get_default ().show_message (_("Can't open folder settings"));

                return;
            }

            nav_view.push (new FolderPage (nav_view, folder_row.folder_id));
        });

        create_new_button.clicked.connect (() => {
            string new_folder_id = create_folder ();

            nav_view.push (new FolderPage (nav_view, new_folder_id));
        });

        settings = new Settings ("org.gnome.desktop.app-folders");

        settings.changed["folder-children"].connect (() => {
            Idle.add_once (refresh);
        });
    }

    protected override void update_list () {
        row_box.remove_all ();

        foreach (string folder_id in get_folders ()) {
            row_box.append (new FolderRow (folder_id));
        }
    }

    protected override bool filter (Gtk.ListBoxRow row, string search_text) {
        var folder_row = (FolderRow) row;

        return search_text.down () in folder_row.folder_id.down () ||
               search_text.down () in get_folder_name (folder_row.folder_id).down ();
    }
}
