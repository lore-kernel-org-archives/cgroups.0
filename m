From: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH RFC 0/5] Virtual Memory Resource Controller for cgroups
Date: Thu, 3 Jul 2014 16:48:16 +0400
Message-ID: <cover.1404383187.git.vdavydov@parallels.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, "Kirill A. Shutemov" <kirill.shutemov-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Pavel Emelyanov <xemul-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Hi,

Typically, when a process calls mmap, it isn't given all the memory pages it
requested immediately. Instead, only its address space is grown, while the
memory pages will be actually allocated on the first use. If the system fails
to allocate a page, it will have no choice except invoking the OOM killer,
which may kill this or any other process. Obviously, it isn't the best way of
telling the user that the system is unable to handle his request. It would be
much better to fail mmap with ENOMEM instead.

That's why Linux has the memory overcommit control feature, which accounts and
limits VM size that may contribute to mem+swap, i.e. private writable mappings
and shared memory areas. However, currently it's only available system-wide,
and there's no way of avoiding OOM in cgroups.

This patch set is an attempt to fill the gap. It implements the resource
controller for cgroups that accounts and limits address space allocations that
may contribute to mem+swap.

The interface is similar to the one of the memory cgroup except it controls
virtual memory usage, not actual memory allocation:

  vm.usage_in_bytes            current vm usage of processes inside cgroup
                               (read-only)

  vm.max_usage_in_bytes        max vm.usage_in_bytes, can be reset by writing 0

  vm.limit_in_bytes            vm.usage_in_bytes must be <= vm.limite_in_bytes;
                               allocations that hit the limit will be failed
                               with ENOMEM

  vm.failcnt                   number of times the limit was hit, can be reset
                               by writing 0

In future, the controller can be easily extended to account for locked pages
and shmem.

Note, for the sake of simplicity, task migrations and mm->owner changes are not
handled yet. I'm planning to fix this in the next version if the need in this
cgroup is confirmed.

It isn't the first attempt to introduce VM accounting per cgroup. Several years
ago Balbir Singh almost pushed his memrlimit cgroup, but it was finally shelved
(see http://lwn.net/Articles/283287/). Balbir's cgroup has one principal
difference from the vm cgroup I'm presenting here: it limited the sum of
mm->total_vm of tasks inside a cgroup, i.e. it worked like an RLIMIT_AS, but
for the whole cgroup. IMO, it isn't very useful, because shared memory areas
are accounted more than once, which can lead to failing mmap even if there's
plenty of free memory and OOM is impossible.

Any comments are highly appreciated.

Thanks,

Vladimir Davydov (5):
  vm_cgroup: basic infrastructure
  vm_cgroup: private writable mappings accounting
  shmem: pass inode to shmem_acct_* methods
  vm_cgroup: shared memory accounting
  vm_cgroup: do not charge tasks in root cgroup

 include/linux/cgroup_subsys.h |    4 +
 include/linux/mm_types.h      |    3 +
 include/linux/shmem_fs.h      |    6 +
 include/linux/vm_cgroup.h     |   79 +++++++++++++
 init/Kconfig                  |    4 +
 kernel/fork.c                 |   12 +-
 mm/Makefile                   |    1 +
 mm/mmap.c                     |   43 ++++++--
 mm/mprotect.c                 |    8 +-
 mm/mremap.c                   |   15 ++-
 mm/shmem.c                    |   94 +++++++++++-----
 mm/vm_cgroup.c                |  244 +++++++++++++++++++++++++++++++++++++++++
 12 files changed, 471 insertions(+), 42 deletions(-)
 create mode 100644 include/linux/vm_cgroup.h
 create mode 100644 mm/vm_cgroup.c

-- 
1.7.10.4
