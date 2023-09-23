From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v5 00/18] Add Cgroup support for SGX EPC memory
Date: Fri, 22 Sep 2023 20:06:39 -0700
Message-ID: <20230923030657.16148-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1695438419; x=1726974419;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=nZVXCwOuydbndY5vcLfGn2MhNmudGolXVrDAy3MEbrI=;
  b=fXjc2t+7wccNeI76msfPspV3zcXszNHdq5BnDhXZEP/Umb4pl1e4ODP5
   YnP20rvMADJSLFBpj9tbJSXTBxa1ooxDVs9UL7T/vzBmP+aSxQCdAbyHP
   iuAp/00GkXdy2AC7xdcApilsgRXQiOtbvPPiWA0PDs0le5zLcutk2vutR
   kbpae6PA5hIeqLb7DUgR7t+JKiW2qR1AXXWXmjy54B1W4ERhxEfW7y+13
   q3HKQWQJXERfJQUj2JpwlH8qEOiI+T60FWnwefqhK5a4UU1XaQRrJcFMg
   rDUXGc8+sfeoC6wFxLLrcvOu5Fw8reebDBsyXepES8Fp1RxjeD5yOF9i/
   w==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, x86-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, bp-Gina5bIWoIWzQB+pC5nmwQ@public.gmane.org, hpa-YMNOUZJC4hwAvxtiuMwx3w@public.gmane.org, sohil.mehta-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, yangjie-0li6OtcxBFHby3iVrkZq2A@public.gmane.org

SGX EPC memory allocations are separate from normal RAM allocations, and
are managed solely by the SGX subsystem. The existing cgroup memory
controller cannot be used to limit or account for SGX EPC memory, which is
a desirable feature in some environments, e.g., support for pod level
control in a Kubernates cluster on a VM or baremetal host [1,2].
 
This patchset implements the support for sgx_epc memory within the misc
cgroup controller. The user can use the misc cgroup controller to set and
enforce a max limit on total EPC usage per cgroup. The implementation
reports current usage and events of reaching the limit per cgroup as well
as the total system capacity.
 
This work was originally authored by Sean Christopherson a few years ago,
and previously modified by Kristen C. Accardi to work with more recent
kernels, and to utilize the misc cgroup controller rather than a custom
controller. Now I have been updating the patches based on review comments
since V2 [3, 4], simplified a few aspects of the implementation/design and
fixed some stability issues found from testing, while keeping the same user
space facing interfaces.
 
The patchset adds support for multiple LRU lists to track both reclaimable
EPC pages (i.e., pages the reclaimer knows about), as well as unreclaimable
EPC pages (i.e., pages which the reclaimer isn't aware of, such as VA
pages).  These pages are assigned to an LRU list, as well as an enclave, so
that an enclave's full EPC usage can be tracked, and subject to the
per-cgroup limit. During OOM events, an enclave can have its memory zapped,
and all the EPC pages tracked by the LRU lists can be freed.
 
The EPC pages allocated for KVM guests by the virtual EPC driver are not
reclaimable by the host kernel [5]. Therefore they are not tracked by any
LRU lists for reclaiming purposes in this implementation, but they are
charged toward the cgroup of the user processs (e.g., QEMU) launching the
guest.  And when the cgroup  EPC usage reaches its limit, the virtual EPC
driver will stop allocating more EPC for the VM, and return SIGBUS to the
user process which would abort the VM launch.
 
To make it easier to follow, I reordered the patches in v4 into following
clusters:
- Patches 1&2 are prerequisite  misc cgroup changes
- Patches 3-8 deal with the 'reclaimable' pages
- Patches 9-12 deal with the 'unreclaimable' pages, which are freed only
  for OOM scenarios.
- Patches 13-15 re-organize EPC reclaiming code to be reusable by EPC
  cgroup.
- Patch 16 implements EPC cgroup as a misc cgroup.
- Patch 17 adds documentation for the EPC cgroup.
- Patch 18 adds test scripts.

I appreciate your review and providing tags if appropriate.

---
v5:
- Replace the manual test script with a selftest script.
- Restore the "From" tag for some patches to Sean [Kai]
- Style fixes (Jarkko)

v4:
* Collected "Tested-by" from Mikko. I kept it for now as no functional changes in v4.
* Rebased on to v6.6_rc1 and reordered patches as described above.
* Separated out the bug fixes [7,8,9]. This series depend on those patches. (Dave, Jarkko)
* Added comments in commit message to give more preview what's to come next. (Jarkko)
* Fixed some documentation error, gap, style (Mikko, Randy)
* Fixed some comments, typo, style in code (Mikko, Kai)
* Patch format and background for reclaimable vs unreclaimable (Kai, Jarkko)
* Fixed typo (Pavel)
* Exclude the previous fixes/enhancements for self-tests. Patch 18 now depends on series [6]
* Use the same to list for cover and all patches. (Sohil)
 
v3:
 
* Added EPC states to replace flags in sgx_epc_page struct. (Jarkko)
* Unrolled wrappers for cond_resched, list (Dave)
* Separate patches for adding reclaimable and unreclaimable lists. (Dave)
* Other improvments on patch flow, commit messages, styles. (Dave, Jarkko)
* Simplified the cgroup tree walking with plain
  css_for_each_descendant_pre.
* Fixed race conditions and crashes.
* OOM killer to wait for the victim enclave pages being reclaimed.
* Unblock the user by handling misc_max_write callback asynchronously.
* Rebased onto 6.4 and no longer base this series on the MCA patchset.
* Fix an overflow in misc_try_charge.
* Fix a NULL pointer in SGX PF handler.
* Updated and included the SGX selftest patches previously reviewed. Those
  patches fix issues triggered in high EPC pressure required for cgroup
  testing.
* Added test scripts to help setup and test SGX EPC cgroups.
 
[1]https://lore.kernel.org/all/DM6PR21MB11772A6ED915825854B419D6C4989-3jJ4emchXQBypjffeKSS3s1VXTxX1y3OvxpqHgZTriW3zl9H0oFU5g@public.gmane.org/
[2]https://lore.kernel.org/all/ZD7Iutppjj+muH4p@himmelriiki/
[3]https://lore.kernel.org/all/20221202183655.3767674-1-kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
[4]https://lore.kernel.org/linux-sgx/20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
[5]Documentation/arch/x86/sgx.rst, Section "Virtual EPC"
[6]https://lore.kernel.org/linux-sgx/20220905020411.17290-1-jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org/
[7]https://lore.kernel.org/linux-sgx/ZLcXmvDKheCRYOjG-NiLfg/pYEd1N0TnZuCh8vA@public.gmane.org/
[8]https://lore.kernel.org/linux-sgx/20230721120231.13916-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/
[9]https://lore.kernel.org/linux-sgx/20230728051024.33063-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org/

Haitao Huang (2):
  x86/sgx: Introduce EPC page states
  selftests/sgx: Add scripts for EPC cgroup testing

Kristen Carlson Accardi (3):
  cgroup/misc: Add per resource callbacks for CSS events
  cgroup/misc: Add SGX EPC resource type and export APIs for SGX driver
  x86/sgx: Limit process EPC usage with misc cgroup controller

Sean Christopherson (13):
  x86/sgx: Add sgx_epc_lru_lists to encapsulate LRU lists
  x86/sgx: Use sgx_epc_lru_lists for existing active page list
  x86/sgx: Store reclaimable EPC pages in sgx_epc_lru_lists
  x86/sgx: Introduce RECLAIM_IN_PROGRESS state
  x86/sgx: Use a list to track to-be-reclaimed pages
  x86/sgx: Store struct sgx_encl when allocating new VA pages
  x86/sgx: Add EPC page flags to identify owner types
  x86/sgx: store unreclaimable pages in LRU lists
  x86/sgx: Add EPC OOM path to forcefully reclaim EPC
  x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
  x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
  x86/sgx: Prepare for multiple LRUs
  Docs/x86/sgx: Add description for cgroup support

 Documentation/arch/x86/sgx.rst                |  82 ++++
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/sgx/Makefile              |   1 +
 arch/x86/kernel/cpu/sgx/driver.c              |  27 +-
 arch/x86/kernel/cpu/sgx/encl.c                |  72 ++-
 arch/x86/kernel/cpu/sgx/encl.h                |   4 +-
 arch/x86/kernel/cpu/sgx/epc_cgroup.c          | 415 ++++++++++++++++++
 arch/x86/kernel/cpu/sgx/epc_cgroup.h          |  59 +++
 arch/x86/kernel/cpu/sgx/ioctl.c               |  25 +-
 arch/x86/kernel/cpu/sgx/main.c                | 399 +++++++++++++----
 arch/x86/kernel/cpu/sgx/sgx.h                 | 117 ++++-
 include/linux/misc_cgroup.h                   |  34 ++
 kernel/cgroup/misc.c                          |  57 ++-
 .../selftests/sgx/run_epc_cg_selftests.sh     | 147 +++++++
 .../selftests/sgx/watch_misc_for_tests.sh     |  13 +
 15 files changed, 1314 insertions(+), 151 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.c
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.h
 create mode 100755 tools/testing/selftests/sgx/run_epc_cg_selftests.sh
 create mode 100755 tools/testing/selftests/sgx/watch_misc_for_tests.sh

-- 
2.25.1

