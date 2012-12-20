From: kbuild test robot <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [cgroup:blkcg-cfq-hierarchy 18/18] make[1]: Warning: File
 `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
Date: Thu, 20 Dec 2012 11:37:38 +0800
Message-ID: <50d28802.hs3dIwEZ0LCdEUT5%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git blkcg-cfq-hierarchy
head:   945010db297e9dbe05453af789490f21b99ea8a0
commit: 945010db297e9dbe05453af789490f21b99ea8a0 [18/18] cfq-iosched: add hierarchical cfq_group statistics
config: make ARCH=mips allmodconfig

All warnings:

make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
--
make[1]: Warning: File `arch/mips/wrppmc/Platform' has modification time 3.6e+08 s in the future
make[2]: Warning: File `scripts/Makefile.host' has modification time 3.6e+08 s in the future
make[2]: warning:  Clock skew detected.  Your build may be incomplete.
make[2]: Warning: File `scripts/Makefile.host' has modification time 3.6e+08 s in the future
warning: (DVB_USB_PCTV452E) selects TTPCI_EEPROM which has unmet direct dependencies (MEDIA_SUPPORT && MEDIA_PCI_SUPPORT && MEDIA_DIGITAL_TV_SUPPORT && I2C)
warning: (LOCKDEP && FAULT_INJECTION_STACKTRACE_FILTER && LATENCYTOP && KMEMCHECK) selects FRAME_POINTER which has unmet direct dependencies (DEBUG_KERNEL && (CRIS || M68K || FRV || UML || AVR32 || SUPERH || BLACKFIN || MN10300) || ARCH_WANT_FRAME_POINTERS)
make[2]: warning:  Clock skew detected.  Your build may be incomplete.
make[1]: warning:  Clock skew detected.  Your build may be incomplete.

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
