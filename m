From: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCHv4 0/3] rdmacg: IB/core: rdma controller support
Date: Sun, 31 Jan 2016 03:58:18 +0530
Message-ID: <1454192901-31003-1-git-send-email-pandit.parav@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=siRyS3yz17hi+Vb+uyS4o/z2h5SucIdoQWv2evwD4p0=;
        b=aYolx1Je4hbpvFkk2FvsCwM3AIQ7TezwgDDbHcY52B4cN+ys2T0HabcbOJ7aIKD1qN
         GatF51pHGh2qdP8PHBu56Tj3Zxv7CyUgA7JZ8OGX3aJvW5o7pN9X7tJP/6BUaJESoz/Q
         uusIU+gD4Kws0G4UeLq6a7dx5Y4v9faPNEZwbMfZb2Ff1uWEB1CiVrBRAOtMWaw2VWde
         oVSY5CTHLhdcLE2LJ1L8uP7HdFi1uBKdR2Z0nqgB45yF9szQFgcrP3ewKo7/zKGNnEKv
         r929wLABEcJlLIXGTSYnIXSkuIg4l2EBZRCjGs1V6JIe1B1RlGGoPRkq6UqTj2SpRIcR
         gmaw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: corbet-T1hC0tSOHrs@public.gmane.org, james.l.morris-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org, serge-A9i7LUbDfNHQT0dZR+AlfA@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org, linux-security-module-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org

This patchset adds support for RDMA cgroup by addressing review comments
of [2], [1] and by implementing published RFC [3].

Overview:
Currently user space applications can easily take away all the rdma
device specific resources such as AH, CQ, QP, MR etc. Due to which other
applications in other cgroup or kernel space ULPs may not even get chance
to allocate any rdma resources. This results into service unavailibility.

RDMA cgroup addresses this issue by allowing resource accounting,
limit enforcement on per cgroup, per rdma device basis.

Resources are not defined by the RDMA cgroup. Resources are defined
by RDMA/IB stack & optionally by HCA vendor device drivers.
This allows rdma cgroup to remain constant while RDMA/IB
stack can evolve without the need of rdma cgroup update. A new
resource can be easily added by the RDMA/IB stack without touching
rdma cgroup.

RDMA uverbs layer will enforce limits on well defined RDMA verb
resources without any HCA vendor device driver involvement.

RDMA uverbs layer will not do accounting of hw vendor specific resources.
Instead rdma cgroup provides set of APIs through which vendor specific 
drivers can define their own resources (upto 64) that can be accounted by
rdma cgroup.

Resource limit enforcement is hierarchical.

When process is migrated with active RDMA resources, rdma cgroup
continues to uncharge original cgroup for allocated resource. New resource
is charged to current process's cgroup, which means if the process is
migrated with active resources, for new resources it will be charged to
new cgroup and old resources will be correctly uncharged from old cgroup.

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

[1] https://lkml.org/lkml/2016/1/5/632
[2] https://lkml.org/lkml/2015/9/7/476
[3] https://lkml.org/lkml/2015/10/28/144

This patchset is for Tejun's for-4.5 branch.
It is not attempted on Doug's rdma tree yet, which I will do once I receive
comments for this pathset.


Parav Pandit (3):
  rdmacg: Added rdma cgroup controller.
  IB/core: added support to use rdma cgroup controller
  rdmacg: Added documentation for rdma controller

 Documentation/cgroup-v1/rdma.txt      | 117 ++++
 Documentation/cgroup-v2.txt           |  43 ++
 drivers/infiniband/core/Makefile      |   1 +
 drivers/infiniband/core/cgroup.c      | 137 +++++
 drivers/infiniband/core/core_priv.h   |  45 ++
 drivers/infiniband/core/device.c      |   8 +
 drivers/infiniband/core/uverbs_cmd.c  | 209 ++++++-
 drivers/infiniband/core/uverbs_main.c |  28 +
 include/linux/cgroup_rdma.h           |  79 +++
 include/linux/cgroup_subsys.h         |   4 +
 include/rdma/ib_verbs.h               |  27 +-
 init/Kconfig                          |  11 +
 kernel/Makefile                       |   1 +
 kernel/cgroup_rdma.c                  | 995 ++++++++++++++++++++++++++++++++++
 14 files changed, 1689 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/cgroup-v1/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup_rdma.c

-- 
1.8.3.1
