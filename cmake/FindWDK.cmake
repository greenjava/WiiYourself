# Find WDK
#
# This module defines
#  WDK_FOUND
#  WDK_INCLUDE_DIRS
#  WDK_LIBRARIES
#
# Copyright (c) 2012 I-maginer
# 
# This program is free software; you can redistribute it and/or modify it under
# the terms of the GNU Lesser General Public License as published by the Free Software
# Foundation; either version 2 of the License, or (at your option) any later
# version.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE. See the GNU Lesser General Public License for more details.
#
# You should have received a copy of the GNU Lesser General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place - Suite 330, Boston, MA 02111-1307, USA, or go to
# http://www.gnu.org/copyleft/lesser.txt
#

# On a new cmake run, we do not need to be verbose
IF(WDK_INCLUDE_DIR AND WDK_LIBRARY)
	SET(WDK_FIND_QUIETLY TRUE)
ENDIF()

# If WDK_DIR was defined in the environment, use it (it's normaly defined at WDK install).
if (NOT WDK_ROOT AND NOT $ENV{WDK_DIR} STREQUAL "")
  set(WDK_ROOT $ENV{WDK_DIR})
endif()

# concat all the search paths
IF(WDK_ROOT)
	SET(WDK_INCLUDE_SEARCH_DIRS
	  ${WDK_INCLUDE_SEARCH_DIRS}
	  ${WDK_ROOT}/inc/api
  )
  IF(CMAKE_SIZEOF_VOID_P EQUAL 8)
    set(ARCHITECTURE amd64)
  else()
    set(ARCHITECTURE i386)
  ENDIF()
  SET(WDK_LIBRARY_SEARCH_DIRS 
    ${WDK_LIBRARY_SEARCH_DIRS}
    ${WDK_ROOT}/lib/win7/${ARCHITECTURE}
  )
ENDIF()

# log message
IF (NOT WDK_FIND_QUIETLY)
	MESSAGE(STATUS "Checking for Ms Windows Driver Kit SDK")
ENDIF()

# Search for header files
FIND_PATH(WDK_INCLUDE_DIR hidpi.h
  PATHS ${WDK_INCLUDE_SEARCH_DIRS})

# Search for libraries files
FIND_LIBRARY(WDK_HID_LIBRARY hid.lib
  PATHS ${WDK_LIBRARY_SEARCH_DIRS})
FIND_LIBRARY(WDK_SETUPAPI_LIBRARY setupapi
  PATHS ${WDK_LIBRARY_SEARCH_DIRS})

# Configure libraries
SET(WDK_INCLUDE_DIRS ${WDK_INCLUDE_DIR} CACHE STRING "Directory containing Ms WDK header files")
SET(WDK_LIBRARIES ${WDK_HID_LIBRARY} ${WDK_SETUPAPI_LIBRARY} CACHE STRING "Ms WDK libraries files")

# Hide those variables in GUI
SET(WDK_INCLUDE_DIR ${WDK_INCLUDE_DIR} CACHE INTERNAL "")
SET(WDK_HID_LIBRARY ${WDK_HID_LIBRARY} CACHE INTERNAL "")
SET(WDK_SETUPAPI_LIBRARY ${WDK_SETUPAPI_LIBRARY} CACHE INTERNAL "")

IF(WDK_INCLUDE_DIR AND WDK_HID_LIBRARY AND WDK_SETUPAPI_LIBRARY)
	SET(WDK_FOUND TRUE)
ENDIF()

# log find result
IF(WDK_FOUND)
	# Hack, WDK sal.h is outdated, so we rename it in order to use the default one provided with vs
	FIND_PATH(WDK_SAL_INCLUDE_DIR sal.h PATHS ${WDK_INCLUDE_DIR})
	#if(WDK_SAL_INCLUDE_DIR)
	#	MESSAGE(STATUS "  WARNING: ${WDK_SAL_INCLUDE_DIR}/sal.h had been renamed because it's outdated and generates incompatibilities!")
	#	file(RENAME ${WDK_SAL_INCLUDE_DIR}/sal.h ${WDK_SAL_INCLUDE_DIR}/SAVE_sal.h)
	#endif()
	SET(WDK_SAL_INCLUDE_DIR ${WDK_SAL_INCLUDE_DIR} CACHE INTERNAL "")

	# log messag
	IF(NOT WDK_FIND_QUIETLY)
		MESSAGE(STATUS "  libraries: ${WDK_LIBRARIES}")
		MESSAGE(STATUS "  includes: ${WDK_INCLUDE_DIRS}")
	ENDIF()
ELSE(WDK_FOUND)
	IF(NOT WDK_HID_LIBRARIES)
		MESSAGE(STATUS, "Ms Windows Driver kit hid library could not be found, check that you had installed the WDK.")
	ENDIF()
	IF(NOT WDK_SETUPAPI_LIBRARIES)
		MESSAGE(STATUS, "Ms Windows Driver kit hid library could not be found, check that you had installed the WDK.")
	ENDIF()
	IF(NOT WDK_INCLUDE_DIRS)
		MESSAGE(STATUS "Ms Windows Driver kit include files could not be found, check that you had installed the WDK.")
	ENDIF()
ENDIF(WDK_FOUND)
