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

using Foldy.Folder;

namespace Foldy {
    public AppInfo[] get_unfolder_apps () {
        var app_infos = AppInfo.get_all ();

        var result_app_infos = new Gee.ArrayList<AppInfo> ();
        var good_app_ids = new Gee.ArrayList<string> ();

        foreach (var app_info in app_infos) {
            good_app_ids.add (app_info.get_id ());
        }

        foreach (string folder_id in get_folders ()) {
            foreach (var app_id in get_folder_apps (folder_id)) {
                if (app_id in good_app_ids) {
                    good_app_ids.remove (app_id);
                }
            }
        }

        foreach (var app_info in app_infos) {
            if (app_info.get_id () in good_app_ids && app_info.should_show ()) {
                result_app_infos.add (app_info);
            }
        }

        return result_app_infos.to_array ();
    }

    public string[] get_installed_categories (string? exclude_folder_id) {
        var app_infos = AppInfo.get_all ();

        var categiries = new Gee.HashSet<string> ();

        foreach (var app_info in app_infos) {
            categiries.add_all (get_categories_by_app_id (app_info.get_id ()));
        }

        categiries.remove_all (get_using_categories ());

        if (exclude_folder_id != null) {
            categiries.add_all_array (get_folder_categories (exclude_folder_id));
        }

        return categiries.to_array ();
    }

    Gee.HashSet<string> get_using_categories () {
        var result = new Gee.HashSet<string> ();

        foreach (var folder_id in get_folders ()) {
            result.add_all_array (get_folder_categories (folder_id));
        }

        return result;
    }

    Gee.ArrayList<string> get_categories_by_app_id (string app_id) {
        var categories = new Gee.ArrayList<string> ();

        var desktop = new DesktopAppInfo (app_id);
        string? categories_string = desktop.get_categories ();

        if (categories_string == null) {
            return categories;
        }

        if (categories_string.length == 0) {
            return categories;
        }

        var raw_categories = categories_string.split (";");

        foreach (var raw_category in raw_categories) {
            if (raw_category.length > 0) {
                categories.add (raw_category);
            }
        }

        return categories;
    }

    string[] get_app_ids_by_category (string category) {
        var app_ids = new Array<string> ();

        foreach (AppInfo app_info in AppInfo.get_all ()) {
            string app_id = app_info.get_id ();

            if (category in get_categories_by_app_id (app_id)) {
                app_ids.append_val (app_id);
            }
        }

        return app_ids.data;
    }
}
