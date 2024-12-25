/*
 * Copyright (C) 2024 Vladimir Vaskov
 * 
 * This program is free software: you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation, either version 3 of the License, or
 * (at your option) any later version.
 * 
 * This program is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
 * GNU General Public License for more details.
 * 
 * You should have received a copy of the GNU General Public License
 * along with this program. If not, see <https://www.gnu.org/licenses/>.
 * 
 * SPDX-License-Identifier: GPL-3.0-or-later
 */

public sealed class Foldy.FoldyD.Folder : Object {

    public string folder_id { get; construct; }

    public string[] apps { get; set; }

    public string[] excluded_apps { get; set; }

    public string[] categories { get; set; }

    public string name { get; set; }

    public bool translate { get; set; }

    public bool should_fix_categories { private get; construct; default = false; }

    Settings settings;

    public Folder (string folder_id) {
        Object (folder_id: folder_id);
    }

    public Folder.with_categories_fix (string folder_id) {
        Object (folder_id: folder_id, should_fix_categories: true);
    }

    ~Folder () {
        settings.reset ("name");
        settings.reset ("translate");
        settings.reset ("categories");
        settings.reset ("apps");
        settings.reset ("excluded_apps");
    }

    construct {
        apps = Foldy.Folder.get_folder_apps (folder_id);
        excluded_apps = Foldy.Folder.get_folder_excluded_apps (folder_id);
        categories = Foldy.Folder.get_folder_categories (folder_id);
        name = Foldy.Folder.get_folder_name (folder_id);
        translate = Foldy.Folder.get_folder_translate (folder_id);

        settings = Foldy.Folder.get_folder_settings (folder_id);

        settings.changed["name"].connect (() => {
            name = Foldy.Folder.get_folder_name (folder_id);
        });
        settings.changed["translate"].connect (() => {
            translate = Foldy.Folder.get_folder_translate (folder_id);
        });
        settings.changed["excluded-apps"].connect (() => {
            categories = Foldy.Folder.get_folder_categories (folder_id);
        });
        settings.changed["apps"].connect (() => {
            apps = Foldy.Folder.get_folder_apps (folder_id);
        });
        settings.changed["categories"].connect (refresh);

        AppInfoMonitor.get ().changed.connect (refresh);

        if (should_fix_categories) {
            var new_apps = new Gee.ArrayList<string> ();
            new_apps.add_all_array (apps);

            foreach (string category in categories) {
                foreach (string app_id in get_app_ids_by_category (category)) {
                    if (!(app_id in new_apps) && !(app_id in excluded_apps)) {
                        new_apps.add (app_id);
                    }
                }
            }

            Foldy.Folder.set_folder_apps (folder_id, new_apps.to_array ());
        }
    }

    void refresh () {
        var new_categories = Foldy.Folder.get_folder_categories (folder_id);

        var removed_category = new Gee.ArrayList<string> ();
        var added_category = new Gee.ArrayList<string> ();

        foreach (string old_category in categories) {
            if (!(old_category in new_categories)) {
                removed_category.add (old_category);
                debug ("Removed %s category", old_category);
            }
        }

        foreach (string new_category in new_categories) {
            if (!(new_category in categories)) {
                added_category.add (new_category);
                debug ("Added %s category", new_category);
            }
        }

        var need_to_remove = new Gee.ArrayList<string> ();
        foreach (string category in removed_category) {
            var app_ids = get_app_ids_by_category (category);

            foreach (var app_id in app_ids) {
                if (app_id in apps) {
                    need_to_remove.add (app_id);
                }
            }
        }
        Foldy.Folder.remove_folder_apps (folder_id, need_to_remove.to_array ());

        var need_to_add = new Gee.ArrayList<string> ();
        foreach (string category in added_category) {
            var app_ids = get_app_ids_by_category (category);

            foreach (var app_id in app_ids) {
                if (!(app_id in excluded_apps) && !(app_id in apps)) {
                    need_to_add.add (app_id);
                }
            }
        }
        Foldy.Folder.add_folder_apps (folder_id, need_to_add.to_array ());
        //  foreach (var other_folder_id in get_folders ()) {
        //      if (other_folder_id == folder_id) {
        //          continue;
        //      }

        //      Foldy.Folder.remove_folder_apps (other_folder_id, need_to_add.to_array ());
        //  }

        categories = new_categories;
    }
}
