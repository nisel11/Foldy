project(
  'foldy',
  ['c', 'vala'],
  version: '0.2.0.beta',
  meson_version: '>= 0.62.0',
  license: 'GPL-3.0-or-later',
)

i18n = import('i18n')
gnome = import('gnome')

libadwaita_dep = dependency('libadwaita-1', version: '>= 1.6')
gio_dep = dependency('gio-unix-2.0', version: '>= ' + '2.76')
gee_dep = dependency('gee-0.8')
libfoldy_dep = dependency('libfoldy-1', version: '>= 1.6', fallback : ['libfoldy-1', 'lib_dep'])
libicons_cache_dep = dependency(
  'libicons-cache-gtk4-1',
  version: '>= 1.4',
  default_options: ['gtk_target_version=gtk4'],
  fallback : ['libicons-cache-1', 'lib_dep']
)

app_id = 'org.altlinux.Foldy'

conf = configuration_data()
conf.set_quoted('APP_ID', app_id)
conf.set10('IS_DEVEL', get_option('is_devel'))
conf.set_quoted('G_LOG_DOMAIN', app_id)
conf.set_quoted('PACKAGE_NAME', meson.project_name())
conf.set_quoted('PACKAGE_VERSION', meson.project_version())
conf.set_quoted('VERSION', meson.project_version())
conf.set_quoted('GETTEXT_PACKAGE', meson.project_name())
conf.set_quoted('DATADIR', join_paths(get_option('prefix'), get_option('datadir')))
conf.set_quoted('GNOMELOCALEDIR', join_paths(get_option('prefix'), get_option('localedir')))

subdir('data')

foldy_dependencies = [
  libadwaita_dep,
  gee_dep,
  libfoldy_dep,
  gio_dep,
  libicons_cache_dep,
]

configure_file(output: 'config.h', configuration: conf)
config_h_dir = include_directories('.')

subdir('po')
subdir('src')

gnome.post_install(
  glib_compile_schemas: true,
  gtk_update_icon_cache: true,
  update_desktop_database: true,
)
