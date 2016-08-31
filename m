From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv12 0/3] rdmacg: IB/core: rdma controller support
Date: Wed, 31 Aug 2016 14:07:24 +0530
Message-ID: <1472632647-1525-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=LUMNh34v6szqKt7w301xLiksg+02l7K8rumaRmex9Uc=;
        b=E7rYUA3W9lPYHWEj6lCmz1Ogk3euC27nD8T4QlOrK4EfI8nVGvNnZ/7fmg9UR/M3YU
         oFEYDXlJTEROaU4RIlvnldlcnCoYnS8HPoAMh175qWdRzT2I8oc1UaTGYCHjSQFtNAPd
         6T3MBR+O0f0Eq5pDuqoWvIKZb9ufIe4B71QuQBwnDgLp8H6OdotnDxA8a7lFSA90q3PN
         m7e4GAknxnJZ9T0gTlBHX+pIkLyv3OvCsp41yxxtQWirsR0Ktn3Aqof54xRiABTtU3G/
         8PDJngta1aUWmkc5zBdQCEiKW58xdgxZPpr0dyzFNee1NdpAjQV2EmxTIAVpq6xwaPbU
         gxZA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, hch@lst.de, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

rdmacg: IB/core: rdma controller support

Patch is generated and tested against below Doug's linux-rdma
git tree.

URL: git://git.kernel.org/pub/scm/linux/kernel/git/dledford/rdma.git
Branch: master

Patchset is also compiled and tested against below Tejun's cgroup tree
using cgroup v2 mode.
URL: git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git
Branch: master

Overview:
Currently user space applications can easily take away all the rdma
device specific resources such as AH, CQ, QP, MR etc. Due to which other
applications in other cgroup or kernel space ULPs may not even get chance
to allocate any rdma resources. This results into service unavailibility.

RDMA cgroup addresses this issue by allowing resource accounting,
limit enforcement on per cgroup, per rdma device basis.

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

 Documentation/cgroup-v1/rdma.txt    | 117 +++++++
 Documentation/cgroup-v2.txt         |  45 +++
 drivers/infiniband/core/Makefile    |   1 +
 drivers/infiniband/core/cgroup.c    |  93 +++++
 drivers/infiniband/core/core_priv.h |  41 +++
 drivers/infiniband/core/device.c    |  10 +
 include/linux/cgroup_rdma.h         |  66 ++++
 include/linux/cgroup_subsys.h       |   4 +
 init/Kconfig                        |  10 +
 kernel/Makefile                     |   1 +
 kernel/cgroup_rdma.c                | 664 ++++++++++++++++++++++++++++++++++++
 11 files changed, 1052 insertions(+)
 create mode 100644 Documentation/cgroup-v1/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup_rdma.c

-- 
1.8.3.1

