# SPDX-License-Identifier: GPL-2.0-only

ifneq ($(KERNELRELEASE),)

obj-m	:= rtl8xxxu_git.o

rtl8xxxu_git-y	:= core.o 8192e.o 8723b.o \
		   8723a.o 8192c.o 8188f.o \
		   8188e.o 8710b.o 8192f.o

ccflags-y += -DCONFIG_RTL8XXXU_UNTESTED

else

KVER ?= `uname -r`
KDIR ?= /lib/modules/$(KVER)/build
MODDIR ?= /lib/modules/$(KVER)/extra
FWDIR := /lib/firmware/rtlwifi

.PHONY: modules clean install install_fw uninstall

modules:
	$(MAKE) -j`nproc` -C $(KDIR) M=$$PWD modules

clean:
	$(MAKE) -C $(KDIR) M=$$PWD clean

install:
	strip -g rtl8xxxu_git.ko
	@install -Dvm 644 -t $(MODDIR) rtl8xxxu_git.ko
	@install -Dvm 644 -t /etc/modprobe.d rtl8xxxu_git.conf
	depmod -a $(KVER)
	
install_fw:
	@install -Dvm 644 -t $(FWDIR) firmware/*

uninstall:
	@rm -vf $(MODDIR)/rtl8xxxu_git.ko
	@rm -vf /etc/modprobe.d/rtl8xxxu_git.conf
	@rmdir --ignore-fail-on-non-empty $(MODDIR) || true
	depmod -a $(KVER)

endif
