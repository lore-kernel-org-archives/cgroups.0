From: Kristen Carlson Accardi <kristen@linux.intel.com>
Subject: [RFC PATCH 00/20] Add Cgroup support for SGX EPC memory
Date: Thu, 22 Sep 2022 10:10:37 -0700
Message-ID: <20220922171057.1236139-1-kristen@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1663866671; x=1695402671;
  h=from:to:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=AxE0i8/Mftgy7fZYyASRgEYg0hxIfDnCcTRxEHqj3Sw=;
  b=BIraYHDiNA1YEP5Y8fGuHIdhGzAvsq7mcL7c8eYRbHXHvHVv6Axzqyry
   W8dRmALMn95O9OMX+A2+RRHBcZ8RooaszvjM0zTGORNnCFULjH6sCPX8l
   5R9LvnLa0q1wrjujoQCClwy9QrDV1wgdU3hpaiNIzhGIccMgGuIt3bi0n
   ir7fqoxEGri/INBfnaeGMOUojCjq9kyVM2aPohrF6uGLhnFubhmAqNt/l
   OBwSCBW6F7qq3u1Y5a5fxgeqDI071FPKX0lOeM4rs2i/PozCp+o4vOCBl
   vWCrIOTH+GFy/mFMyRZ/6ynU8vRFE5ueqRDndkAI3P6WA3mTLzsI38Fva
   A==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, linux-sgx@vger.kernel.org, cgroups@vger.kernel.org

Add a new cgroup controller to regulate the distribution of SGX EPC memory,
which is a subset of system RAM that is used to provide SGX-enabled
applications with protected memory, and is otherwise inaccessible.

SGX EPC memory allocations are separate from normal RAM allocations,
and is managed solely by the SGX subsystem. The existing cgroup memory
controller cannot be used to limit or account for SGX EPC memory.

This patchset implements the sgx_epc cgroup controller, which will provide
support for stats, events, and the following interface files:

sgx_epc.current
	A read-only value which represents the total amount of EPC
	memory currently being used on by the cgroup and its descendents.

sgx_epc.low
	A read-write value which is used to set best-effort protection
	of EPC usage. If the EPC usage of a cgroup drops below this value,
	then the cgroup's EPC memory will not be reclaimed if possible.

sgx_epc.high
	A read-write value which is used to set a best-effort limit
	on the amount of EPC usage a cgroup has. If a cgroup's usage
	goes past the high value, the EPC memory of that cgroup will
	get reclaimed back under the high limit.

sgx_epc.max
	A read-write value which is used to set a hard limit for
	cgroup EPC usage. If a cgroup's EPC usage reaches this limit,
	allocations are blocked until EPC memory can be reclaimed from
	the cgroup.

This work was originally authored by Sean Christopherson a few years ago,
and was modified to work with more recent kernels.

The patchset adds support for multiple LRUs to track both reclaimable
EPC pages (i.e. pages the reclaimer knows about), as well as unreclaimable
EPC pages (i.e. pages which the reclaimer isn't aware of, such as va pages).
These pages are assigned to an LRU, as well as an enclave, so that an
enclave's full EPC usage can be tracked. During OOM events, an enclave
can be have its memory zapped, and all the EPC pages not tracked by the
reclaimer can be freed.

I appreciate your comments and feedback.

Sean Christopherson (20):
  x86/sgx: Call cond_resched() at the end of sgx_reclaim_pages()
  x86/sgx: Store EPC page owner as a 'void *' to handle multiple users
  x86/sgx: Track owning enclave in VA EPC pages
  x86/sgx: Add 'struct sgx_epc_lru' to encapsulate lru list(s)
  x86/sgx: Introduce unreclaimable EPC page lists
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
  cgroup, x86/sgx: Add SGX EPC cgroup controller
  x86/sgx: Enable EPC cgroup controller in SGX core
  x86/sgx: Add stats and events interfaces to EPC cgroup controller
  docs, cgroup, x86/sgx: Add SGX EPC cgroup controller documentation

 Documentation/admin-guide/cgroup-v2.rst | 201 +++++
 arch/x86/kernel/cpu/sgx/Makefile        |   1 +
 arch/x86/kernel/cpu/sgx/encl.c          |  89 ++-
 arch/x86/kernel/cpu/sgx/encl.h          |   4 +-
 arch/x86/kernel/cpu/sgx/epc_cgroup.c    | 950 ++++++++++++++++++++++++
 arch/x86/kernel/cpu/sgx/epc_cgroup.h    |  51 ++
 arch/x86/kernel/cpu/sgx/ioctl.c         |  13 +-
 arch/x86/kernel/cpu/sgx/main.c          | 389 ++++++++--
 arch/x86/kernel/cpu/sgx/sgx.h           |  40 +-
 arch/x86/kernel/cpu/sgx/virt.c          |  28 +-
 include/linux/cgroup_subsys.h           |   4 +
 init/Kconfig                            |  12 +
 12 files changed, 1669 insertions(+), 113 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.c
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.h

-- 
2.37.3

