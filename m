From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/5] mm: memcontrol: eliminate charge reparenting v2
Date: Tue, 14 Oct 2014 12:20:32 -0400
Message-ID: <1413303637-23862-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Vladimir Davydov <vdavydov-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hi,

this series gets rid of charge reparenting at cgroup deletion, which
is possible now that the css can outlive the user-visible cgroup.  Any
cache charges left after cgroup deletion simply remain with their css,
where they continue to get reclaimed during pressure on the parent.

Version 2:

    - remove memcg->dead_count [vladimir]
    - restore iterator generations [vladimir]
    - restore memcg-initialized test [michal]
    - document shared walk lockless magic [michal]
    - split out sync stock draining removal [michal]

 include/linux/cgroup.h          |  26 ++
 include/linux/page_counter.h    |   4 +-
 include/linux/percpu-refcount.h |  47 ++-
 mm/memcontrol.c                 | 593 ++++++--------------------------------
 mm/page_counter.c               |  23 +-
 5 files changed, 163 insertions(+), 530 deletions(-)
