%define _unpackaged_files_terminate_build 1
%define app_id space.rirusha.Foldy

Name: foldy
Version: 1.0.0
Release: alt1

Summary: Folder manager for mobile devices
License: GPL-3.0-or-later
Group: Development/Tools
Url: https://github.com/alt-gnome-team/Foldy
Vcs: https://github.com/alt-gnome-team/Foldy.git

Source0: %name-%version.tar

BuildRequires(pre): rpm-macros-meson
BuildRequires: meson
BuildRequires: vala
BuildRequires: pkgconfig(libadwaita-1)
BuildRequires: blueprint-compiler
%{?_enable_check:BuildRequires: /usr/bin/appstreamcli desktop-file-utils}

%description
%summary.

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
%doc README.md
%_bindir/%name
%_datadir/metainfo/%app_id.metainfo.xml
%_datadir/glib-2.0/schemas/%app_id.gschema.xml
%_desktopdir/%app_id.desktop
%_iconsdir/hicolor/*/apps/*.svg

%changelog
* Tue Oct 1 2024 Vladimir Vaskov <rirusha@altlinux.org> 1.0.0-alt1
- 1.0.0

* Thu Sep 26 2024 Vladimir Vaskov <rirusha@altlinux.org> 0.2.0.beta-alt1
- 0.2.0.beta

* Wed Sep 25 2024 Vladimir Vaskov <rirusha@altlinux.org> 0.1.7.beta-alt1
- 0.1.7.beta

* Wed Sep 25 2024 Vladimir Vaskov <rirusha@altlinux.org> 0.1.6.beta-alt1
- initial build
