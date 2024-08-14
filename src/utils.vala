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

namespace Foldy {

    // Folder name

    static string get_folder_name (string folder_id) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        return settings.get_string ("name");
    }

    static void set_folder_name (string folder_id, string folder_name) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        settings.set_string ("name", folder_name);
    }

    // Folder categories

    static string[] get_folder_categories (string folder_id) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        return settings.get_strv ("categories");
    }

    static void set_folder_categories (string folder_id, string[]? folder_categories) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        settings.set_strv ("categories", folder_categories);
    }

    // Folder translate

    static bool get_folder_translate (string folder_id) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        return settings.get_boolean ("translate");
    }

    static void set_folder_translate (string folder_id, bool folder_translate) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        settings.set_boolean ("translate", folder_translate);
    }

    // Folder apps

    static string[] get_folder_apps (string folder_id) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        return settings.get_strv ("apps");
    }

    static void set_folder_apps (string folder_id, string[]? new_apps) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        settings.set_strv ("apps", new_apps);
    }

    static void add_apps_to_folder (string folder_id, string[] add_apps) {
        if (!folder_exists (folder_id)) {
            create_folder_with_id (folder_id);
        }

        var current_apps = get_folder_apps (folder_id);

        var builder = new StrvBuilder ();

        builder.addv (current_apps);
        foreach (var add_app in add_apps) {
            builder.add (add_app);
        }

        set_folder_apps (folder_id, builder.end ());
    }

    static void add_app_to_folder (string folder_id, string add_app) {
        if (!folder_exists (folder_id)) {
            create_folder_with_id (folder_id);
        }

        var current_apps = get_folder_apps (folder_id);

        var builder = new StrvBuilder ();

        builder.addv (current_apps);
        builder.add (add_app);

        set_folder_apps (folder_id, builder.end ());
    }

    static void remove_apps_from_folder (string folder_id, string[] rm_apps) {
        var current_apps = get_folder_apps (folder_id);

        var builder = new StrvBuilder ();

        foreach (string app in current_apps) {
            if (!(app in rm_apps)) {
                builder.add (app);
            }
        }

        set_folder_apps (folder_id, builder.end ());
    }

    static void remove_app_from_folder (string folder_id, string rm_app) {
        var current_apps = get_folder_apps (folder_id);

        var builder = new StrvBuilder ();

        foreach (string app in current_apps) {
            if (app != rm_app) {
                builder.add (app);
            }
        }

        set_folder_apps (folder_id, builder.end ());
    }

    // Folder exclude apps

    static string[] get_folder_excluded_apps (string folder_id) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        return settings.get_strv ("excluded-apps");
    }

    static void set_folder_excluded_apps (string folder_id, string[]? new_excluded_apps) {
        var settings = new Settings.with_path ("org.gnome.desktop.app-folders.folder",
                                               "/org/gnome/desktop/app-folders/folders/%s/".printf (folder_id));

        settings.set_strv ("excluded-apps", new_excluded_apps);
    }

    static void add_excluded_app_to_folder (string folder_id, string add_app) {
        var current_excluded_apps = get_folder_excluded_apps (folder_id);

        var builder = new StrvBuilder ();

        builder.addv (current_excluded_apps);
        builder.add (add_app);

        set_folder_excluded_apps (folder_id, builder.end ());
    }

    static void remove_excluded_app_from_folder (string folder_id, string rm_app) {
        var current_excluded_apps = get_folder_excluded_apps (folder_id);

        var builder = new StrvBuilder ();

        foreach (string app in current_excluded_apps) {
            if (app != rm_app) {
                builder.add (app);
            }
        }

        set_folder_excluded_apps (folder_id, builder.end ());
    }

    // Folders

    static string[] get_folders () {
        var settings = new Settings ("org.gnome.desktop.app-folders");

        return settings.get_strv ("folder-children");
    }

    static void set_folders (string[]? new_folders) {
        var settings = new Settings ("org.gnome.desktop.app-folders");

        settings.set_strv ("folder-children", new_folders);
    }

    static bool folder_exists (string folder_id) {
        return folder_id in get_folders ();
    }

    static void create_folder_with_id (string folder_id) {
        var folders = get_folders ();

        var builder = new StrvBuilder ();

        builder.addv (folders);
        builder.add (folder_id);

        set_folders (builder.end ());
        set_folder_name (folder_id, _("Unnamed Folder"));
    }

    static string create_folder () {
        var uuid = Uuid.string_random ();

        create_folder_with_id (uuid);

        return uuid;
    }

    static void remove_folder (string rm_folder_id) {
        var current_folders = get_folders ();

        var builder = new StrvBuilder ();

        foreach (string folder_id in current_folders) {
            if (folder_id != rm_folder_id) {
                builder.add (folder_id);
            }
        }

        set_folders (builder.end ());
    }
}
