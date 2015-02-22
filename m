From: Joe Perches <joe@perches.com>
Subject: [PATCH 00/27] Convert seq_<foo> output calls to return void
Date: Sat, 21 Feb 2015 18:53:27 -0800
Message-ID: <cover.1424573328.git.joe@perches.com>
Return-path: <linux-pm-owner@vger.kernel.org>
Sender: linux-pm-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>, linux-arm-kernel@lists.infradead.org, linux-s390@vger.kernel.org, linux-pm@vger.kernel.org, openipmi-developer@lists.sourceforge.net, linux-parisc@vger.kernel.org, linux-kernel@vger.kernel.org, rtc-linux@googlegroups.com, linux-tegra@vger.kernel.org, linux-watchdog@vger.kernel.org, cgroups@vger.kernel.org, drbd-user@lists.linbit.com
Cc: linux-cris-kernel@axis.com, nios2-dev@lists.rocketboards.org, linux@lists.openrisc.net, devel@driverdev.osuosl.org, HPDD-discuss@lists.01.org, linux-usb@vger.kernel.org

As Al Viro said:

we are getting well-meaning folks who try to check that return value,
again and again, getting it wrong every time.   Typical idiocies:
        * return some kind of error out of ->show() on overflows.  Pointless
*and* wrong - only hard errors (== fail read(2) with that) should be
reported that way; the caller does detect overflow and retires with bigger
buffer just fine.
        * keep checking it after every sodding call of seq_...(), screwing
the cleanups up more often than not.  Pointless, unless you are doing some
seriously expensive calculations to produce something you are going to print.
seq_...() are no-ops in case when overflow has already happened.

seq_has_overflowed() is only for situations when you really want to skip
a serious amount of work generating the data that would end up being
discarded and recalculated again when the caller grabs a bigger buffer and
calls you again.  And more often than not it's an indication of ->show()
trying to do the work of iterator - e.g. when you have single_open() with
->show() printing the entire hash table of some sort all in one record.

Most of the time checking return value of seq_...() is better replaced with
not doing that.  And "must check return value and Do Something(tm)" is too
strong habit for enough people to cause recurring trouble.

Joe Perches (27):
  staging: lustre: Convert "return seq_printf(...)" uses
  staging: lustre: Convert seq_ hash functions to return void
  staging: lustre: Convert uses of "int rc = seq_printf(...)"
  staging: lustre: Convert remaining uses of "= seq_printf(...)"
  x86: mtrr: if: Remove use of seq_printf return value
  power: wakeup: Remove use of seq_printf return value
  ipmi: Remove use of seq_printf return value
  rtc: Remove use of seq_printf return value
  ipc: Remove use of seq_printf return value
  pxa27x_udc: Remove use of seq_printf return value
  microblaze: mb: Remove use of seq_printf return value
  nios2: cpuinfo: Remove use of seq_printf return value
  ARM: plat-pxa: Remove use of seq_printf return value
  openrisc: Remove use of seq_printf return value
  cris: Remove use of seq_printf return value
  mfd: ab8500-debugfs: Remove use of seq_printf return value
  staging: i2o: Remove use of seq_printf return value
  staging: rtl8192x: Remove use of seq_printf return value
  s390: Remove use of seq_printf return value
  i8k: Remove use of seq_printf return value
  watchdog: bcm281xx: Remove use of seq_printf return value
  proc: Remove use of seq_printf return value
  cgroup: Remove use of seq_printf return value
  tracing: Remove use of seq_printf return value
  lru_cache: Remove use of seq_printf return value
  parisc: Remove use of seq_printf return value
  regulator: dbx500: Remove use of seq_puts/seq_printf return value

 arch/arm/plat-pxa/dma.c                            | 111 ++++++------
 arch/cris/arch-v10/kernel/setup.c                  |  58 +++---
 arch/cris/arch-v32/kernel/setup.c                  |  62 +++----
 arch/microblaze/kernel/cpu/mb.c                    | 149 ++++++++--------
 arch/nios2/kernel/cpuinfo.c                        |  77 ++++----
 arch/openrisc/kernel/setup.c                       |  50 +++---
 arch/s390/pci/pci_debug.c                          |   6 +-
 arch/x86/kernel/cpu/mtrr/if.c                      |  12 +-
 drivers/base/power/wakeup.c                        |  16 +-
 drivers/char/i8k.c                                 |  16 +-
 drivers/char/ipmi/ipmi_msghandler.c                |  12 +-
 drivers/char/ipmi/ipmi_si_intf.c                   |  26 +--
 drivers/char/ipmi/ipmi_ssif.c                      |   4 +-
 drivers/mfd/ab8500-debugfs.c                       | 196 +++++++++++++--------
 drivers/parisc/ccio-dma.c                          |  54 +++---
 drivers/parisc/sba_iommu.c                         |  86 +++++----
 drivers/regulator/dbx500-prcmu.c                   |  32 +---
 drivers/rtc/rtc-cmos.c                             |  36 ++--
 drivers/rtc/rtc-ds1305.c                           |   6 +-
 drivers/rtc/rtc-mrst.c                             |  16 +-
 drivers/rtc/rtc-tegra.c                            |   4 +-
 drivers/s390/cio/blacklist.c                       |  12 +-
 drivers/staging/i2o/i2o_proc.c                     |  18 +-
 .../lustre/include/linux/libcfs/libcfs_hash.h      |   4 +-
 drivers/staging/lustre/lustre/fid/lproc_fid.c      |  23 ++-
 drivers/staging/lustre/lustre/libcfs/hash.c        |  13 +-
 drivers/staging/lustre/lustre/llite/lproc_llite.c  | 117 ++++++------
 drivers/staging/lustre/lustre/lmv/lproc_lmv.c      |  18 +-
 drivers/staging/lustre/lustre/lov/lproc_lov.c      |  30 ++--
 drivers/staging/lustre/lustre/mdc/lproc_mdc.c      |   6 +-
 .../lustre/lustre/obdclass/linux/linux-module.c    |  38 ++--
 .../lustre/lustre/obdclass/lprocfs_status.c        | 108 ++++++------
 drivers/staging/lustre/lustre/obdclass/lu_object.c |  25 +--
 drivers/staging/lustre/lustre/osc/lproc_osc.c      |  67 +++----
 .../staging/lustre/lustre/ptlrpc/lproc_ptlrpc.c    |  25 +--
 drivers/staging/lustre/lustre/ptlrpc/sec_bulk.c    |  82 +++++----
 drivers/staging/rtl8192e/rtllib_module.c           |   4 +-
 .../staging/rtl8192u/ieee80211/ieee80211_module.c  |   4 +-
 drivers/usb/gadget/udc/pxa27x_udc.c                | 132 +++++++-------
 drivers/watchdog/bcm_kona_wdt.c                    |  27 +--
 fs/proc/array.c                                    |   4 +-
 fs/proc/base.c                                     |  82 +++++----
 ipc/msg.c                                          |  34 ++--
 ipc/sem.c                                          |  26 +--
 ipc/shm.c                                          |  42 ++---
 ipc/util.c                                         |   6 +-
 kernel/cgroup.c                                    |   4 +-
 kernel/trace/trace_stack.c                         |   4 +-
 lib/lru_cache.c                                    |   9 +-
 49 files changed, 1050 insertions(+), 943 deletions(-)

-- 
2.1.2

