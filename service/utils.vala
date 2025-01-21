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
 * along with this program. If not, see <http://www.gnu.org/licenses/>.
 *
 * SPDX-License-Identifier: GPL-3.0-only
 */

namespace FoldyD {
    string[] get_categories_by_app_id (string app_id) {
        var categories = new Gee.ArrayList<string> ();

        var desktop = new DesktopAppInfo (app_id);
        string? categories_string = desktop.get_categories ();

        if (categories_string == null) {
            return {};
        }

        if (categories_string.length == 0) {
            return {};
        }

        var raw_categories = categories_string.split (";");

        foreach (var raw_category in raw_categories) {
            if (raw_category.length > 0) {
                categories.add (raw_category);
            }
        }

        return categories.to_array ();
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
