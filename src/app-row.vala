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
    unowned Gtk.Stack icon_stack;
    [GtkChild]
    unowned Gtk.Image icon_image;
    [GtkChild]
    unowned Gtk.CheckButton check_button;

    public string folder_id { get; construct; }

    public AppInfo app_info { get; construct; }

    bool _selection_enabled = false;
    public bool selection_enabled {
        get {
            return _selection_enabled;
        }
        set {
            _selection_enabled = value;

            if (value) {
                icon_stack.visible_child_name = "check";

            } else {
                icon_stack.visible_child_name = "icon";
            }
        }
    }

    public AppRow (string folder_id, AppInfo app_info) {
        Object (folder_id: folder_id, app_info: app_info);
    }

    construct {
        title = app_info.get_display_name ();
        subtitle = app_info.get_id ();

        set_icon.begin ();

        activated.connect (() => {
            check_button.active = !check_button.active;
        });

        //  delete_button.clicked.connect (() => {
        //      remove_app_from_folder (folder_id, app_id);
        //  });
    }
    async void set_icon (int priority = Priority.DEFAULT) {

        Icon icon = app_info.get_icon ();

        if (icon is ThemedIcon) {
            var icon_theme = Gtk.IconTheme.get_for_display (Gdk.Display.get_default ());

            var ip = icon_theme.lookup_by_gicon (icon, 32, 1, Gtk.TextDirection.NONE, Gtk.IconLookupFlags.FORCE_REGULAR);

            InputStream? input = null;

            try {
                input = yield ip.file.read_async (priority);

            } catch (Error e) {
                warning (e.message);
                return;
            }

            Gdk.Pixbuf? pb = null;

            try {
                pb = yield new Gdk.Pixbuf.from_stream_async (input);

            } catch (Error e) {
                warning (e.message);
                return;
            }

            icon_image.set_from_paintable (Gdk.Texture.for_pixbuf (pb));

        } else if (icon is LoadableIcon) {
            InputStream? input = null;

            try {
                input = yield ((LoadableIcon) icon).load_async (64);

            } catch (Error e) {
                warning (e.message);
                return;
            }

            Gdk.Pixbuf? pb = null;

            try {
                pb = yield new Gdk.Pixbuf.from_stream_async (input);

            } catch (Error e) {
                warning (e.message);
                return;
            }
            
            icon_image.set_from_paintable (Gdk.Texture.for_pixbuf (pb));

        } else if (icon is EmblemedIcon) {
            icon_image.set_from_icon_name (icon.to_string ());

        } else {
            warning ("Unknown icon format");
        }
    }
}
