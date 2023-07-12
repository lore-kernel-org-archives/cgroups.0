From: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
Subject: [PATCH v3 00/28]  Add Cgroup support for SGX EPC memory
Date: Wed, 12 Jul 2023 16:01:34 -0700
Message-ID: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1689202924; x=1720738924;
  h=from:to:cc:subject:date:message-id:mime-version:
   content-transfer-encoding;
  bh=fv4whj2dnXPamKsW7KTxNhGYSWLDObWoLRFefuR/Qrk=;
  b=W9CFJKLS7fMsSfkUiK0ecMOTIjV3BB1PEKsXU6md6AzKfoFv5BJROeIA
   FB1+sAeif8tVM9qPhAgq3d6VmnSrIBD+oK+bB3cs7kPvQLgwDaYdWs0wT
   GenO8edlv4DtoUd2tbNQOmNRRwPWiu3sHhaMKf/4IbneijVpeU+L4s8/E
   jGBFB7lRBTQmbwIiVrM7cZytD9wadYvepkZ0B4q1JhHkvouF4p6ce3FUj
   MiZkqS8WGlApyjXSNBB6wSJy9ngDJEuWFmKMWdWexIl0cgDKyqs1eUKT0
   +b/0wdWXIRgGJZZFPrqWK3nQVRoJDDsnjEnFaAwYvBQJHyLMiLGkCyGiN
   g==;
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

SGX EPC memory allocations are separate from normal RAM allocations, and is
managed solely by the SGX subsystem. The existing cgroup memory controller
cannot be used to limit or account for SGX EPC memory, which is a desirable
feature in some environments, e.g., support for pod level control in a
Kubernates cluster on a VM or baremetal host [1,2] in those environments.

This patchset implements the support for sgx_epc memory within the misc
cgroup controller. The user can use the misc cgroup controller to set and
enforce a max limit on total EPC usage per cgroup. The implementation
reports current usage and events of reaching the limit per cgroup as well
as the total system capacity.

This work was originally authored by Sean Christopherson a few years ago,
and previously modified by Kristen C. Accardi to work with more recent
kernels, and to utilize the misc cgroup controller rather than a custom
controller. Now I updated the patches based on review comments on the V2
series[3], simplified a few aspects of the implementation/design and fixed
some stability issues found from testing, while keeping the same user space
facing interfaces.

The patchset adds support for multiple LRUs to track both reclaimable EPC
pages (i.e. pages the reclaimer knows about), as well as unreclaimable EPC
pages (i.e.  pages which the reclaimer isn't aware of, such as VA pages).
These pages are assigned to an LRU, as well as an enclave, so that an
enclave's full EPC usage can be tracked, and limited to a max value. During
OOM events, an enclave can be have its memory zapped, and all the EPC pages
not tracked by the reclaimer can be freed.

I appreciate your comments and feedback.

Summary of changes from v2: (more details in commit logs)

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
[4]Documentation/arch/x86/sgx.rst, Section "Virtual EPC"

Haitao Huang (6):
  x86/sgx: Store struct sgx_encl when allocating new VA pages
  x86/sgx: Introduce EPC page states
  x86/sgx: fix a NULL pointer
  cgroup/misc: Fix an overflow
  selftests/sgx: Retry the ioctl()'s returned with EAGAIN
  selftests/sgx: Add scripts for epc cgroup testing

Jarkko Sakkinen (3):
  selftests/sgx: Move ENCL_HEAP_SIZE_DEFAULT to main.c
  selftests/sgx: Use encl->encl_size in sigstruct.c
  selftests/sgx: Include the dynamic heap size to the ELRANGE
    calculation

Kristen Carlson Accardi (9):
  x86/sgx: Add 'struct sgx_epc_lru_lists' to encapsulate lru list(s)
  x86/sgx: Use sgx_epc_lru_lists for existing active page list
  x86/sgx: Store reclaimable epc pages in sgx_epc_lru_lists
  x86/sgx: store unreclaimable EPC pages in sgx_epc_lru_lists
  x86/sgx: Use a list to track to-be-reclaimed pages
  cgroup/misc: Add per resource callbacks for CSS events
  cgroup/misc: Add SGX EPC resource type and export APIs for SGX driver
  x86/sgx: Limit process EPC usage with misc cgroup controller
  Docs/x86/sgx: Add description for cgroup support

Sean Christopherson (9):
  x86/sgx: Add EPC page flags to identify owner type
  x86/sgx: Introduce RECLAIM_IN_PROGRESS state
  x86/sgx: Allow reclaiming up to 32 pages, but scan 16 by default
  x85/sgx: Return the number of EPC pages that were successfully
    reclaimed
  x86/sgx: Add option to ignore age of page during EPC reclaim
  x86/sgx: Prepare for multiple LRUs
  x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
  x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
  x86/sgx: Add EPC OOM path to forcefully reclaim EPC

Vijay Dhanraj (1):
  selftests/sgx: Add SGX selftest augment_via_eaccept_long

 Documentation/arch/x86/sgx.rst                |  77 ++++
 arch/x86/Kconfig                              |  13 +
 arch/x86/kernel/cpu/sgx/Makefile              |   1 +
 arch/x86/kernel/cpu/sgx/driver.c              |  27 +-
 arch/x86/kernel/cpu/sgx/encl.c                |  95 +++-
 arch/x86/kernel/cpu/sgx/encl.h                |   4 +-
 arch/x86/kernel/cpu/sgx/epc_cgroup.c          | 406 ++++++++++++++++++
 arch/x86/kernel/cpu/sgx/epc_cgroup.h          |  60 +++
 arch/x86/kernel/cpu/sgx/ioctl.c               |  25 +-
 arch/x86/kernel/cpu/sgx/main.c                | 406 ++++++++++++++----
 arch/x86/kernel/cpu/sgx/sgx.h                 | 113 ++++-
 include/linux/misc_cgroup.h                   |  34 ++
 kernel/cgroup/misc.c                          |  63 ++-
 tools/testing/selftests/sgx/load.c            |   8 +-
 tools/testing/selftests/sgx/main.c            | 177 +++++++-
 tools/testing/selftests/sgx/main.h            |   6 +-
 .../selftests/sgx/run_tests_in_misc_cg.sh     |  68 +++
 tools/testing/selftests/sgx/setup_epc_cg.sh   |  29 ++
 tools/testing/selftests/sgx/sigstruct.c       |   8 +-
 .../selftests/sgx/watch_misc_for_tests.sh     |  13 +
 20 files changed, 1446 insertions(+), 187 deletions(-)
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.c
 create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.h
 create mode 100755 tools/testing/selftests/sgx/run_tests_in_misc_cg.sh
 create mode 100755 tools/testing/selftests/sgx/setup_epc_cg.sh
 create mode 100755 tools/testing/selftests/sgx/watch_misc_for_tests.sh

-- 
2.25.1

