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

[GtkTemplate (ui = "/io/github/Rirusha/Foldy/ui/app-row.ui")]
public sealed class Foldy.AppRow: Adw.ActionRow {

    [GtkChild]
    unowned Gtk.Image icon_image;
    [GtkChild]
    unowned Gtk.CheckButton check_button;

    public string folder_id { get; construct; }

    public string app_id { get; construct; }

    public AppRow (string folder_id, string app_id) {
        Object (folder_id: folder_id, app_id: app_id);
    }

    construct {
        var dfr = new DesktopFileReader.with_name (app_id);

        title = dfr.read_name ();
        icon_image.icon_name = dfr.read_icon_name ();
        subtitle = app_id;

        activated.connect (() => {
            check_button.active = !check_button.active;
        });

        //  delete_button.clicked.connect (() => {
        //      remove_app_from_folder (folder_id, app_id);
        //  });
    }
}
