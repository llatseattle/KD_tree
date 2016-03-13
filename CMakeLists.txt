cmake_minimum_required (VERSION 3.0)
project (KDTree)


# add our path and macros to cmake module path
set (CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} ${CMAKE_SOURCE_DIR}/cmake)
include (Common)

macro(source_group_by_dir source_files)
set(sgbd_cur_dir ${CMAKE_CURRENT_SOURCE_DIR})
foreach(sgbd_file ${${source_files}})
 string(REGEX REPLACE ${sgbd_cur_dir}/\(.*\) \\1 sgbd_fpath ${sgbd_file})
 string(REGEX REPLACE "\(.*\)/.*" \\1 sgbd_group_name ${sgbd_fpath})
 string(COMPARE EQUAL ${sgbd_fpath} ${sgbd_group_name} sgbd_nogroup)
 string(REPLACE "/" "\\" sgbd_group_name ${sgbd_group_name})
 if(sgbd_nogroup)
   set(sgbd_group_name "\\")
 endif(sgbd_nogroup)
 source_group(${sgbd_group_name} FILES ${sgbd_file})
endforeach(sgbd_file)
endmacro(source_group_by_dir)

include(CheckCXXCompilerFlag)
CHECK_CXX_COMPILER_FLAG("-std=c++11" COMPILER_SUPPORTS_CXX11)
CHECK_CXX_COMPILER_FLAG("-std=c++0x" COMPILER_SUPPORTS_CXX0X)
if(COMPILER_SUPPORTS_CXX11)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++11")
elseif(COMPILER_SUPPORTS_CXX0X)
    set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -std=c++0x")
else()
        message(STATUS "The compiler ${CMAKE_CXX_COMPILER} has no C++11 support. Please use a different C++ compiler.")
endif()

AUX_SOURCE_DIRECTORY(include SOURCES)
AUX_SOURCE_DIRECTORY(entrance SOURCES)
AUX_SOURCE_DIRECTORY(test SOURCES)

SET(SOURCES ${SOURCES})
FILE(GLOB_RECURSE project_h include/*.h)
FILE(GLOB_RECURSE project_headers ${project_h} include/*.cpp)
FILE(GLOB_RECURSE project_cpps entrance/*.cpp)
FILE(GLOB_RECURSE test_cpps test/*.cpp)
set(all_files ${project_headers} ${project_cpps})
set(test_files ${project_headers} ${test_cpps})
source_group_by_dir(all_files)

####################################################################
# Add special directory of files which cannot be generally added by the previous method
####################################################################
FILE (GLOB PCHFiles "${CMAKE_SOURCE_DIR}/stdafx.*")
source_group ("Precompiled Headers" FILES ${PCHFiles})


add_library(kd_tree STATIC ${project_headers})
SET_TARGET_PROPERTIES(kd_tree PROPERTIES LINKER_LANGUAGE CXX)
option(no_warning_for_no_symbols ON)

INCLUDE_DIRECTORIES(include)
ADD_EXECUTABLE(KDTree ${project_cpps})
target_link_libraries(KDTree kd_tree)

ADD_EXECUTABLE(KDTreeTest ${test_cpps})
target_link_libraries(KDTreeTest kd_tree)

INSTALL(TARGETS kd_treeLIBRARY DESTINATION lib
RUNTIME DESTINATION binARCHIVE DESTINATION lib)
INSTALL(FILES ${project_h} DESTINATION include/kd_tree)

