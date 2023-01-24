From: Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>
Subject: [RFC PATCH 00/19] mm: Introduce a cgroup to limit the amount of locked and pinned memory
Date: Tue, 24 Jan 2023 16:42:29 +1100
Message-ID: <cover.f52b9eb2792bccb8a9ecd6bc95055705cfe2ae03.1674538665.git-series.apopple@nvidia.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=Nvidia.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=SjiFpve7UU1PFy62Cv9loVcC9ZrCHwMjfsJQ2a58EO0=;
 b=TQxk4/Oh3nrA3NDEChbqEG1UgNQUTho1ie3iC0sF89WFW4bZo6Y87y4jhfEkuDGOKZQflQpe9qonRWNFq5662fMUWyvHZ+e1I3KB35PdYOsJzRdAdj6psTaAQQ2MjcsMzt3xcZRVwHVImTAM56nk0FbxFk8C8t6yy6snRJQYU73ANFRU9Cug6z3HmTSjYaxuaFG6VhvipE+6PiaPdmt1o1q6kNf8nhYQTV/FwFJJEvg5lb0thySMx0W5WO6YjxIOOmdnVG3zND7uY8+Q7S+LP89E1krIGVpIrNBlWJNN9MYmDl+MxTKmHvxAb4F8pG19WGOth696uLjqCve10U3tAg==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgg-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, jhubbard-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org, tjmercier-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mkoutny-IBi9RG/b67k@public.gmane.org, daniel-/w4YWyX8dFk@public.gmane.org, Alistair Popple <apopple-DDmLM1+adcrQT0dZR+AlfA@public.gmane.org>

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

The second part of the series adds the cgroup and converts core mm
code such as mlock over to charging the cgroup before finally
introducing some selftests.

As I don't have access to systems with all the various devices I
haven't been able to test all driver changes. Any help there would be
appreciated.

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
 arch/powerpc/mm/book3s64/iommu_api.c     |  29 +--
 drivers/fpga/dfl-afu-dma-region.c        |  11 +-
 drivers/fpga/dfl-afu.h                   |   1 +-
 drivers/infiniband/core/umem.c           |  16 +-
 drivers/infiniband/core/umem_odp.c       |   6 +-
 drivers/infiniband/hw/usnic/usnic_uiom.c |  13 +-
 drivers/infiniband/hw/usnic/usnic_uiom.h |   1 +-
 drivers/infiniband/sw/siw/siw.h          |   2 +-
 drivers/infiniband/sw/siw/siw_mem.c      |  20 +--
 drivers/infiniband/sw/siw/siw_verbs.c    |  15 +-
 drivers/vdpa/vdpa_user/vduse_dev.c       |  20 +--
 drivers/vfio/vfio_iommu_spapr_tce.c      |  15 +-
 drivers/vfio/vfio_iommu_type1.c          |  59 +----
 drivers/vhost/vdpa.c                     |   9 +-
 drivers/vhost/vhost.c                    |   2 +-
 drivers/vhost/vhost.h                    |   1 +-
 include/linux/cgroup.h                   |  20 ++-
 include/linux/cgroup_subsys.h            |   4 +-
 include/linux/io_uring_types.h           |   3 +-
 include/linux/kvm_host.h                 |   1 +-
 include/linux/mm.h                       |   5 +-
 include/linux/mm_types.h                 |  88 ++++++++-
 include/linux/skbuff.h                   |   6 +-
 include/net/sock.h                       |   2 +-
 include/net/xdp_sock.h                   |   2 +-
 include/rdma/ib_umem.h                   |   1 +-
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
 mm/util.c                                | 196 +++++++++++++++--
 net/core/skbuff.c                        |  47 +---
 net/rds/message.c                        |   9 +-
 net/xdp/xdp_umem.c                       |  38 +--
 tools/testing/selftests/vm/Makefile      |   1 +-
 tools/testing/selftests/vm/pins-cgroup.c | 271 ++++++++++++++++++++++++-
 virt/kvm/kvm_main.c                      |   3 +-
 48 files changed, 1114 insertions(+), 401 deletions(-)
 create mode 100644 mm/pins_cgroup.c
 create mode 100644 tools/testing/selftests/vm/pins-cgroup.c

base-commit: 2241ab53cbb5cdb08a6b2d4688feb13971058f65
-- 
git-series 0.9.1
