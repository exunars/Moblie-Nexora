cmake_minimum_required(VERSION 3.10.2)
project(tradebot)

set(THREADS_PREFER_PTHREADS ON)

find_package(Threads REQUIRED)

set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -Wall -Wextra")

# Include Flutter dependencies
include_directories(
  ${CMAKE_SOURCE_DIR}/linux/flutter/ephemeral
)

# Include Flutter generated configuration
include(${CMAKE_SOURCE_DIR}/linux/flutter/ephemeral/cmake/FlutterGenerated.cmake)

# Add the executable
add_executable(tradebot
  main.cpp
)

# Include headers
target_include_directories(tradebot PRIVATE
  ${CMAKE_SOURCE_DIR}/linux/flutter/ephemeral
)

# Link dependencies
target_link_libraries(tradebot PRIVATE
  flutter
  Threads::Threads
)

# Import flutter library
add_dependencies(tradebot flutter_assemble)

# Generate resources
flutter_add_target(tradebot)

# Add my_application as a subdirectory
add_subdirectory(my_application)
