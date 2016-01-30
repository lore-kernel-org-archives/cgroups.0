From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv2 0/3] rdma controller support
Date: Sat, 30 Jan 2016 17:11:24 +0530
Message-ID: <1454154087-27375-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=czvOQGMXN9akbvaFGNWMiYHbVEv/T/AbQ/n9vFt/9mU=;
        b=fviaDlP/64cu6j8x+DnMCfbQMz65p8gU9R3N3mk4yHULt3K+CXsBCOn49MBuxfXidA
         XqZhh+oZ0E5h52uPs6vT3+JTnrM17kRk6tA0+kHBhglGoN/fZFPqGGcqC9/D5xdMW57u
         BchFwythbtJhUKNeerOcpZ6kxhVv2F5zfpjwx5bHKSStP3OqpiEDNEqkoDh/VgrKjd+T
         mvs/01fQQ0Zxcb9QxnRhMyBqKH6Xgoy4OIpyqb4bvjM9OfCw/Tkl07w++TCtGN4+u2gC
         aG6t3SNXcdirWILeW9v/vOSMFlLmJoIUsG5+Q3QD9WEjnBN+BZLexERUBzgvEwHtez/4
         ersg==
Sender: linux-doc-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

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

 Documentation/cgroup-v1/rdma.txt      |  122 ++++
 Documentation/cgroup-v2.txt           |   43 ++
 drivers/infiniband/core/Makefile      |    1 +
 drivers/infiniband/core/cgroup.c      |  108 ++++
 drivers/infiniband/core/core_priv.h   |   45 ++
 drivers/infiniband/core/device.c      |    8 +
 drivers/infiniband/core/uverbs_cmd.c  |  209 ++++++-
 drivers/infiniband/core/uverbs_main.c |   28 +
 include/linux/cgroup_rdma.h           |   78 +++
 include/linux/cgroup_subsys.h         |    4 +
 include/rdma/ib_verbs.h               |   27 +-
 init/Kconfig                          |   12 +
 kernel/Makefile                       |    1 +
 kernel/cgroup_rdma.c                  | 1021 +++++++++++++++++++++++++++++++++
 14 files changed, 1691 insertions(+), 16 deletions(-)
 create mode 100644 Documentation/cgroup-v1/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup_rdma.c

-- 
1.8.3.1

