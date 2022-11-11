From: Kristen Carlson Accardi <kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH 00/26] Add Cgroup support for SGX EPC memory
Date: Fri, 11 Nov 2022 10:35:05 -0800
Message-ID: <20221111183532.3676646-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668191739; x=1699727739;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=zkMqL68m/5zo4IQcHhhj9rd1XQDhqh5jgd3Tu0wSwho=;
  b=a3maXEy2Kf14SUJXdiryH8v/8W9m1yBW5azsFEreBJra7juFsZRfq5iC
   k4qBIlbchCBOjQa+e/HrU7Cjjt7lt6Szai2UKDulwMZdVsLgRkB0BR5pj
   iR9j7MEDjHOHE7ErYoltMlGX7noP2ykYqOCx7b5FTBlBznc1Nei+OKcJU
   us6oLoUK7jlAuemHcArQ9aAxcu7dcc9VOEtfuvCABUX9s9XV0nTZtPNnx
   yA83GSWanNtwNa6OlDKkKvd62qsqROBKn839afnL4z8jiixwMqKyjGaNW
   m9WDYllLn4kMnA5ff0v9aXnjBU32uKPPTEGh4yZkh1VZiXySNox+6x4bn
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-CPWUtch7KCBzeIdxy0IIJw@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org

Utilize the Miscellaneous cgroup controller to regulate the distribution
of SGX EPC memory, which is a subset of system RAM that is used to provide
SGX-enabled applications with protected memory, and is otherwise inaccessible.

SGX EPC memory allocations are separate from normal RAM allocations,
and is managed solely by the SGX subsystem. The existing cgroup memory
controller cannot be used to limit or account for SGX EPC memory.

This patchset implements the support for sgx_epc memory within the 
misc cgroup controller, and then utilizes the misc cgroup controller
to provide support for setting the total system capacity, max limit
per cgroup, and events.

This work was originally authored by Sean Christopherson a few years ago,
and was modified to work with more recent kernels, and to utilize the
misc cgroup controller rather than a custom controller. It is currently
based on top of the MCA patches.

Here's the MCA patchset for reference.
https://lore.kernel.org/linux-sgx/2d52c8c4-8ed0-6df2-2911-da5b9fcc9ae4-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org/T/#t

The patchset adds support for multiple LRUs to track both reclaimable
EPC pages (i.e. pages the reclaimer knows about), as well as unreclaimable
EPC pages (i.e. pages which the reclaimer isn't aware of, such as va pages).
These pages are assigned to an LRU, as well as an enclave, so that an
enclave's full EPC usage can be tracked, and limited to a max value. During
OOM events, an enclave can be have its memory zapped, and all the EPC pages
not tracked by the reclaimer can be freed.

I appreciate your comments and feedback.

Kristen Carlson Accardi (13):
  x86/sgx: Add 'struct sgx_epc_lru' to encapsulate lru list(s)
  x86/sgx: Use sgx_epc_lru for existing active page list
  x86/sgx: Track epc pages on reclaimable or unreclaimable lists
  cgroup/misc: Add notifier block list support for css events
  cgroup/misc: Expose root_misc
  cgroup/misc: Expose parent_misc()
  cgroup/misc: allow users of misc cgroup to read specific cgroup usage
  cgroup/misc: allow misc cgroup consumers to read the max value
  cgroup/misc: Add private per cgroup data to struct misc_cg
  cgroup/misc: Add tryget functionality for misc controller
  cgroup/misc: Add SGX EPC resource type
  x86/sgx: Add support for misc cgroup controller
  Docs/x86/sgx: Add description for cgroup support

Sean Christopherson (13):
  x86/sgx: Call cond_resched() at the end of sgx_reclaim_pages()
  x86/sgx: Store struct sgx_encl when allocating new va pages
  x86/sgx: Introduce RECLAIM_IN_PROGRESS flag for EPC pages
  x86/sgx: Use a list to track to-be-reclaimed pages during reclaim
  x86/sgx: Add EPC page flags to identify type of page
  x86/sgx: Allow reclaiming up to 32 pages, but scan 16 by default
  x86/sgx: Return the number of EPC pages that were successfully
    reclaimed
  x86/sgx: Add option to ignore age of page during EPC reclaim
  x86/sgx: Add helper to retrieve SGX EPC LRU given an EPC page
  x86/sgx: Prepare for multiple LRUs
  x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
  x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
  x86/sgx: Add EPC OOM path to forcefully reclaim EPC

 Documentation/x86/sgx.rst            |  77 ++++
 arch/x86/Kconfig                     |  13 +
 arch/x86/kernel/cpu/sgx/Makefile     |   1 +
 arch/x86/kernel/cpu/sgx/encl.c       |  89 ++++-
 arch/x86/kernel/cpu/sgx/encl.h       |   4 +-
 arch/x86/kernel/cpu/sgx/epc_cgroup.c | 561 +++++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/epc_cgroup.h |  59 +++
 arch/x86/kernel/cpu/sgx/ioctl.c      |  13 +-
 arch/x86/kernel/cpu/sgx/main.c       | 405 +++++++++++++++----
 arch/x86/kernel/cpu/sgx/sgx.h        |  96 ++++-
 arch/x86/kernel/cpu/sgx/virt.c       |  28 +-
 include/linux/misc_cgroup.h          |  71 ++++
 kernel/cgroup/misc.c                 | 145 ++++++-
 13 files changed, 1446 insertions(+), 116 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.c
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.h

-- 
2.37.3

