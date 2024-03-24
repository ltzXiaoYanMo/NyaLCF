LOCAL_PATH := $(call my-dir)
include $(CLEAR_VARS)
LOCAL_MODULE := frpc_injector
LOCAL_SRC_FILES := frpc_injector.c
include $(BUILD_EXECUTABLE)