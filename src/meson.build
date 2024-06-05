vapi_sources = files(
  'config.vapi',
)

<<APP-COMMAND-C-NAME>>_sources = [
  vapi_sources,
  blueprints,
  resources
] + files(
  'main.vala',
  'application.vala',
  'main_window.vala',
)

<<APP-COMMAND-C-NAME>>_vala_args = [
  '--target-glib', '2.76',
  '--vapidir', meson.current_source_dir(),
  '--gresources', resource_files,
  '--gresourcesdir=data/'
]

<<APP-COMMAND-C-NAME>>_c_args = [
  '-include', 'config.h',
]

executable(
  '<<APP-COMMAND>>',
  <<APP-COMMAND-C-NAME>>_sources,
  include_directories: config_h_dir,
  vala_args: <<APP-COMMAND-C-NAME>>_vala_args,
  c_args: <<APP-COMMAND-C-NAME>>_c_args,
  dependencies: <<APP-COMMAND-C-NAME>>_dependencies,
  install: true,
)