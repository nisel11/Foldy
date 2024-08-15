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
public sealed class Foldy.FolderPage : BasePage {

    [GtkChild]
    unowned Gtk.Button delete_button;
    [GtkChild]
    unowned Gtk.Button delete_selected_button;
    [GtkChild]
    unowned Gtk.Stack bottom_stack;
    [GtkChild]
    unowned Gtk.Revealer delete_revealer;
    [GtkChild]
    unowned Gtk.Revealer settings_revealer;
    [GtkChild]
    unowned Gtk.Button folder_settings_button;
    [GtkChild]
    unowned Gtk.Button add_apps_button;

    Array<AppRow> app_rows = new Array<AppRow> ();

    public string folder_id { get; construct; }

    Settings settings;

    public FolderPage (Adw.NavigationView nav_view, string folder_id) {
        Object (nav_view: nav_view, folder_id: folder_id);
    }

    construct {
        bind_property (
            "selection-enabled",
            bottom_stack,
            "visible-child-name",
            BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE,
            (binding, srcval, ref trgval) => {
                trgval.set_string (srcval.get_boolean () ? "selection-mode" : "delete-button");
            }
        );

        page_subtitle = folder_id;

        bind_property (
            "selection-enabled",
            delete_revealer,
            "reveal-child",
            BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN
        );

        bind_property (
            "selection-enabled",
            settings_revealer,
            "reveal-child",
            BindingFlags.DEFAULT | BindingFlags.SYNC_CREATE | BindingFlags.INVERT_BOOLEAN
        );

        delete_button.clicked.connect (() => {
            var dialog = new Adw.AlertDialog (_("Are you want to delete folder '%s'?".printf (
                get_folder_name (folder_id)
            )), null);

            dialog.add_response ("no", _("Cancel"));
            dialog.add_response ("yes", _("Delete"));

            dialog.set_response_appearance ("yes", Adw.ResponseAppearance.DESTRUCTIVE);

            dialog.default_response = "no";
            dialog.close_response = "no";

            dialog.response.connect ((resp) => {
                if (resp == "yes") {
                    remove_folder (folder_id);
                    nav_view.pop ();
                }
            });

            dialog.present (this);
        });

        add_apps_button.clicked.connect (add_apps);

        delete_selected_button.clicked.connect (() => {
            remove_apps_from_folder (folder_id, get_selected_apps ());
            selection_enabled = false;
        });

        folder_settings_button.clicked.connect (() => {
            new EditFolderDialog (folder_id).present (this);
        });

        AppInfoMonitor.get ().changed.connect (refresh);

        settings = new Settings.with_path (
            "org.gnome.desktop.app-folders.folder", 
            "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id)
        );

        settings.changed.connect ((key) => {
            refresh ();
        });

        nav_view.popped.connect (() => {
            if (get_folder_apps (folder_id).length == 0) {
                remove_folder (folder_id);
                nav_view.pop_to_tag ("main");
            }
        });

        if (get_folder_apps (folder_id).length == 0) {
            Idle.add_once (add_apps);
        }
    }

    void add_apps () {
        nav_view.push (new AddAppsPage (nav_view, folder_id));
    }

    string[] get_selected_apps () {
        var row_ids = new Array<string> ();

        foreach (var row in app_rows.data) {
            var app_row = (AppRow) row;

            if (app_row.selected) {
                row_ids.append_val (app_row.app_info.get_id ());
            }
        }

        return row_ids.data;
    }

    protected override void update_list () {
        page_title = get_folder_name (folder_id);

        app_rows = new Array<AppRow> ();
        row_box.remove_all ();

        update_list_async.begin ();
    }

    async void update_list_async () {
        var app_infos = AppInfo.get_all ();
        var folder_apps = get_folder_apps (folder_id);

        foreach (AppInfo app_info in app_infos) {
            if (app_info.get_id () in folder_apps) {
                var app_row = new AppRow (app_info);

                bind_property (
                    "selection-enabled",
                    app_row,
                    "selection-enabled",
                    BindingFlags.BIDIRECTIONAL | BindingFlags.SYNC_CREATE
                );

                app_row.notify ["selected"].connect (() => {
                    if (get_selected_apps ().length == 0) {
                        selection_enabled = false;
                    }
                });

                app_rows.append_val (app_row);
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
