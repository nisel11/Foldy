vapi_sources = files(
  'config.vapi',
)

foldy_sources = [vapi_sources, blueprints, resources] + files(
  'service/folder-data.vala',
  'service/folders-watcher.vala',
  'add-apps-page.vala',
  'app-info-dialog.vala',
  'app-row-add.vala',
  'app-row-remove.vala',
  'app-row.vala',
  'application.vala',
  'base-page.vala',
  'categories-list.vala',
  'categories-model.vala',
  'category-row.vala',
  'folder-dialog.vala',
  'folder-page.vala',
  'folder-row.vala',
  'folders-list-page.vala',
  'main.vala',
  'utils.vala',
  'window.vala',
)

foldy_vala_args = [
  '--target-glib', '2.76',
  '--vapidir', meson.current_source_dir(),
  '--gresources', resource_files,
  '--gresourcesdir=data/',
]

foldy_c_args = [
  '-include', 'config.h',
]

executable(
  'foldy',
  foldy_sources,
  include_directories: config_h_dir,
  vala_args: foldy_vala_args,
  c_args: foldy_c_args,
  dependencies: foldy_dependencies,
  install: true,
)
