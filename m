From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 00/19] mm: Introduce a cgroup to limit the amount of locked and pinned memory
Date: Mon,  6 Feb 2023 18:47:37 +1100
Message-ID: <cover.c238416f0e82377b449846dbb2459ae9d7030c8e.1675669136.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FEFLPj2bWgoScYUqwTVgfs3MlEN9Gob9d5vdVik3qT8=;
 b=ITF7ucOHy201DRpcx8D3LlPeKtQ9PSMyM/7kCv4yGRH9jCOXLK+V0QxgavTbeCY0yUY+BENrsaIercU61Kmo+EwMQtRGzqw80uiUJfJ4qe1nmOr5IBHUEVobtDfxPoGddK6u/Rx05Nx1Oqxr5oslrciKTkrEmTa3ZYuXiIKZgCYBhzoGxwmz4qi/YH3h/P9tcZIgpuidtXMzZC4a8ZzxY5gEYLQT8D348lwB584yoawVKUMBW3XrPMb6AkHsHpyda3mcVZB2y+qcH2Uq0C9LSfeW3JcYJFbVNFo1eCYsKdiz3SsW6ecZ0Yic7AOjm2HJVb8v+Fh2qR628x63kHdiEA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, "Daniel P . Berrange" <berrange-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alex Williamson <alex.williamson-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

Having large amounts of unmovable or unreclaimable memory in a system
can lead to system instability due to increasing the likelihood of
encountering out-of-memory conditions. Therefore it is desirable to
limit the amount of memory users can lock or pin.

From userspace such limits can be enforced by setting
RLIMIT_MEMLOCK. However there is no standard method that drivers and
other in-kernel users can use to check and enforce this limit.

This has lead to a large number of inconsistencies in how limits are
enforced. For example some drivers will use mm->locked_mm while others
will use mm->pinned_mm or user->locked_mm. It is therefore possible to
have up to three times RLIMIT_MEMLOCKED pinned.

Having pinned memory limited per-task also makes it easy for users to
exceed the limit. For example drivers that pin memory with
pin_user_pages() it tends to remain pinned after fork. To deal with
this and other issues this series introduces a cgroup for tracking and
limiting the number of pages pinned or locked by tasks in the group.

However the existing behaviour with regards to the rlimit needs to be
maintained. Therefore the lesser of the two limits is
enforced. Furthermore having CAP_IPC_LOCK usually bypasses the rlimit,
but this bypass is not allowed for the cgroup.

The first part of this series converts existing drivers which
open-code the use of locked_mm/pinned_mm over to a common interface
which manages the refcounts of the associated task/mm/user
structs. This ensures accounting of pages is consistent and makes it
easier to add charging of the cgroup.

The second part of the series adds the cgroup controller and converts
core mm code such as mlock over to charging the cgroup before finally
introducing some selftests.

Rather than adding onto an exisiting cgroup controller such as memcg
we introduce a new controller. This is primarily because we wish to
limit the total number of pages tasks within a cgroup may pin/lock.

As I don't have access to systems with all the various devices I
haven't been able to test all driver changes. Any help there would be
appreciated.

Note that this series is based on v6.2-rc5 and
https://lore.kernel.org/linux-rdma/20230201115540.360353-1-bmt-OA+xvbQnYDHMbYB6QlFGEg@public.gmane.org/
which makes updating the siw driver easier (thanks Bernard).

Changes from initial RFC:

 - Fixes to some driver error handling.

 - Pages charged with vm_account will always increment mm->pinned_vm
   and enforce the limit against user->locked_vm or mm->pinned_vm
   depending on initialisation flags.

 - Moved vm_account prototypes and struct definitions into a separate header.

 - Minor updates to commit messages and kernel docs (thanks to Jason,
   Christoph, Yosry and T.J.).

Outstanding issues:

 - David H pointed out that the vm_account naming is potentially
   confusing and I agree. However I have yet to come up with something
   better so will rename this in a subsequent version of this series
   (suggestions welcome).

 - Jason G raised some issues with adding the accounting struct to
   struct sock which are unresolved.

Alistair Popple (19):
  mm: Introduce vm_account
  drivers/vhost: Convert to use vm_account
  drivers/vdpa: Convert vdpa to use the new vm_structure
  infiniband/umem: Convert to use vm_account
  RMDA/siw: Convert to use vm_account
  RDMA/usnic: convert to use vm_account
  vfio/type1: Charge pinned pages to pinned_vm instead of locked_vm
  vfio/spapr_tce: Convert accounting to pinned_vm
  io_uring: convert to use vm_account
  net: skb: Switch to using vm_account
  xdp: convert to use vm_account
  kvm/book3s_64_vio: Convert account_locked_vm() to vm_account_pinned()
  fpga: dfl: afu: convert to use vm_account
  mm: Introduce a cgroup for pinned memory
  mm/util: Extend vm_account to charge pages against the pin cgroup
  mm/util: Refactor account_locked_vm
  mm: Convert mmap and mlock to use account_locked_vm
  mm/mmap: Charge locked memory to pins cgroup
  selftests/vm: Add pins-cgroup selftest for mlock/mmap

 MAINTAINERS                              |   8 +-
 arch/powerpc/kvm/book3s_64_vio.c         |  10 +-
 arch/powerpc/mm/book3s64/iommu_api.c     |  30 +--
 drivers/fpga/dfl-afu-dma-region.c        |  11 +-
 drivers/fpga/dfl-afu.h                   |   2 +-
 drivers/infiniband/core/umem.c           |  16 +-
 drivers/infiniband/core/umem_odp.c       |   6 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c |  14 +-
 drivers/infiniband/hw/usnic/usnic_uiom.h |   2 +-
 drivers/infiniband/sw/siw/siw.h          |   3 +-
 drivers/infiniband/sw/siw/siw_mem.c      |  21 +--
 drivers/infiniband/sw/siw/siw_verbs.c    |  15 +-
 drivers/vdpa/vdpa_user/vduse_dev.c       |  21 +--
 drivers/vfio/vfio_iommu_spapr_tce.c      |  16 +-
 drivers/vfio/vfio_iommu_type1.c          |  60 +----
 drivers/vhost/vdpa.c                     |  17 +-
 drivers/vhost/vhost.c                    |   2 +-
 drivers/vhost/vhost.h                    |   2 +-
 include/linux/cgroup.h                   |  20 ++-
 include/linux/cgroup_subsys.h            |   4 +-
 include/linux/io_uring_types.h           |   4 +-
 include/linux/kvm_host.h                 |   2 +-
 include/linux/mm.h                       |   5 +-
 include/linux/skbuff.h                   |   7 +-
 include/linux/vm_account.h               |  57 +++++-
 include/net/sock.h                       |   3 +-
 include/net/xdp_sock.h                   |   3 +-
 include/rdma/ib_umem.h                   |   2 +-
 io_uring/io_uring.c                      |  20 +--
 io_uring/notif.c                         |   4 +-
 io_uring/notif.h                         |  10 +-
 io_uring/rsrc.c                          |  38 +---
 io_uring/rsrc.h                          |   9 +-
 mm/Kconfig                               |  11 +-
 mm/Makefile                              |   1 +-
 mm/internal.h                            |   2 +-
 mm/mlock.c                               |  76 +------
 mm/mmap.c                                |  76 +++----
 mm/mremap.c                              |  54 +++--
 mm/pins_cgroup.c                         | 273 ++++++++++++++++++++++++-
 mm/secretmem.c                           |   6 +-
 mm/util.c                                | 234 +++++++++++++++++++--
 net/core/skbuff.c                        |  47 +---
 net/rds/message.c                        |  10 +-
 net/xdp/xdp_umem.c                       |  38 +--
 tools/testing/selftests/vm/Makefile      |   1 +-
 tools/testing/selftests/vm/pins-cgroup.c | 271 ++++++++++++++++++++++++-
 virt/kvm/kvm_main.c                      |   3 +-
 48 files changed, 1143 insertions(+), 404 deletions(-)
 create mode 100644 include/linux/vm_account.h
 create mode 100644 mm/pins_cgroup.c
 create mode 100644 tools/testing/selftests/vm/pins-cgroup.c

base-commit: f0076df3552b965d8107318bd9d9e678530f1687
-- 
git-series 0.9.1
