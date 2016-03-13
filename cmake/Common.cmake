###################################################################################################
# prevent in-source build
###################################################################################################
if ("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")
    message (SEND_ERROR "Building in the source directory is prohibited.")
	# Otherwise, the Qt4_auto_moc goes into infinite loop when moc files are moc-ed
    message (FATAL_ERROR "Please remove the created \"CMakeCache.txt\" file, the \"CMakeFiles\" directory and create a build directory and call \"${CMAKE_COMMAND} <path to the sources>\".")
endif ("${CMAKE_BINARY_DIR}" STREQUAL "${CMAKE_SOURCE_DIR}")

###################################################################################################
# only build Debug and Release
###################################################################################################
# set(CMAKE_CONFIGURATION_TYPES "Debug;Release" CACHE STRING "Build Types" FORCE)
# mark_as_advanced (CMAKE_CONFIGURATION_TYPES)

# set Release as default build target, such that Makefile builds are in release mode
if (NOT CMAKE_BUILD_TYPE)
  set (CMAKE_BUILD_TYPE Debug CACHE STRING
      "Choose the default type of build, options are: Debug, Release."
      FORCE)
endif ()
###################################################################################################
# File list gatherer
###################################################################################################
# gather all files with extension "ext" in the "dirs" directories to "ret"
# excludes all files starting with a '.' (dot)
macro (gather_list_by_extension ret ext)
	foreach (_dir ${ARGN})
		file (GLOB _files "${_dir}/${ext}")
		foreach (_file ${_files})
			get_filename_component (_neatname ${_file} ABSOLUTE)
			get_filename_component (_filename ${_file} NAME)
			if (_filename MATCHES "^[.]")
				list (REMOVE_ITEM _files ${_file})
			else()
				list (REMOVE_ITEM _files ${_file})
				list (APPEND _files ${_neatname})
			endif ()
		endforeach ()
		list (APPEND ${ret} ${_files})
	endforeach ()
			
	if (GATHER_LIST_DEBUG)
		message(STATUS "List gathered by extension ${ext} in ${ARGN}")	
		foreach (_filepath ${${ret}})
			message(STATUS "    ${_filepath}")	
		endforeach()
	endif()
endmacro ()

