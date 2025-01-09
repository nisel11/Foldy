%define _unpackaged_files_terminate_build 1
%define app_id org.altlinux.Foldy

Name: foldy
Version: @LAST@
Release: alt1

Summary: Folder manager for mobile devices
License: GPL-3.0-or-later
Group: Other
Url: https://github.com/alt-gnome/Foldy
Vcs: https://github.com/alt-gnome/Foldy.git

Source0: %name-%version.tar

BuildRequires(pre): rpm-macros-meson rpm-build-vala
BuildRequires: meson
BuildRequires: vala
BuildRequires: pkgconfig(libadwaita-1) >= 1.6
BuildRequires: pkgconfig(gio-unix-2.0) >= 2.76
BuildRequires: pkgconfig(gee-0.8)
BuildRequires: pkgconfig(libfoldy-1) >= 1.8
BuildRequires: vapi(libfoldy-1)
BuildRequires: blueprint-compiler
%{?_enable_check:BuildRequires: /usr/bin/appstreamcli desktop-file-utils}

%description
Folder manager for mobile devices

%prep
%setup

%build
%meson
%meson_build

%install
%meson_install
%find_lang %name --with-gnome

%check
export AS_VALIDATE_NONET="true"
%meson_test

%files -f %name.lang
%_bindir/%name
%_datadir/metainfo/%app_id.metainfo.xml
%_datadir/glib-2.0/schemas/%app_id.gschema.xml
%_desktopdir/%app_id.desktop
%_iconsdir/hicolor/*/apps/*.svg
%doc README.md
