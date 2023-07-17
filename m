From: "Jarkko Sakkinen" <jarkko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 00/28] Add Cgroup support for SGX EPC memory
Date: Mon, 17 Jul 2023 11:02:16 +0000
Message-ID: <CU4EA8H87W7J.11BOV563ZK2JX@seitikki>
References: <20230712230202.47929-1-haitao.huang@linux.intel.com>
Mime-Version: 1.0
Content-Transfer-Encoding: quoted-printable
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689591741;
        bh=+53C990ezxW+CH/h5YwzOeu1TggP247Z5D2ia9sXu+Q=;
        h=Date:Cc:Subject:From:To:References:In-Reply-To:From;
        b=crl0RtcG6CueSPzN+sOFtkclR5nXvQhbHqUaymi2TIBNaa3LDmtZhYdjjZRNXDzRC
         3VrH7AakvgvbraQpIiHPTsAHzEOUtVv2duv/BAL8u8Yoxgy/wJoqJDj5jvM0Ay0PJ/
         YkBxrBfwK8fdlmkdRg501Z+vhKnCsdzgFyMrZjJXmcCgUUZw5ziVIoLiDwVQKGFsBV
         j61wh5UDA16gqnikDp3jL3icW4ZoA8/savmEqpMlO/fPwLlVWC5YuU7R6jvpGjrArT
         G30u4FNdxOtrR6nN/2dS7ohFAzSs+3QqswTubCgkH8RsNwmVOUonGDYeweNkaxm5e3
         nDfdpvPBJwcow==
In-Reply-To: <20230712230202.47929-1-haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Haitao Huang <haitao.huang-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, dave.hansen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-sgx-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: kai.huang-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, reinette.chatre-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, zhiquan1.li-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, kristen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org, seanjc-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, zhanb-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, anakrish-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, mikko.ylinen-VuQAYsv1563Yd54FQh9/CA@public.gmane.org

On Wed Jul 12, 2023 at 11:01 PM UTC, Haitao Huang wrote:
> SGX EPC memory allocations are separate from normal RAM allocations, and =
is
> managed solely by the SGX subsystem. The existing cgroup memory controlle=
r
> cannot be used to limit or account for SGX EPC memory, which is a desirab=
le
> feature in some environments, e.g., support for pod level control in a
> Kubernates cluster on a VM or baremetal host [1,2] in those environments.
>
> This patchset implements the support for sgx_epc memory within the misc
> cgroup controller. The user can use the misc cgroup controller to set and
> enforce a max limit on total EPC usage per cgroup. The implementation
> reports current usage and events of reaching the limit per cgroup as well
> as the total system capacity.
>
> This work was originally authored by Sean Christopherson a few years ago,
> and previously modified by Kristen C. Accardi to work with more recent
> kernels, and to utilize the misc cgroup controller rather than a custom
> controller. Now I updated the patches based on review comments on the V2
> series[3], simplified a few aspects of the implementation/design and fixe=
d
> some stability issues found from testing, while keeping the same user spa=
ce
> facing interfaces.
>
> The patchset adds support for multiple LRUs to track both reclaimable EPC
> pages (i.e. pages the reclaimer knows about), as well as unreclaimable EP=
C
> pages (i.e.  pages which the reclaimer isn't aware of, such as VA pages).
> These pages are assigned to an LRU, as well as an enclave, so that an
> enclave's full EPC usage can be tracked, and limited to a max value. Duri=
ng
> OOM events, an enclave can be have its memory zapped, and all the EPC pag=
es
> not tracked by the reclaimer can be freed.
>
> I appreciate your comments and feedback.
>
> Summary of changes from v2: (more details in commit logs)
>
> * Added EPC states to replace flags in sgx_epc_page struct. (Jarkko)
> * Unrolled wrappers for cond_resched, list (Dave)
> * Separate patches for adding reclaimable and unreclaimable lists. (Dave)
> * Other improvments on patch flow, commit messages, styles. (Dave, Jarkko=
)
> * Simplified the cgroup tree walking with plain
>   css_for_each_descendant_pre.
> * Fixed race conditions and crashes.
> * OOM killer to wait for the victim enclave pages being reclaimed.
> * Unblock the user by handling misc_max_write callback asynchronously.
> * Rebased onto 6.4 and no longer base this series on the MCA patchset.
> * Fix an overflow in misc_try_charge.
> * Fix a NULL pointer in SGX PF handler.
> * Updated and included the SGX selftest patches previously reviewed. Thos=
e
>   patches fix issues triggered in high EPC pressure required for cgroup
>   testing.
> * Added test scripts to help setup and test SGX EPC cgroups.
>
> [1]https://lore.kernel.org/all/DM6PR21MB11772A6ED915825854B419D6C4989@DM6=
PR21MB1177.namprd21.prod.outlook.com/
> [2]https://lore.kernel.org/all/ZD7Iutppjj+muH4p@himmelriiki/
> [3]https://lore.kernel.org/all/20221202183655.3767674-1-kristen-VuQAYsv1561eoWH0uzbU5w@public.gmane.org=
el.com/
> [4]Documentation/arch/x86/sgx.rst, Section "Virtual EPC"
>
> Haitao Huang (6):
>   x86/sgx: Store struct sgx_encl when allocating new VA pages
>   x86/sgx: Introduce EPC page states
>   x86/sgx: fix a NULL pointer
>   cgroup/misc: Fix an overflow
>   selftests/sgx: Retry the ioctl()'s returned with EAGAIN
>   selftests/sgx: Add scripts for epc cgroup testing
>
> Jarkko Sakkinen (3):
>   selftests/sgx: Move ENCL_HEAP_SIZE_DEFAULT to main.c
>   selftests/sgx: Use encl->encl_size in sigstruct.c
>   selftests/sgx: Include the dynamic heap size to the ELRANGE
>     calculation
>
> Kristen Carlson Accardi (9):
>   x86/sgx: Add 'struct sgx_epc_lru_lists' to encapsulate lru list(s)
>   x86/sgx: Use sgx_epc_lru_lists for existing active page list
>   x86/sgx: Store reclaimable epc pages in sgx_epc_lru_lists
>   x86/sgx: store unreclaimable EPC pages in sgx_epc_lru_lists
>   x86/sgx: Use a list to track to-be-reclaimed pages
>   cgroup/misc: Add per resource callbacks for CSS events
>   cgroup/misc: Add SGX EPC resource type and export APIs for SGX driver
>   x86/sgx: Limit process EPC usage with misc cgroup controller
>   Docs/x86/sgx: Add description for cgroup support
>
> Sean Christopherson (9):
>   x86/sgx: Add EPC page flags to identify owner type
>   x86/sgx: Introduce RECLAIM_IN_PROGRESS state
>   x86/sgx: Allow reclaiming up to 32 pages, but scan 16 by default
>   x85/sgx: Return the number of EPC pages that were successfully
>     reclaimed
>   x86/sgx: Add option to ignore age of page during EPC reclaim
>   x86/sgx: Prepare for multiple LRUs
>   x86/sgx: Expose sgx_reclaim_pages() for use by EPC cgroup
>   x86/sgx: Add helper to grab pages from an arbitrary EPC LRU
>   x86/sgx: Add EPC OOM path to forcefully reclaim EPC
>
> Vijay Dhanraj (1):
>   selftests/sgx: Add SGX selftest augment_via_eaccept_long
>
>  Documentation/arch/x86/sgx.rst                |  77 ++++
>  arch/x86/Kconfig                              |  13 +
>  arch/x86/kernel/cpu/sgx/Makefile              |   1 +
>  arch/x86/kernel/cpu/sgx/driver.c              |  27 +-
>  arch/x86/kernel/cpu/sgx/encl.c                |  95 +++-
>  arch/x86/kernel/cpu/sgx/encl.h                |   4 +-
>  arch/x86/kernel/cpu/sgx/epc_cgroup.c          | 406 ++++++++++++++++++
>  arch/x86/kernel/cpu/sgx/epc_cgroup.h          |  60 +++
>  arch/x86/kernel/cpu/sgx/ioctl.c               |  25 +-
>  arch/x86/kernel/cpu/sgx/main.c                | 406 ++++++++++++++----
>  arch/x86/kernel/cpu/sgx/sgx.h                 | 113 ++++-
>  include/linux/misc_cgroup.h                   |  34 ++
>  kernel/cgroup/misc.c                          |  63 ++-
>  tools/testing/selftests/sgx/load.c            |   8 +-
>  tools/testing/selftests/sgx/main.c            | 177 +++++++-
>  tools/testing/selftests/sgx/main.h            |   6 +-
>  .../selftests/sgx/run_tests_in_misc_cg.sh     |  68 +++
>  tools/testing/selftests/sgx/setup_epc_cg.sh   |  29 ++
>  tools/testing/selftests/sgx/sigstruct.c       |   8 +-
>  .../selftests/sgx/watch_misc_for_tests.sh     |  13 +
>  20 files changed, 1446 insertions(+), 187 deletions(-)
>  create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.c
>  create mode 100644 arch/x86/kernel/cpu/sgx/epc_cgroup.h
>  create mode 100755 tools/testing/selftests/sgx/run_tests_in_misc_cg.sh
>  create mode 100755 tools/testing/selftests/sgx/setup_epc_cg.sh
>  create mode 100755 tools/testing/selftests/sgx/watch_misc_for_tests.sh
>
> --=20
> 2.25.1

Thanks for taking the effort, must have been tedious!

BR, Jarkko
