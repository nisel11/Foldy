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

public sealed class Foldy.DesktopFileReader: Object {

    public string filepath { get; construct; }

    DesktopFileReader (string filepath) {
        Object (filepath: filepath);
    }

    public static DesktopFileReader? create_with_filename (string filename) {
        string? output = null;

        try {
            Process.spawn_command_line_sync ("find /usr/share/applications/ /usr/local/share/applications/ /home/rirusha/.local/share/applications/ /var/lib/flatpak/exports/share/applications/ /home/rirusha/.local/share/flatpak/exports/share/applications/ -name \"%s\"".printf (
                filename
            ), out output);
        } catch (Error e) {
            warning ("Can't find");
        }

        if (output != null) {
            if (output.strip () != "") {
                return new DesktopFileReader (output.strip ().split ("\n")[0].strip ());
            }
        }

        return null;
    }

    string read_file () {
        var file = File.new_for_path (filepath);

        string content = "";

        try {
            uint8[] data;
            file.load_contents (null, out data, null);
            content = (string) data;

        } catch (Error e) {
            warning (
                "Can't read file %s. Error message: %s",
                filepath,
                e.message
            );
        }

        return content;
    }

    public string read_icon_name () {
        string icon_name = "";

        try {
            var regex = new Regex (
                "Icon\\s*=\\s*(.+)",
                RegexCompileFlags.OPTIMIZE,
                RegexMatchFlags.NOTEMPTY
            );

            MatchInfo match_info;
            if (regex.match (read_file (), 0, out match_info)) {
                icon_name = match_info.fetch (1);
            }

        } catch (Error e) {}

        return icon_name;
    }

    public string read_name () {
        string name = "";

        try {
            var regex = new Regex (
                "Name\\s*=\\s*(.+)",
                RegexCompileFlags.OPTIMIZE,
                RegexMatchFlags.NOTEMPTY
            );

            MatchInfo match_info;
            if (regex.match (read_file (), 0, out match_info)) {
                name = match_info.fetch (1);
            }

        } catch (Error e) {}

        return name;
    }
}
