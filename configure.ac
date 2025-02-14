dnl configure.ac
dnl
dnl xfce4-notifyd - server-side implementation of the fd.o notifications spec
dnl
dnl Copyright (c) 2008 Brian Tarricone <brian@tarricone.org>
dnl Copyright (c) 2019 Simon Steinbeiss <simon@xfce.org>
dnl

m4_define([notifications_spec_version], [1.2])
m4_define([libx11_minimum_version], [1.6.7])
m4_define([glib_minimum_version], [2.68])
m4_define([gtk_minimum_version], [3.22])
m4_define([canberra_minimum_version], [0.30])
m4_define([sqlite_minimum_version], [3.34])

dnl version info
XDT_VERSION_INIT([0.8.2], [git])

dnl init autoconf
AC_INIT([xfce4-notifyd], [xdt_version],
        [https://gitlab.xfce.org/apps/xfce4-notifyd],
        [xfce4-notifyd])
AC_PREREQ([2.59c])
AC_CONFIG_SRCDIR([xfce4-notifyd/main.c])
AC_CONFIG_HEADERS([config.h])
AC_CONFIG_MACRO_DIRS([m4])
m4_ifdef([AM_SILENT_RULES], [AM_SILENT_RULES([yes])])

dnl init automake
AM_INIT_AUTOMAKE([1.11 dist-bzip2 tar-ustar no-dist-gzip subdir-objects foreign])
AM_MAINTAINER_MODE()

dnl set helper path prefix
AC_ARG_WITH([helper-path-prefix],
            [AS_HELP_STRING([--with-helper-path-prefix=PATH],[Path prefix under which helper executables will be installed (default: $libdir)])],
            [HELPER_PATH_PREFIX="$withval"],
            [HELPER_PATH_PREFIX="$libdir"])
AC_SUBST([HELPER_PATH_PREFIX])

dnl check for UNIX variants
AC_USE_SYSTEM_EXTENSIONS()

dnl check for basic programs
AC_PROG_CC()
AM_PROG_CC_C_O()
LT_PATH_LD([])
AC_PROG_INSTALL()
LT_PREREQ([2.2.6])
LT_INIT([disable-static])

dnl check for standard header files
AC_CHECK_HEADERS([errno.h fcntl.h  grp.h signal.h stdlib.h string.h \
                  sys/stat.h sys/time.h sys/types.h sys/wait.h \
                  unistd.h math.h])

dnl Check for i18n support
GETTEXT_PACKAGE="$PACKAGE"
AC_DEFINE_UNQUOTED([GETTEXT_PACKAGE], ["$GETTEXT_PACKAGE"], [Name of default gettext domain])
AC_SUBST([GETTEXT_PACKAGE])
AM_GNU_GETTEXT([external])
AM_GNU_GETTEXT_VERSION([0.20])

dnl check for required packages
XDT_CHECK_PACKAGE([GIO], [gio-2.0], [glib_minimum_version])
XDT_CHECK_PACKAGE([GIO_UNIX], [gio-unix-2.0], [glib_minimum_version])
XDT_CHECK_PACKAGE([GLIB], [glib-2.0], [glib_minimum_version])
XDT_CHECK_PACKAGE([GTK], [gtk+-3.0], [gtk_minimum_version])
XDT_CHECK_PACKAGE([LIBNOTIFY], [libnotify], [0.7.0])
XDT_CHECK_PACKAGE([LIBXFCE4PANEL], [libxfce4panel-2.0], [4.14.0])
XDT_CHECK_PACKAGE([LIBXFCE4UI], [libxfce4ui-2], [4.12.0])
XDT_CHECK_PACKAGE([LIBXFCE4UTIL], [libxfce4util-1.0], [4.12.0])
XDT_CHECK_PACKAGE([XFCONF], [libxfconf-0], [4.10.0])
XDT_CHECK_PACKAGE([SQLITE], [sqlite3], [sqlite_minimum_version])

XDT_CHECK_OPTIONAL_FEATURE([X11],
                           [x11],
                           [
                               XDT_FEATURE_DEPENDENCY([LIBX11], [x11], [libx11_minimum_version])
                               XDT_FEATURE_DEPENDENCY([GDK_X11], [gdk-x11-3.0], [gtk_minimum_version])
                           ],
                           [the X11 windowing system])

XDT_CHECK_OPTIONAL_FEATURE([WAYLAND],
                           [wayland],
                           [
                               XDT_FEATURE_DEPENDENCY([GDK_WAYLAND], [gdk-wayland-3.0], [gtk_minimum_version])
                               XDT_FEATURE_DEPENDENCY([GTK_LAYER_SHELL], [gtk-layer-shell-0], [0.7.0])
                           ],
                           [the Wayland windowing system])

XDT_CHECK_OPTIONAL_FEATURE([SOUND],
                           [sound],
                           [XDT_FEATURE_DEPENDENCY([CANBERRA_GTK], [libcanberra-gtk3], [canberra_minimum_version])],
                           [notification sound])

XDT_CHECK_PACKAGE_BINARY([GDBUS_CODEGEN], [gio-2.0], [gdbus_codegen], [gdbus-codegen])
XDT_CHECK_PACKAGE_BINARY([GLIB_COMPILE_RESOURCES], [gio-2.0], [glib_compile_resources], [glib-compile-resources])
XDT_CHECK_PACKAGE_BINARY([GLIB_GENMARSHAL], [glib-2.0], [glib_genmarshal], [glib-genmarshal])
XDT_CHECK_PACKAGE_BINARY([GLIB_MKENUMS], [glib-2.0], [glib_mkenums], [glib-mkenums])

dnl dbus start daemon
AC_ARG_ENABLE([dbus-start-daemon],
              [AS_HELP_STRING([--enable-dbus-start-daemon],
                              [Start daemon via DBus instead of regular session autostart. (default=no)])],
              [use_dbus_start_daemon=$enableval], [use_dbus_start_daemon=no])
AM_CONDITIONAL([USE_DBUS_START_DAEMON],
               [test "x$use_dbus_start_daemon" = "xyes"])

dnl create #define for spec version
AC_DEFINE_UNQUOTED([NOTIFICATIONS_SPEC_VERSION], ["notifications_spec_version"],
                   [Set to the version of the freedesktop.org notifications spec we support])

dnl check for debugging support
XDT_FEATURE_DEBUG([xdt_debug_default])

AC_CONFIG_FILES(
[
    Makefile
    icons/Makefile
    icons/16x16/Makefile
    icons/48x48/Makefile
    icons/128x128/Makefile
    icons/scalable/Makefile
    icons/symbolic/Makefile
    common/Makefile
    panel-plugin/Makefile
    po/Makefile.in
    themes/Makefile
    tests/Makefile
    xfce4-notifyd/Makefile
    xfce4-notifyd-config/Makefile
])
AC_OUTPUT

dnl ***************************
dnl *** Print configuration ***
dnl ***************************
echo
echo "Build Configuration:"
echo
echo "* Installation prefix:       $libdir"
echo "* Debug Support:             $enable_debug"
echo "* X11 Support:               $ENABLE_X11"
echo "* Wayland Support:           $ENABLE_WAYLAND"
echo "* Sound support:             $ENABLE_SOUND"
if test "x$use_dbus_start_daemon" = "xyes"; then
echo "* Startup method:            DBus"
else
echo "* Startup method:            Autostart"
fi
echo
