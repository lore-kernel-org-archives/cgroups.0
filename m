From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup changes for v4.11-rc1
Date: Mon, 27 Feb 2017 15:21:29 -0500
Message-ID: <20170227202129.GE8707@htj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=jJiE30PoxKbOZqJvepqNMoppXller4kvwezqK9XsxCg=;
        b=KhqaSw6+NE0IwNs7YoqlsC5eOCxHAVN3vr4LzHjLZ8q6p3TralJkE8ni/i/mnbwC4j
         Ba47lgNSQg/m3cTB/9ZC5arVA2x/go2p62MsQDjmDKyY2d9lMmmYmTnJptoPn5tmO90d
         cfFse3RU+QOIh/0Cl/wiWxaBAkjNI6wZchop4WQIOe19HtUDRnbZ7HJBcj+Ubd4nx73M
         dHralzlX7qF3aJy/xtTN4h6TdlGcCe5h8/bUu4oHHRBAWA5nUQOLWdCylpfl/siTSWYu
         TJghv/4q5C/iWbvG9eBs9pUN6tDpTpKqSg475aNcCzg5JvlItdUgvf+D+BDxmOlsuACw
         uYRg==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Hello, Linus.

cgroup changes for v4.11.  Several noteworthy changes.

* Parav's rdma controller is finally merged.  It is very straight
  forward and can limit the abosolute numbers of common rdma
  constructs used by different cgroups.

* kernel/cgroup.c got too chubby and disorganized.  Created
  kernel/cgroup/ subdirectory and moved all cgroup related files under
  kernel/ there and reorganized the core code.  This hurts for
  backporting patches but was long overdue.

* cgroup v2 process listing reimplemented so that it no longer depends
  on allocating a buffer large enough to cache the entire result to
  sort and uniq the output.  v2 has always mangled the sort order to
  ensure that users don't depend on the sorted output, so this
  shouldn't surprise anybody.  This makes the pid listing functions
  use the same iterators that are used internally, which have to have
  the same iterating capabilities anyway.

* perf cgroup filtering now works automatically on cgroup v2.  This
  patch was posted a long time ago but somehow fell through the
  cracks.

* Misc fixes asnd documentation updates.

Thanks.

The following changes since commit 07cd12945551b63ecb1a349d50a6d69d1d6feb4a:

  cgroup: don't online subsystems before cgroup_name/path() are operational (2017-01-26 16:47:28 -0500)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.11

for you to fetch changes up to f83f3c515654474e19c7fc86e3b06564bb5cb4d4:

  kernfs: fix locking around kernfs_ops->release() callback (2017-02-21 15:49:25 -0500)

----------------------------------------------------------------
Geliang Tang (1):
      cgroup: fix a comment typo

Hans Ragas (1):
      cgroup: Add missing cgroup-v2 PID controller documentation.

Parav Pandit (4):
      rdmacg: Added rdma cgroup controller
      IB/core: added support to use rdma cgroup controller
      rdmacg: Added documentation for rdmacg
      rdmacg: Fixed uninitialized current resource usage

Tejun Heo (23):
      kernfs: make kernfs_open_file->mmapped a bitfield
      kernfs: add kernfs_ops->open/release() callbacks
      cgroup add cftype->open/release() callbacks
      cgroup: reimplement reading "cgroup.procs" on cgroup v2
      cgroup: remove cgroup_pid_fry() and friends
      cgroup: reorder css_set fields
      cgroup: move cgroup files under kernel/cgroup/
      cgroup: move cgroup v1 specific code to kernel/cgroup/cgroup-v1.c
      cgroup: refactor mount path and clearly distinguish v1 and v2 paths
      cgroup: separate out cgroup1_kf_syscall_ops
      cgroup: move v1 mount functions to kernel/cgroup/cgroup-v1.c
      cgroup: rename functions for consistency
      cgroup: move namespace code to kernel/cgroup/namespace.c
      cgroup: fix RCU related sparse warnings
      cgroup: cosmetic update to cgroup_taskset_add()
      cgroup: track migration context in cgroup_mgctx
      cgroup: call subsys->*attach() only for subsystems which are actually affected by migration
      Merge branch 'for-4.10-fixes' into for-4.11
      cgroup: misc cleanups
      cgroup, perf_event: make perf_event controller work on cgroup2 hierarchy
      cgroup: drop the matching uid requirement on migration for cgroup v2
      Merge branch 'cgroup/for-4.11-rdmacg' into cgroup/for-4.11
      kernfs: fix locking around kernfs_ops->release() callback

 Documentation/cgroup-v1/rdma.txt              |  109 ++
 Documentation/cgroup-v2.txt                   |  103 +-
 drivers/infiniband/core/Makefile              |    1 +
 drivers/infiniband/core/cgroup.c              |   62 +
 drivers/infiniband/core/core_priv.h           |   30 +
 drivers/infiniband/core/device.c              |   10 +
 drivers/infiniband/core/uverbs_cmd.c          |  102 +-
 drivers/infiniband/core/uverbs_main.c         |   20 +
 fs/kernfs/dir.c                               |    2 +-
 fs/kernfs/file.c                              |   62 +-
 fs/kernfs/kernfs-internal.h                   |    2 +-
 include/linux/cgroup-defs.h                   |   57 +-
 include/linux/cgroup.h                        |    2 +-
 include/linux/cgroup_rdma.h                   |   53 +
 include/linux/cgroup_subsys.h                 |    4 +
 include/linux/kernfs.h                        |   12 +-
 include/rdma/ib_verbs.h                       |   14 +
 init/Kconfig                                  |   10 +
 kernel/Makefile                               |    5 +-
 kernel/cgroup/Makefile                        |    6 +
 kernel/cgroup/cgroup-internal.h               |  214 +++
 kernel/cgroup/cgroup-v1.c                     | 1395 ++++++++++++++++
 kernel/{ => cgroup}/cgroup.c                  | 2165 ++++---------------------
 kernel/{ => cgroup}/cpuset.c                  |    0
 kernel/{cgroup_freezer.c => cgroup/freezer.c} |    0
 kernel/cgroup/namespace.c                     |  155 ++
 kernel/{cgroup_pids.c => cgroup/pids.c}       |    0
 kernel/cgroup/rdma.c                          |  619 +++++++
 kernel/events/core.c                          |    6 +
 tools/perf/util/cgroup.c                      |   26 +-
 30 files changed, 3306 insertions(+), 1940 deletions(-)
 create mode 100644 Documentation/cgroup-v1/rdma.txt
 create mode 100644 drivers/infiniband/core/cgroup.c
 create mode 100644 include/linux/cgroup_rdma.h
 create mode 100644 kernel/cgroup/Makefile
 create mode 100644 kernel/cgroup/cgroup-internal.h
 create mode 100644 kernel/cgroup/cgroup-v1.c
 rename kernel/{ => cgroup}/cgroup.c (72%)
 rename kernel/{ => cgroup}/cpuset.c (100%)
 rename kernel/{cgroup_freezer.c => cgroup/freezer.c} (100%)
 create mode 100644 kernel/cgroup/namespace.c
 rename kernel/{cgroup_pids.c => cgroup/pids.c} (100%)
 create mode 100644 kernel/cgroup/rdma.c

-- 
tejun
