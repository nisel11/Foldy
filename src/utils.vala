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

    public string[] get_installed_categories () {
        var app_infos = AppInfo.get_all ();

        var categiries = new Gee.HashSet<string> ();

        foreach (var app_info in app_infos) {
            categiries.add_all_array (app_info.get_categories ());
        }

        return categiries.to_array ();
    }
}
