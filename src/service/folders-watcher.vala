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

public sealed class Foldy.FoldyD.FoldersWatcher : Object {

    Settings folders_settings;

    Gee.ArrayList<Folder> folder_datas;

    construct {
        folders_settings = Foldy.get_folders_settings ();
        folder_datas = new Gee.ArrayList<Folder> ((a, b) => {
            return a.folder_id == b.folder_id;
        });

        foreach (string folder_id in Foldy.get_folders ()) {
            folder_datas.add (new Folder (folder_id));
        }
    }

    void folders_changed () {
        string[] folders = Foldy.get_folders ();

        foreach (var folder_data in folder_datas) {
            if (!(folder_data.folder_id in folders)) {
                folder_datas.remove (folder_data);
            }
        }

        foreach (string folder_id in folders) {
            bool has = false;

            foreach (var folder_data in folder_datas) {
                if (folder_data.folder_id == folder_id) {
                    has = true;
                }
            }

            if (!has) {
                folder_datas.add (new Folder.with_categories_fix (folder_id));
            }
        }
    }

    public void run () {
        folders_settings.changed["folder-children"].connect (folders_changed);
    }
}
