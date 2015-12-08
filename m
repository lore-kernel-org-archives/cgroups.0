From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 0/8] mm: memcontrol: account "kmem" in cgroup2
Date: Tue,  8 Dec 2015 13:34:17 -0500
Message-ID: <1449599665-18047-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Hi,

this series adds accounting of the historical "kmem" memory consumers
to the cgroup2 memory controller.

These consumers include the dentry cache, the inode cache, kernel
stack pages, and a few others that are pointed out in patch 7/8. The
footprint of these consumers is directly tied to userspace activity in
common workloads, and so they have to be part of the minimally viable
configuration in order to present a complete feature to our users.

The cgroup2 interface of the memory controller is far from complete,
but this series, along with the socket memory accounting series,
provides the final semantic changes for the existing memory knobs in
the cgroup2 interface, which is scheduled for initial release in the
next merge window.

Thanks!

 include/linux/list_lru.h     |   4 +-
 include/linux/memcontrol.h   | 330 +++++++++++++++++++++--------------------
 include/linux/sched.h        |   2 -
 include/linux/slab.h         |   2 +-
 include/linux/slab_def.h     |   3 +-
 include/linux/slub_def.h     |   2 +-
 include/net/tcp_memcontrol.h |   3 +-
 init/Kconfig                 |  10 +-
 mm/list_lru.c                |  12 +-
 mm/memcontrol.c              | 246 ++++++++++++++----------------
 mm/slab.h                    |   6 +-
 mm/slab_common.c             |  14 +-
 mm/slub.c                    |  10 +-
 mm/vmscan.c                  |   2 +-
 net/ipv4/Makefile            |   2 +-
 net/ipv4/tcp_memcontrol.c    |   2 +-
 16 files changed, 319 insertions(+), 331 deletions(-)
