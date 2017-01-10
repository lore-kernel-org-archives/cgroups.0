From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv14 0/3] rdmacg: IB/core: rdma controller support
Date: Tue, 10 Jan 2017 00:02:12 +0000
Message-ID: <1484006535-4245-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=FQXsK9k/2L2o1+U03ltIA1gX+i0TAwfaBlJxxWeAufs=;
        b=B4M3SwTNxx0HfzpeTKRUrhivKa+Q4mMDpjGv/D4ZOYrLzyotXcCU4pFlt4egIsmGTE
         rg7A+R4Gk1HiF5Z1EUKhOq9f5b7JiKoxmAMBlL0AcXTmKvQGPJ4XyViuA2+G82knIdv9
         T5hhWd8QwAD4HiMdVy7XZfex+jnJdNnfCAkZWoI/ssH9rh8udPY7QUrRAD0QNtFfb6b7
         E/FReyBKEHLb7//s0S9nJhzhpB2/6VvrAZLI2EqN1kzlQ/4Jd2WSNmw7w1+dw+CDkp6a
         Qyl8iS4FAusFcG47h3772dxc1983fcDOjf6PdRtBbiDOTpr+6TsMLwVOCoh8P0BRcqVl
         wI2A==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

Patchset is compiled and tested against below Tejun's cgroup tree
using cgroup v1 and v2 mode.
URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
Branch: for-4.11

Overview:
Currently user space applications can easily take away the rdma
device specific resources such as AH, CQ, QP, MR etc. Due to which other
applications in other cgroup or kernel space ULPs may not even get chance
to allocate any rdma resources. This results into service unavailibility.

RDMA cgroup addresses this issue by allowing resource accounting,
limit enforcement on per cgroup, per rdma device basis.

RDMA uverbs layer will enforce limits on RDMA resources without
any HCA vendor device driver involvement.

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

Changes from v13: (To address comments from Tejun)
   1. Rebased to branch for-4.11.
   2. Typo corrected from hirerchy to hierarchy.
Changes from v12:
   1. Reverted back cgroup.c to GPLv2 license as last summary email of
      LPC 2016 from Christoph and Leon mentioned that OFA no longer
      mandates dual license on kernel code. (Similar to rw.c)
   2. Removed query_limit cgroup API as with consolidated/abstract objects
      configured limit is not useful anymore for ibv_query_device verb.
  * (To address comments from Tejun, Christoph, Leon, Liran, Doug, Matan.
     This is done based on the discussion in the LPC 2016.)
   1. Simplfied rdma cgroup to work only on two abstract resources,
      instead of granular rdma verb resources.
  * (To address comment from Leon)
   1. Replaced IS_ERR_OR_NULL replaced with IS_ERR as get_cg_rpool_locked
      never returns NULL.

Changes from v11:
  * (To address comments from Tejun)
   1. Added information in Documentation about nested-keyed file
  * (To address comments from Rami Rosen)
   1. Corrected typo errors in Documentation
  * (To address comments from Leon Romanovsky)
   1. Changed cgroup.c copyright to match with other files of the IB stack
      which is dual license GPLv2 + BSD

Changes from v10:
  * (To address comments from Tejun, Christoph)
   1. Removed unused rpool_list_lock from rdma_cgroup structure.
   2. Moved rdma resource definition to rdma cgroup instead of IB stack
   3. Added prefix rdmacg to static instances
   4. Simplified locking with single mutex for all operations
   5. Following approach of atomically allocating object and
      charging resource in hirerchy
   6. Code simplification due to single lock
   7. Using for_each_set_bit API for bit operation
   8. Renamed list heads as Objects instead of _head
   9. Renamed list entries as _node instead of _list.
  10. Made usage_num to 64 bit to avoid overflow and to avoid
      additional code to track non zero number of usage counts.
  * (To address comments from Doug)
   1. Added copyright and GPLv2 license

Changes from v9:
  * (To address comments from Tejun)
   1. Included clear documentation of resources.
   2. Fixed issue of race condition of process migration during
      charging stage.
   3. Fixed comments and code to adhere to CodingStyle.
   4. Simplified and removed support to charge/uncharge multiple
      resource.
   5. Fixed replaced refcnt with usage_num that tracks how many
      resources are unused to trigger freeing the object.
   6. Simplified locking scheme to use single spin lock for whole
      subsystem.

Changes from v8:
 * Fixed compilation error.
 * Fixed warning reported by checkpatch script.

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
 * Fixed uncharging to rdma controller after resource is released
   from verb layer, instead of uncharging first. This ensures that
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
 * Removed including parser.h from cgroup.c as its included by
   cgroup_rdma.h
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

 Documentation/cgroup-v1/rdma.txt      | 109 ++++++
 Documentation/cgroup-v2.txt           |  38 +++
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/cgroup.c      |  62 ++++
 drivers/infiniband/core/core_priv.h   |  30 ++
 drivers/infiniband/core/device.c      |  10 +
 drivers/infiniband/core/uverbs_cmd.c  | 102 +++++-
 drivers/infiniband/core/uverbs_main.c |  20 ++
 include/linux/cgroup_rdma.h           |  53 +++
 include/linux/cgroup_subsys.h         |   4 +
 include/rdma/ib_verbs.h               |  14 +
 init/Kconfig                          |  10 +
 kernel/cgroup/Makefile                |   1 +
 kernel/cgroup/rdma.c                  | 617 ++++++++++++++++++++++++++++++++++
 14 files changed, 1065 insertions(+), 6 deletions(-)
 create mode 100644 Documentation/cgroup-v1/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup/rdma.c

-- 
2.7.4
