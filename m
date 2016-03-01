From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv8 0/3] rdmacg: IB/core: rdma controller support
Date: Tue,  1 Mar 2016 19:56:37 +0530
Message-ID: <1456842400-29528-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=88eBZYxLFn8Qhu4BHpVxrO66uxLd33bflikkosQrVV0=;
        b=PVJDfOSQa1RTt3fEQbS/TTl0bbCuZK3MfHZDFlCbjlfjXO4ht33OCQDoZfeze1sTfy
         3DEfMcEqxt74ID3bRg3Jml4FILfRB7OxIq3CRjByw6G7Z/ASfNB/SHuLnZHYb1TYVpTp
         27uraviaxItgUj7Qmjo07LJ8AKMhcdFLhsrCuLcKPjGWEo3GanqlRr83TeHoJSHyOcTw
         x1qEJQStLPESyk0OInw0vxyziXWw8uv9gAS386lYZAzoPNmXYap3eWZ15pCpSkcvSOTD
         seoaUHFoXRUIbmb12TR8qo0JHc8mNlC5JyG+nPwg4TsLm6d1WBTB2FELCEJKrok4sWNY
         pruQ==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Patch is generated and tested against below Doug's linux-rdma
git tree as it merges cleanly with both the git tree
(linux-rdma and linux-cgroup).

URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
Branch: k.o/for-4.6

Patch 1/3, 3/3 also compiles against Tejun's cgroup tree as well
and tested with little different patch of 2/3 as both the
trees are little different.

Overview:
Currently user space applications can easily take away all the rdma
device specific resources such as AH, CQ, QP, MR etc. Due to which other
applications in other cgroup or kernel space ULPs may not even get chance
to allocate any rdma resources. This results into service unavailibility.

RDMA cgroup addresses this issue by allowing resource accounting,
limit enforcement on per cgroup, per rdma device basis.

Resources are not defined by the RDMA cgroup. Instead they are defined
by RDMA/IB stack. This allows rdma cgroup to remain constant while RDMA/IB
stack can evolve without the need of rdma cgroup update. A new
resource can be easily added by the RDMA/IB stack without touching
rdma cgroup.

RDMA uverbs layer will enforce limits on well defined RDMA verb
resources without any HCA vendor device driver involvement.

RDMA uverbs layer will not do limit enforcement of HCA hw vendor
specific resources. Instead rdma cgroup provides set of APIs
through which vendor specific drivers can do resource accounting
by making use of rdma cgroup.

Resource limit enforcement is hierarchical.

When process is migrated with active RDMA resources, rdma cgroup
continues to uncharge original cgroup for allocated resource. New resource
is charged to current process's cgroup, which means if the process is
migrated with active resources, for new resources it will be charged to
new cgroup and old resources will be correctly uncharged from old cgroup.

Changes from v7:
 * (To address comments from Haggai)
   1. Removed max_limit from query_limit function as it is
      unnecessary.
   2. Kept existing printk as it is to instead of replacing all
      with pr_warn except newly added printk.

Changes from v6:
 * (To address comments from Haggai)
   1. Made functions as void wherever necessary.
   2. Code cleanup related to correting few spelling mistakes
      in comments, correcting comments to reflect the code.
   3. Removed max_count parameter from query_limit as its not
      necessary.
   4. Fixed printk to pr_warn.
   5. Removed dependency on pd, instead relying on ib_dev.
   6. Added more documentation to reflect that IB stack honors
      configured limit during query_device operation.
   7. Added pr_warn and avoided system crash in case of
      IB stack or rdma cgroup bug.
 * (To address comments from Leon)
   1. Removed #ifdef CONFIG_CGROUP_RDMA from .c files and added
      necessary dummy functions in header file.
   2. Removed unwanted forward declaration.
 * Fixed uncharing to rdma controller after resource is released
   from verb layer, instead of uncharing first. This ensures that
   uncharging doesn't complete while resource is still allocated.
 
Changes from v5:
 * (To address comments from Tejun)
   1. Removed two type of resource pool, made is single type (as Tejun
      described in past comment)
   2. Removed match tokens and have array definition like "qp", "mr",
      "cq" etc.
   3. Wrote small parser and avoided match_token API as that won't work
      due to different array definitions
   4. Removed one-off remove API to unconfigure cgroup, instead all
      resource should be set to max.
   5. Removed resource pool type (user/default), instead having
      max_num_cnt, when ref_cnt drops to zero and
      max_num_cnt = total_rescource_cnt, pool is freed.
   6. Resource definition ownership is now only with IB stack at single
      header file, no longer in each low level driver.
      This goes through IB maintainer and other reviewers eyes.
      This continue to give flexibility to not force kernel upgrade for
      few enums additions for new resource type.
   7. Wherever possible pool lock is pushed out, except for hierarchical
      charging/unchanging points, as it not possible to do so, due to
      iterative process involves blocking allocations of rpool. Coming up
      more levels up to release locks doesn't make any sense either.
      This is anyway slow path where rpool is not allocated. Except for
      typical first resource allocation, this is less travelled path.
   8. Avoided %d manipulation due to removal of match_token and replaced
      with seq_putc etc friend functions.
 * Other minor cleanups.
 * Fixed rdmacg_register_device to return error in case of IB stack
   tries to register for than 64 resources.
 * Fixed not allowing negative value on resource setting.
 * Fixed cleaning up resource pools during device removal.
 * Simplfied and rename table length field to use ARRAY_SIZE macro.
 * Updated documentation to reflect single resource pool and shorter
   file names.

Changes from v4:
 * Fixed compilation errors for lockdep_assert_held reported by kbuild
   test robot
 * Fixed compilation warning reported by coccinelle for extra
   semicolon.
 * Fixed compilation error for inclusion of linux/parser.h which
   cannot be included in any header file, as that triggers multiple
   inclusion error. parser.h is included in C files which intent to
   use it.
 * Removed unused header file inclusion in cgroup_rdma.c

Changes from v3:
 * (To address comments from Tejun)
   1. Renamed cg_resource to rdmacg_resource
   2. Merged dealloc_cg_rpool and _dealloc_cg_rpool to single function
   3. Renamed _find_cg_rpool to find_cg_rpool_locked()
   5. Removed RDMACG_MAX_RESOURCE_INDEX limitation
   6. Fixed few alignments.
   7. Improved description for RDMA cgroup configuration menu
   8. Renamed cg_list_lock to rpool_list_lock to reflect the lock
      is for rpools.
   9. Renamed _get_cg_rpool to find_cg_rpool.
   10. Made creator as int variable, instead of atomic as its not 
      required to be atomic.
 * Fixed freeing right rpool during query_limit error path
 * Added copywrite for cgroup.c
 * Removed including parser.h from cgroup.c as its included by cgroup_rdma.h
 * Reduced try_charge functions to single function and removed duplicate
   comments.

Changes from v2:
 * Fixed compilation error reported by 0-DAY kernel test infrastructure
   for m68k architecture where CONFIG_CGROUP is also not defined.
 * Fixed comment in patch to refer to legacy mode of cgroup, changed to 
   refer to v1 and v2 version.
 * Added more information in commit log for rdma controller patch.

Changes from v1:
 * (To address comments from Tejun)
   a. reduces 3 patches to single patch
   b. removed resource word from the cgroup configuration files
   c. changed cgroup configuration file names to match other cgroups
   d. removed .list file and merged functionality with .max file
 * Based on comment to merge to single patch for rdma controller;
   IB/core patches are reduced to single patch.
 * Removed pid cgroup map and simplified design -
   Charge/Uncharge caller stack keeps track of the rdmacg for
   given resource. This removes the need to maintain and perform
   hash lookup. This also allows little more accurate resource
   charging/uncharging when process moved from one to other cgroup
   with active resources and continue to allocate more.
 * Critical fix: Removed rdma cgroup's dependency on the kernel module
   header files to avoid crashes when modules are upgraded without kernel
   upgrade, which is very common due to high amount of changes in IB stack
   and it is also shipped as individual kernel modules.
 * uboject extended to keep track of the owner rdma cgroup, so that same
   rdmacg can be used while uncharging.
 * Added support functions to hide details of rdmacg device in uverbs
   modules for cases of cgroup enabled/disabled at compile time. This
   avoids multiple ifdefs for every API in uverbs layer.
 * Removed failure counters in first patch, which will be added once
   initial feature is merged.
 * Fixed stale rpool access which is getting freed, while doing
   configuration to rdma.verb.max file.
 * Fixed rpool resource leak while querying max, current values.

Changes from v0:
(To address comments from Haggai, Doug, Liran, Tejun, Sean, Jason)
 * Redesigned to support per device per cgroup limit settings by bringing
   concept of resource pool.
 * Redesigned to let IB stack define the resources instead of rdma
   controller using resource template.
 * Redesigned to support hw vendor specific limits setting
   (optional to drivers).
 * Created new rdma controller instead of piggyback on device cgroup.
 * Fixed race conditions for multiple tasks sharing rdma resources.
 * Removed dependency on the task_struct.


Parav Pandit (3):
  rdmacg: Added rdma cgroup controller
  IB/core: added support to use rdma cgroup controller
  rdmacg: Added documentation for rdmacg

 Documentation/cgroup-v1/rdma.txt      | 111 +++++
 Documentation/cgroup-v2.txt           |  33 ++
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/cgroup.c      | 111 +++++
 drivers/infiniband/core/core_priv.h   |  43 ++
 drivers/infiniband/core/device.c      |  11 +
 drivers/infiniband/core/uverbs_cmd.c  | 137 +++++-
 drivers/infiniband/core/uverbs_main.c |  19 +
 include/linux/cgroup_rdma.h           |  51 +++
 include/linux/cgroup_subsys.h         |   4 +
 include/rdma/ib_verbs.h               |  29 ++
 init/Kconfig                          |  10 +
 kernel/Makefile                       |   1 +
 kernel/cgroup_rdma.c                  | 760 ++++++++++++++++++++++++++++++++++
 14 files changed, 1306 insertions(+), 15 deletions(-)
 create mode 100644 Documentation/cgroup-v1/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup_rdma.c

-- 
1.8.3.1
