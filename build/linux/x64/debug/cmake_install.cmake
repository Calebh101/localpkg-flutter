<<<<<<< HEAD
# Install script for directory: /home/caleb/projects/localpkg/localpkg-flutter/linux

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/usr/local")
=======
# Install script for directory: /home/caleb/projects/flutter/localpkg-flutter/linux

# Set the install prefix
if(NOT DEFINED CMAKE_INSTALL_PREFIX)
  set(CMAKE_INSTALL_PREFIX "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
endif()
string(REGEX REPLACE "/$" "" CMAKE_INSTALL_PREFIX "${CMAKE_INSTALL_PREFIX}")

# Set the install configuration name.
if(NOT DEFINED CMAKE_INSTALL_CONFIG_NAME)
  if(BUILD_TYPE)
    string(REGEX REPLACE "^[^A-Za-z0-9_]+" ""
           CMAKE_INSTALL_CONFIG_NAME "${BUILD_TYPE}")
  else()
    set(CMAKE_INSTALL_CONFIG_NAME "Debug")
  endif()
  message(STATUS "Install configuration: \"${CMAKE_INSTALL_CONFIG_NAME}\"")
endif()

# Set the component getting installed.
if(NOT CMAKE_INSTALL_COMPONENT)
  if(COMPONENT)
    message(STATUS "Install component: \"${COMPONENT}\"")
    set(CMAKE_INSTALL_COMPONENT "${COMPONENT}")
  else()
    set(CMAKE_INSTALL_COMPONENT)
  endif()
endif()

# Install shared libraries without execute permission?
if(NOT DEFINED CMAKE_INSTALL_SO_NO_EXE)
  set(CMAKE_INSTALL_SO_NO_EXE "1")
endif()

# Is this installation the result of a crosscompile?
if(NOT DEFINED CMAKE_CROSSCOMPILING)
  set(CMAKE_CROSSCOMPILING "FALSE")
endif()

# Set default install directory permissions.
if(NOT DEFINED CMAKE_OBJDUMP)
  set(CMAKE_OBJDUMP "/usr/bin/objdump")
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  
<<<<<<< HEAD
  file(REMOVE_RECURSE "/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/bundle/")
=======
  file(REMOVE_RECURSE "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
<<<<<<< HEAD
  if(EXISTS "$ENV{DESTDIR}/usr/local/localpkg" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/localpkg")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/usr/local/localpkg"
         RPATH "$ORIGIN/lib")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/usr/local/localpkg")
=======
  if(EXISTS "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg")
    file(RPATH_CHECK
         FILE "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg"
         RPATH "$ORIGIN/lib")
  endif()
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
   "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
  file(INSTALL DESTINATION "/usr/local" TYPE EXECUTABLE FILES "/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/intermediates_do_not_run/localpkg")
  if(EXISTS "$ENV{DESTDIR}/usr/local/localpkg" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/usr/local/localpkg")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/usr/local/localpkg"
         OLD_RPATH "/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/plugins/url_launcher_linux:/home/caleb/projects/localpkg/localpkg-flutter/linux/flutter/ephemeral:"
         NEW_RPATH "$ORIGIN/lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/usr/local/localpkg")
=======
  file(INSTALL DESTINATION "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle" TYPE EXECUTABLE FILES "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/intermediates_do_not_run/localpkg")
  if(EXISTS "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg" AND
     NOT IS_SYMLINK "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg")
    file(RPATH_CHANGE
         FILE "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg"
         OLD_RPATH "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/plugins/url_launcher_linux:/home/caleb/projects/flutter/localpkg-flutter/linux/flutter/ephemeral:"
         NEW_RPATH "$ORIGIN/lib")
    if(CMAKE_INSTALL_DO_STRIP)
      execute_process(COMMAND "/usr/bin/strip" "$ENV{DESTDIR}/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/localpkg")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
    endif()
  endif()
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/usr/local/data/icudtl.dat")
=======
   "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/data/icudtl.dat")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
  file(INSTALL DESTINATION "/usr/local/data" TYPE FILE FILES "/home/caleb/projects/localpkg/localpkg-flutter/linux/flutter/ephemeral/icudtl.dat")
=======
  file(INSTALL DESTINATION "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/data" TYPE FILE FILES "/home/caleb/projects/flutter/localpkg-flutter/linux/flutter/ephemeral/icudtl.dat")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/usr/local/lib/libflutter_linux_gtk.so")
=======
   "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/lib/libflutter_linux_gtk.so")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
  file(INSTALL DESTINATION "/usr/local/lib" TYPE FILE FILES "/home/caleb/projects/localpkg/localpkg-flutter/linux/flutter/ephemeral/libflutter_linux_gtk.so")
=======
  file(INSTALL DESTINATION "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/lib" TYPE FILE FILES "/home/caleb/projects/flutter/localpkg-flutter/linux/flutter/ephemeral/libflutter_linux_gtk.so")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/usr/local/lib/liburl_launcher_linux_plugin.so")
=======
   "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/lib/liburl_launcher_linux_plugin.so")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
  file(INSTALL DESTINATION "/usr/local/lib" TYPE FILE FILES "/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/plugins/url_launcher_linux/liburl_launcher_linux_plugin.so")
=======
  file(INSTALL DESTINATION "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/lib" TYPE FILE FILES "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/plugins/url_launcher_linux/liburl_launcher_linux_plugin.so")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/usr/local/lib/")
=======
   "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/lib/")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
  file(INSTALL DESTINATION "/usr/local/lib" TYPE DIRECTORY FILES "/home/caleb/projects/localpkg/localpkg-flutter/build/native_assets/linux/")
=======
  file(INSTALL DESTINATION "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/lib" TYPE DIRECTORY FILES "/home/caleb/projects/flutter/localpkg-flutter/build/native_assets/linux/")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  
<<<<<<< HEAD
  file(REMOVE_RECURSE "/usr/local/data/flutter_assets")
=======
  file(REMOVE_RECURSE "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/data/flutter_assets")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  
endif()

if(CMAKE_INSTALL_COMPONENT STREQUAL "Runtime" OR NOT CMAKE_INSTALL_COMPONENT)
  list(APPEND CMAKE_ABSOLUTE_DESTINATION_FILES
<<<<<<< HEAD
   "/usr/local/data/flutter_assets")
=======
   "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/data/flutter_assets")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
  if(CMAKE_WARN_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(WARNING "ABSOLUTE path INSTALL DESTINATION : ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
  if(CMAKE_ERROR_ON_ABSOLUTE_INSTALL_DESTINATION)
    message(FATAL_ERROR "ABSOLUTE path INSTALL DESTINATION forbidden (by caller): ${CMAKE_ABSOLUTE_DESTINATION_FILES}")
  endif()
<<<<<<< HEAD
  file(INSTALL DESTINATION "/usr/local/data" TYPE DIRECTORY FILES "/home/caleb/projects/localpkg/localpkg-flutter/build//flutter_assets")
=======
  file(INSTALL DESTINATION "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/bundle/data" TYPE DIRECTORY FILES "/home/caleb/projects/flutter/localpkg-flutter/build//flutter_assets")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
endif()

if(NOT CMAKE_INSTALL_LOCAL_ONLY)
  # Include the install script for each subdirectory.
<<<<<<< HEAD
  include("/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/flutter/cmake_install.cmake")
  include("/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/plugins/url_launcher_linux/cmake_install.cmake")
=======
  include("/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/flutter/cmake_install.cmake")
  include("/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/plugins/url_launcher_linux/cmake_install.cmake")
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a

endif()

if(CMAKE_INSTALL_COMPONENT)
  set(CMAKE_INSTALL_MANIFEST "install_manifest_${CMAKE_INSTALL_COMPONENT}.txt")
else()
  set(CMAKE_INSTALL_MANIFEST "install_manifest.txt")
endif()

string(REPLACE ";" "\n" CMAKE_INSTALL_MANIFEST_CONTENT
       "${CMAKE_INSTALL_MANIFEST_FILES}")
<<<<<<< HEAD
file(WRITE "/home/caleb/projects/localpkg/localpkg-flutter/build/linux/x64/debug/${CMAKE_INSTALL_MANIFEST}"
=======
file(WRITE "/home/caleb/projects/flutter/localpkg-flutter/build/linux/x64/debug/${CMAKE_INSTALL_MANIFEST}"
>>>>>>> 0b419b36b7ef80fd15c723c3f3e9e41db3feb30a
     "${CMAKE_INSTALL_MANIFEST_CONTENT}")
