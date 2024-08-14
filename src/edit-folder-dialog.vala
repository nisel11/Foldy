/*
 * Copyright 2024 Rirusha
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

[GtkTemplate (ui = "/io/github/Rirusha/Foldy/ui/edit-folder-dialog.ui")]
public sealed class Foldy.EditFolderDialog : Adw.Dialog {

    [GtkChild]
    unowned Adw.ToastOverlay toast_overlay;
    [GtkChild]
    unowned Adw.EntryRow folder_name_entry;
    [GtkChild]
    unowned Adw.ExpanderRow folder_categories_expander;
    [GtkChild]
    unowned Gtk.Button apply_button;

    public string folder_id { get; construct; }

    public EditFolderDialog (string folder_id) {
        Object (folder_id: folder_id);
    }

    construct {
        folder_name_entry.text = get_folder_name (folder_id);

        var folder_categories = get_folder_categories (folder_id);
        if (folder_categories.length > 0) {
            foreach (string category in folder_categories) {
                folder_categories_expander.add_row (new Adw.ActionRow () {
                    title = category
                });
            }
        } else {
            folder_categories_expander.sensitive = false;
            folder_categories_expander.subtitle = _("No categories");
        }

        apply_button.clicked.connect (() => {
            if (apply_changed ()) {
                close ();
            }
        });
    }

    bool apply_changed () {
        if (folder_name_entry.text == "") {
            toast_overlay.add_toast (new Adw.Toast (_("Name can't be empty")));
            folder_name_entry.text = get_folder_name (folder_id);
            folder_name_entry.focus (Gtk.DirectionType.DOWN);
            return false;
        }

        set_folder_name (folder_id, folder_name_entry.text);
        return true;
    }
}
