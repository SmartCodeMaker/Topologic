cmake_minimum_required(VERSION 3.24)

project(TopologicCore VERSION ${CMAKE_PROJECT_VERSION} LANGUAGES CXX)
set(PROJECT_NAMESPACE Topologic)

set(CMAKE_MODULE_PATH ${CMAKE_MODULE_PATH} "${PROJECT_SOURCE_DIR}/cmake")

# Build shared library by default
option(TOPOLOGICCORE_BUILD_SHARED "Build ${PROJECT_NAME} as a shared library" ON)

if (${TOPOLOGICCORE_BUILD_SHARED})
    set(build_library_type SHARED)
else()
    set(build_library_type STATIC)
endif()


# Source groups
set(no_group_source_files
    "include/About.h"
    "include/Aperture.h"
    "include/Cell.h"
    "include/CellComplex.h"
    "include/Cluster.h"
    "include/ContentManager.h"
    "include/Context.h"
    "include/ContextManager.h"
    "include/Dictionary.h"
    "include/Edge.h"
    "include/Face.h"
    "include/Graph.h"
    "include/InstanceGUIDManager.h"
    "include/Shell.h"
    "include/TopologicalQuery.h"
    "include/Topology.h"
    "include/Utilities.h"
    "include/Vertex.h"
    "include/Wire.h"
    "src/About.cpp"
    "src/Aperture.cpp"
    "src/Cell.cpp"
    "src/CellComplex.cpp"
    "src/Cluster.cpp"
    "src/ContentManager.cpp"
    "src/Context.cpp"
    "src/ContextManager.cpp"
    "src/Dictionary.cpp"
    "src/Edge.cpp"
    "src/Face.cpp"
    "src/Graph.cpp"
    "src/InstanceGUIDManager.cpp"
    "src/Shell.cpp"
    "src/Topology.cpp"
    "src/Utilities.cpp"
    "src/Vertex.cpp"
    "src/Wire.cpp"
)
source_group("" FILES ${no_group_source_files})

set(Attributes
    "include/Attribute.h"
    "include/AttributeManager.h"
    "include/DoubleAttribute.h"
    "include/IntAttribute.h"
    "include/ListAttribute.h"
    "include/StringAttribute.h"
    "src/AttributeManager.cpp"
    "src/DoubleAttribute.cpp"
    "src/IntAttribute.cpp"
    "src/ListAttribute.cpp"
    "src/StringAttribute.cpp"
)
source_group("Attributes" FILES ${Attributes})

set(Factories
    "include/ApertureFactory.h"
    "include/CellComplexFactory.h"
    "include/CellFactory.h"
    "include/ClusterFactory.h"
    "include/EdgeFactory.h"
    "include/FaceFactory.h"
    "include/ShellFactory.h"
    "include/TopologyFactory.h"
    "include/TopologyFactoryManager.h"
    "include/VertexFactory.h"
    "include/WireFactory.h"
    "src/ApertureFactory.cpp"
    "src/CellComplexFactory.cpp"
    "src/CellFactory.cpp"
    "src/ClusterFactory.cpp"
    "src/EdgeFactory.cpp"
    "src/FaceFactory.cpp"
    "src/ShellFactory.cpp"
    "src/TopologyFactoryManager.cpp"
    "src/VertexFactory.cpp"
    "src/WireFactory.cpp"
)
source_group("Factories" FILES ${Factories})

set(Geometries
    "include/Geometry.h"
    "include/Line.h"
    "include/NurbsCurve.h"
    "include/NurbsSurface.h"
    "include/PlanarSurface.h"
    "include/Surface.h"
    "src/Geometry.cpp"
    "src/Line.cpp"
    "src/NurbsCurve.cpp"
    "src/NurbsSurface.cpp"
    "src/PlanarSurface.cpp"
    "src/Surface.cpp"
)
source_group("Geometries" FILES ${Geometries})

set(Utilities
    "include/Bitwise.h"
    "include/Utilities/CellUtility.h"
    "include/Utilities/Direction.h"
    "include/Utilities/EdgeUtility.h"
    "include/Utilities/FaceUtility.h"
    "include/Utilities/Guid.h"
    "include/Utilities/ShellUtility.h"
    "include/Utilities/TopologyUtility.h"
    "include/Utilities/TransformationMatrix2D.h"
    "include/Utilities/Vector.h"
    "include/Utilities/VertexUtility.h"
    "include/Utilities/WireUtility.h"
    "src/Bitwise.cpp"
    "src/Utilities/CellUtility.cpp"
    "src/Utilities/Direction.cpp"
    "src/Utilities/EdgeUtility.cpp"
    "src/Utilities/Guid.cpp"
    "src/Utilities/FaceUtility.cpp"
    "src/Utilities/ShellUtility.cpp"
    "src/Utilities/TopologyUtility.cpp"
    "src/Utilities/TransformationMatrix2D.cpp"
    "src/Utilities/Vector.cpp"
    "src/Utilities/VertexUtility.cpp"
    "src/Utilities/WireUtility.cpp"
)
source_group("Utilities" FILES ${Utilities})

set(ALL_FILES
    ${no_group_source_files}
    ${Attributes}
    ${Factories}
    ${Geometries}
    ${Utilities}
)

file(GLOB TOPOLOGICCORE_H_FILES include/*.h)
file(GLOB TOPOLOGICCORE_UTILITIES_H_FILES include/Utilities/*.h)


# Target
add_library(${PROJECT_NAME} ${build_library_type} ${ALL_FILES})
add_library(${PROJECT_NAMESPACE}::${PROJECT_NAME} ALIAS ${PROJECT_NAME})
target_compile_features(${PROJECT_NAME} PUBLIC cxx_std_14)
# Include dir
target_include_directories(${PROJECT_NAME} PUBLIC ${PROJECT_SOURCE_DIR}/include)
# Set version: for now sync manually with: TopologicCore/src/About.cpp
string(REGEX MATCH "^([0-9]+)\\." CMAKE_PROJECT_VERSION_MATCH ${CMAKE_PROJECT_VERSION})
set(BUILD_SOVERSION ${CMAKE_MATCH_1}) # Set "5" if project version is "5.0.0".
set_target_properties(${PROJECT_NAME} PROPERTIES VERSION ${CMAKE_PROJECT_VERSION} SOVERSION ${BUILD_SOVERSION})
include_directories(${CMAKE_BINARY_DIR})
configure_file("TopologicConfig.h.in" "${CMAKE_BINARY_DIR}/TopologicConfig.h")

# Dependency: OpenCASCADE
find_package(OpenCASCADE REQUIRED)
set(DEPENDENCIES_OpenCASCADE
        "TKOffset;"
        "TKMesh;"
        "TKBO;"
        "TKPrim;"
        "TKShHealing;"
        "TKTopAlgo;"
        "TKGeomAlgo;"
        "TKBRep;"
        "TKGeomBase;"
        "TKG3d;"
        "TKG2d;"
        "TKMath;"
        "TKernel;"
        "TKFillet;"
        "TKBool;"
        )

if(NOT CMAKE_LINK_GROUP_USING_RESCAN_SUPPORTED)
    set(LIBDEPS "${DEPENDENCIES_OpenCASCADE}")
else()
    # help static linking with RESCAN
    set(LIBDEPS "$<LINK_GROUP:RESCAN,${DEPENDENCIES_OpenCASCADE}>")
endif()
set(TopologicCore_INCLUDE_DIR ${OpenCASCADE_INCLUDE_DIR})

if(WIN32)
elseif(APPLE)
    find_library(CFLIB CoreFoundation REQUIRED)
    set(LIBDEPS ${LIBDEPS} ${CFLIB})
else()
    find_package(Libuuid REQUIRED)
    if (NOT Libuuid_FOUND)
        message(FATAL_ERROR
            "You might need to run 'sudo apt-get install uuid-dev' or similar")
    endif()
    set(TopologicCore_INCLUDE_DIR ${TopologicCore_INCLUDE_DIR} ${Libuuid_INCLUDE_DIRS})
    set(LIBDEPS ${LIBDEPS} ${Libuuid_LIBRARIES})
endif()

target_link_libraries(${PROJECT_NAME} PUBLIC ${LIBDEPS})

# workaround for the include path from the vcpkg OpenCASCADE
if(VCPKG_INSTALLED_DIR)
    message(STATUS "workaround for vcpkg: adding OpenCASCADE_INCLUDE_DIR directory to target: ${PROJECT_NAME}: ${OpenCASCADE_INCLUDE_DIR}")
    target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC ${TopologicCore_INCLUDE_DIR})
endif()


# compilation tweaks
if (build_library_type STREQUAL SHARED)
    if (WIN32)
        target_compile_definitions(${PROJECT_NAME} PRIVATE TOPOLOGICCORE_WINDLL_EXPORTS) # define for __declspec(dllexport)
        target_compile_definitions(${PROJECT_NAME} PUBLIC TOPOLOGICCORE_WINDLL) # propagate define for __declspec(dllimport) to consumers
    endif()
endif()

if (build_library_type STREQUAL STATIC)
  set_property(TARGET ${PROJECT_NAME} PROPERTY POSITION_INDEPENDENT_CODE True)
endif()

# pybind11 used by TopologicPythonBindings turns on LTO by default
# if not turned off in CMAKE_INTERPROCEDURAL_OPTIMIZATION
# as of 20221217, on conda on mac, cmake's check_ipo_supported() can't be used
# but pybind11's own mechanism still turns on fat LTO, since that is available
# therefore fall back here to turn on fat lto for clang, gcc explicitly by default, consider it as a requirement
if(NOT DEFINED CMAKE_INTERPROCEDURAL_OPTIMIZATION OR CMAKE_INTERPROCEDURAL_OPTIMIZATION)
    if(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
        target_compile_options(${PROJECT_NAME} PRIVATE "-flto;-ffat-lto-objects")
        set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION False) # shadow
    elseif(CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_compile_options(${PROJECT_NAME} PRIVATE "-flto=full")
        set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION False) # shadow
    else() # otherwise enable it through he property
        set_property(TARGET ${PROJECT_NAME} PROPERTY INTERPROCEDURAL_OPTIMIZATION True)
    endif()
endif()

# hacky: if not on windows, remove propagated OpenCASCADE linkage when building a shared library
# the API of TopologicPythonBindings references symbols from OpenCASCADE directly
# and this results in it getting directly linked to some OpenCASCADE shared libraries
# if we want to prevent this and link it only to TopologicCore (which in turn is linked to OpenCASCADE of course)
# it can be done by removing OpenCASCADE targets from INTERFACE_LINK_LIBRARIES
if (build_library_type STREQUAL SHARED)
    if(NOT WIN32)
        # INTERFACE_LINK_LIBRARIES_DIRECT_EXCLUDE sounds good, but doesn't seem to work
        #set_property(TARGET ${PROJECT_NAME} PROPERTY INTERFACE_LINK_LIBRARIES_DIRECT_EXCLUDE ${DEPENDENCIES_OpenCASCADE})
        # setting INTERFACE_LINK_LIBRARIES to an empty list since there are not other dependencies for now
        set_property(TARGET ${PROJECT_NAME} PROPERTY INTERFACE_LINK_LIBRARIES "")
        # restore propagation of OpenCASCADE include dir
        target_include_directories(${PROJECT_NAME} SYSTEM PUBLIC ${TopologicCore_INCLUDE_DIR})
    endif()
endif()


# install definitions
install(TARGETS ${PROJECT_NAME}
        DESTINATION lib/${PROJECT_NAME}
        COMPONENT ${PROJECT_NAME}
        )
install(FILES ${TOPOLOGICCORE_H_FILES}
        DESTINATION include/${PROJECT_NAME}
        COMPONENT ${PROJECT_NAME}_Headers
        )
install(FILES ${TOPOLOGICCORE_UTILITIES_H_FILES}
        DESTINATION include/${PROJECT_NAME}/Utilities
        COMPONENT ${PROJECT_NAME}_Headers
        )




#include(CMakePrintHelpers)
#cmake_print_properties(TARGETS ${PROJECT_NAME} PROPERTIES TYPE POSITION_INDEPENDENT_CODE LINK_LIBRARIES LINK_INTERFACE_LIBRARIES INTERFACE_LINK_LIBRARIES INTERFACE_LINK_LIBRARIES_DIRECT_EXCLUDE INTERFACE_COMPILE_DEFINITIONS INTERFACE_INCLUDE_DIRECTORIES INTERFACE_SYSTEM_INCLUDE_DIRECTORIES INCLUDE_DIRECTORIES)
