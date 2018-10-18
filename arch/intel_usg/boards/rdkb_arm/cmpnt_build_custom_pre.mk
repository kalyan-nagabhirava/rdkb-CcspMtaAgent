#######################################################################
#   Copyright [2014] [Cisco Systems, Inc.]
# 
#   Licensed under the Apache License, Version 2.0 (the \"License\");
#   you may not use this file except in compliance with the License.
#   You may obtain a copy of the License at
# 
#       http://www.apache.org/licenses/LICENSE-2.0
# 
#   Unless required by applicable law or agreed to in writing, software
#   distributed under the License is distributed on an \"AS IS\" BASIS,
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
#   See the License for the specific language governing permissions and
#   limitations under the License.
#######################################################################

#
#   for Intel USG, Pumba 6, all ARM boards
#   MTA custom makefile, included pre main makefile
#

#
#   platform specific customization
#

include $(SDK_PATH)/.config

LDFLAGS += -L$(CCSP_INSTALL_ROOT)/lib -lhal_mta

TI_API_PREFIX    :=$(SDK_PATH)/ti
DOCSIS_API_PREFIX := $(TI_API_PREFIX)/docsis

include $(TI_API_PREFIX)/lib/docsis_ext_interface.make

TI_ARM_INC_DIR = -I$(SDK_PATH)/ti/netdk/src/ti_udhcp -I$(SDK_PATH)/ti/netdk/src/ti_dhcpv6 -I$(SDK_PATH)/ti/include -I$(SDK_PATH)/ti/ncsdk/src/inc/iface
CFLAGS += $(TI_ARM_INC_DIR)

LDFLAGS += -L$(SDK_PATH)/ti/netdk/src/uipc
LDFLAGS += -L$(SDK_PATH)/ti/netdk/src/ti_udhcp
LDFLAGS += -L$(SDK_PATH)/ti/netdk/src/ti_dhcpv6

LDFLAGS += $(ldflags-y) -luipc -lpthread -lapi_dhcpv4c -ldhcp4cApi # -llmapi 

ifeq ($(CONFIG_TI_PACM), y) 
  CFLAGS += -DCONFIG_TI_PACM
  LDFLAGS += -lcertlib -lpacm_util
endif

ifeq ($(CONFIG_TI_BBU), y)
  CFLAGS += -DCONFIG_TI_BBU
  LDFLAGS += -lbbu
endif

LDFLAGS += -lcurl -lcrypto

ifeq ($(SDK_VERSION), 4.3.0.37)
	CM_LDFLAGS = -L$(SDK_PATH)/ti/lib
	CM_LDFLAGS += -lcm_mgnt
	CM_LDFLAGS += -lall_docsis
	CM_LDFLAGS += -lgetnextfreq
	CM_LDFLAGS += -lticc
	CM_LDFLAGS += -lti_sme
	CM_LDFLAGS += -lsme
	CM_LDFLAGS += -lhal_mxl_hrcls_srv
	CM_LDFLAGS += -lhal_FST_srv
	CM_LDFLAGS += -lm
else
# RDKB MOD, removed obsolete Intel libraries for SDK 4.3
	CM_LDFLAGS += -L$(SDK_PATH)/ti/lib
	CM_LDFLAGS += -lgetnextfreq
	CM_LDFLAGS += -lticc 
	CM_LDFLAGS += -lti_sme
	CM_LDFLAGS += -lsme
	CM_LDFLAGS += -lhal_mxl_hrcls_srv
	CM_LDFLAGS += -lhal_FST_srv
	CM_LDFLAGS += -lm
	CM_LDFLAGS += -lticc
	CM_LDFLAGS += -lti_sme
	CM_LDFLAGS += -lsme
# RDKB MOD END
endif

ifeq ($(CONFIG_SYSTEM_MOCA), y)
	MOCA_LDFLAGS += -lhal_moca
#	MOCA_LDFLAGS += -lmoca_api
	CFLAGS += -DCONFIG_SYSTEM_MOCA
endif

LDFLAGS += $(CM_LDFLAGS) $(MOCA_LDFLAGS)

# UTOPIA
UTOPIA_INC_DIR = -I$(CCSP_ROOT_DIR)/Utopia/source/utapi/lib -I$(CCSP_ROOT_DIR)/Utopia/source/utctx/lib
UTOPIA_LDFLAGS = -L$(SDK_PATH)/ti/lib -lutapi -lutctx -lsyscfg -lsysevent -lulog
CFLAGS += $(UTOPIA_INC_DIR)
LDFLAGS += $(UTOPIA_LDFLAGS)

INCPATH += $(shell  find $(DOCSIS_API_PREFIX)/src  -name 'include' )
INCPATH += $(DOCSIS_API_PREFIX)/src/vendor/sa_db/inc
INCPATH += $(TI_API_PREFIX)/include/asm-arm/arch-avalanche/generic
INCPATH += $(TI_API_PREFIX)/gw/src
