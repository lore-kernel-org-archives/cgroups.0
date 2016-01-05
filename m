From: Parav Pandit <pandit.parav@gmail.com>
Subject: [PATCHv1 0/6] rdma controller support
Date: Wed,  6 Jan 2016 00:28:00 +0530
Message-ID: <1452020286-9508-1-git-send-email-pandit.parav@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id;
        bh=n+6+lku7GmsyK7gKo9fIENHeWnB5k1Q9kuEyVtv9kcw=;
        b=Yr4tliWuFblLKcLQ/2uMpMzvUeIcYtTn3Gmjqv8/xWzvfphNt1DWgQimDGDLzbIUBR
         EOTcZYP/ZLW/Jie0y9m2ujrUOjfehNW1l5qHK3XZY/3lKO68xrvKMuUSoUBYq+AkPx98
         1ulXFUFzmqIHzz7ug6DEswW0rmOAkUxMuOHGkd41a2PtQh1Yv4LZIHfo3fEVD6LiLv8q
         4q0f3Z9xYgWmFnF/OPSuGRwJvbvM0p9pyH5tFGySsS/zvQEx2aAESJ0QX9NEC8ibXcpn
         fzfCOLRn3qS+44tFS6ZVvz1GUPN+Iweu9BACVEHNlKeIgIjgFptOKuM/PenaaI3JCnTv
         Bw8w==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, dledford@redhat.com, liranl@mellanox.com, sean.hefty@intel.com, jgunthorpe@obsidianresearch.com, haggaie@mellanox.com
Cc: corbet@lwn.net, james.l.morris@oracle.com, serge@hallyn.com, ogerlitz@mellanox.com, matanb@mellanox.com, raindel@mellanox.com, akpm@linux-foundation.org, linux-security-module@vger.kernel.org, pandit.parav@gmail.com

This patchset adds support for RDMA cgroup by addressing review comments
of [1] by implementing published RFC [2].

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
continues to charge original cgroup.

Changes from v0:
(To address comments from Haggai, Doug, Liran, Tejun, Sean, Jason)
 * Redesigned to support per device per cgroup limit settings by bringing
   concept of resource pool.
 * Redesigned to let IB stack define the resources instead of rdma controller
   using resource template.
 * Redesigned to support hw vendor specific limits setting (optional to drivers).
 * Created new rdma controller instead of piggyback on device cgroup.
 * Fixed race conditions for multiple tasks sharing rdma resources.
 * Removed dependency on the task_struct.

[1] https://lkml.org/lkml/2015/9/7/476
[2] https://lkml.org/lkml/2015/10/28/144

This patchset is for Tejun's for-4.5 branch.
It is not attempted on Doug's rdma tree yet, which I will do once I receive
comments for this pathset.

Parav Pandit (6):
  rdmacg: Added rdma cgroup header file
  IB/core: Added members to support rdma cgroup
  rdmacg: implements rdma cgroup
  IB/core: rdmacg support infrastructure APIs
  IB/core: use rdma cgroup for resource accounting
  rdmacg: Added documentation for rdma controller.

 Documentation/cgroup-legacy/rdma.txt  |  129 ++++
 Documentation/cgroup.txt              |   79 +++
 drivers/infiniband/core/Makefile      |    1 +
 drivers/infiniband/core/cgroup.c      |   80 +++
 drivers/infiniband/core/core_priv.h   |    5 +
 drivers/infiniband/core/device.c      |    8 +
 drivers/infiniband/core/uverbs_cmd.c  |  244 ++++++-
 drivers/infiniband/core/uverbs_main.c |   30 +
 include/linux/cgroup_rdma.h           |   91 +++
 include/linux/cgroup_subsys.h         |    4 +
 include/rdma/ib_verbs.h               |   20 +
 init/Kconfig                          |   12 +
 kernel/Makefile                       |    1 +
 kernel/cgroup_rdma.c                  | 1220 +++++++++++++++++++++++++++++++++
 14 files changed, 1907 insertions(+), 17 deletions(-)
 create mode 100644 Documentation/cgroup-legacy/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup_rdma.c

-- 
1.8.3.1
