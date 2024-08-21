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
public sealed class Foldy.AppRow : Adw.ActionRow {

    [GtkChild]
    unowned Gtk.Revealer check_revealer;
    [GtkChild]
    unowned Gtk.Image icon_image;
    [GtkChild]
    unowned Gtk.CheckButton check_button;

    public AppInfo app_info { get; construct; }

    bool _selection_enabled = false;
    public bool selection_enabled {
        get {
            return _selection_enabled;
        }
        set {
            _selection_enabled = value;

            if (!value) {
                selected = false;
            }
        }
    }

    public bool check_button_sensitive {
        get {
            return check_button.sensitive;
        }
        set {
            check_button.sensitive = value;
        }
    }

    public new bool selected { get; set; default = false; }

    public AppRow (AppInfo app_info) {
        Object (app_info: app_info);
    }

    construct {
        title = app_info.get_display_name ();
        subtitle = app_info.get_id ();

        icon_image.set_from_gicon (app_info.get_icon ());

        var lp = new Gtk.GestureLongPress ();
        //  lp.delay_factor = 0.8;
        lp.pressed.connect ((x, y) => {
            Graphene.Rect rect;
            compute_bounds (check_button, out rect);

            if (x > rect.origin.x.abs () && x < rect.origin.x.abs () + rect.size.width &&
                y > rect.origin.y.abs () && y < rect.origin.y.abs () + rect.size.height
            ) {
                return;
            }

            if (!selection_enabled) {
                selection_enabled = true;
                selected = true;

            } else {
                selected = !selected;
            }
        });
        add_controller (lp);

        activated.connect (() => {
            new AppInfoDialog (app_info).present (this);
        });

        bind_property (
            "selection-enabled",
            check_revealer,
            "reveal-child",
            BindingFlags.DEFAULT
        );

        bind_property (
            "selected",
            check_button,
            "active",
            BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE
        );
    }
}
