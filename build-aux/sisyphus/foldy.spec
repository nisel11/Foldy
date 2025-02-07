%define _unpackaged_files_terminate_build 1
%define app_id org.altlinux.Foldy
%define service_name org.altlinux.FoldyService
%define glib_min_version 2.76
%define major_api_version @MAJOR_API_VERSION@
%define minor_api_version @MINOR_API_VERSION@

Name: foldy
Version: @LAST@
Release: alt1

Summary: Folder manager aimed to mobile devices
License: GPL-3.0-or-later
Group: Other
Url: https://github.com/alt-gnome/Foldy
Vcs: https://github.com/alt-gnome/Foldy.git

Source0: %name-%version.tar

Requires: lib%name-%major_api_version = %version-%release
Requires: lib%name-service = %version-%release

BuildRequires(pre): rpm-macros-meson rpm-build-vala rpm-build-gir
BuildRequires: meson
BuildRequires: vala
BuildRequires: pkgconfig(libadwaita-1) >= 1.6
BuildRequires: pkgconfig(gio-unix-2.0) >= glib_min_version
BuildRequires: pkgconfig(gee-0.8)
BuildRequires: vapi(Gee-0.8)
BuildRequires: blueprint-compiler
%{?_enable_check:BuildRequires: /usr/bin/appstreamcli /usr/bin/desktop-file-validate}

%description
%summary.

%project service
Summary: Service for categories fix in GNOME and phosh
Group: Other

%description
%summary.

%project -n lib%name-%major_api_version
Summary: Foldy library
Group: System/Libraries

%description
%summary.

%project -n lib%name-%major_api_version-devel
Summary: Foldy devel files
Group: Development/C

%description
%summary.

%project -n lib%name-%major_api_version-gir
Summary: Foldy typelib files
Group: System/Libraries

%description
%summary.

%project -n lib%name-%major_api_version-gir-devel
Summary: Foldy devel gir files
Group: Development/Other

%description
%summary.

%project -n lib%name-%major_api_version-devel-vala
Summary: Foldy devel files for vala
Group: Development/Other

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
%_bindir/%name
%_datadir/metainfo/%app_id.metainfo.xml
%_datadir/glib-2.0/schemas/%app_id.gschema.xml
%_desktopdir/%app_id.desktop
%_iconsdir/hicolor/*/apps/*.svg
%doc README.md

%files service -f %service_name.lang
%_datadir/dbus-1/services/%service_name.service
%_xdgconfigdir/autostart/%service_name.desktop

%files -n lib%name-%major_api_version
%_libdir/lib%name-%major_api_version.so.*

%files -n lib%name-%major_api_version-devel
%_libdir/lib%name-%major_api_version.so
%_pkgconfigdir/lib%name-%major_api_version.pc
%_includedir/lib%name-%major_api_version.h

%files -n lib%name-%major_api_version-devel
%_libdir/lib%name-%major_api_version.so

%files -n lib%name-%major_api_version-devel-vala
%_vapidir/lib%name-%major_api_version.deps
%_vapidir/lib%name-%major_api_version.vapi

%files -n lib%name-%major_api_version-gir
%_typelibdir/lib%name-%major_api_version.typelib

%files -n lib%name-%major_api_version-gir-devel
%_girdir/lib%name-%major_api_version.gir
