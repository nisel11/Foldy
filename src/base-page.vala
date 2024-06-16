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

[GtkTemplate (ui = "/io/github/Rirusha/Foldy/ui/base-page.ui")]
public abstract class Foldy.BasePage: Adw.NavigationPage {

    [GtkChild]
    unowned Gtk.ToggleButton search_button;
    [GtkChild]
    unowned Gtk.SearchEntry search_entry;
    [GtkChild]
    unowned Adw.WindowTitle window_title;
    [GtkChild]
    protected unowned Gtk.ToggleButton selection_button;
    [GtkChild]
    unowned MainMenuButton main_menu_button;
    [GtkChild]
    unowned Gtk.Stack list_stack;
    [GtkChild]
    unowned Gtk.ListBox list_box;
    [GtkChild]
    unowned Adw.Clamp bottom_clamp;

    public Adw.NavigationView nav_view { get; construct; }

    public Gtk.Widget bottom_widget {
        get {
            return bottom_clamp.child;
        }
        set {
            bottom_clamp.child = value;
        }
    }

    public Gtk.ListBox row_box {
        get {
            return list_box;
        }
    }

    public string page_title { get; set; }

    public string page_subtitle { get; set; }

    uint32 total_visible_rows = 0;

    construct {
        assert (nav_view != null);

        search_entry.search_changed.connect (() => {
            apply_filter ();
        });

        search_button.notify["active"].connect (() => {
            if (!search_button.active) {
                search_entry.text = "";
            }
        });

        nav_view.popped.connect ((page) => {
            if (page != this) {
                refresh ();
            }
        });

        list_box.set_filter_func ((row) => {
            if (filter (row, search_entry.text)) {
                total_visible_rows += 1;
                return true;

            } else {
                return false;
            }
        });

        refresh ();
    }

    public void refresh () {
        Idle.add_once (() => {
            update_list ();

            apply_filter ();
        });
    }

    protected abstract void update_list ();

    void apply_filter () {
        total_visible_rows = 0;

        list_box.invalidate_filter ();

        if (total_visible_rows == 0) {
            list_stack.visible_child_name = "has-not";

        } else {
            list_stack.visible_child_name = "has";
        }
    }

    protected abstract bool filter (Gtk.ListBoxRow row, string search_text);
}
