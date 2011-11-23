From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/8] mm: memcg fixlets for 3.3
Date: Wed, 23 Nov 2011 16:42:23 +0100
Message-ID: <1322062951-1756-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Here are some minor memcg-related cleanups and optimizations, nothing
too exciting.  The bulk of the diffstat comes from renaming the
remaining variables to describe a (struct mem_cgroup *) to "memcg".
The rest cuts down on the (un)charge fastpaths, as people start to get
annoyed by those functions showing up in the profiles of their their
non-memcg workloads.  More is to come, but I wanted to get the more
obvious bits out of the way.

 include/linux/memcontrol.h  |   16 ++++----
 include/linux/oom.h         |    2 +-
 include/linux/page_cgroup.h |   20 ++++++---
 include/linux/rmap.h        |    4 +-
 mm/memcontrol.c             |   97 ++++++++++++++++---------------------------
 mm/oom_kill.c               |   42 +++++++++---------
 mm/rmap.c                   |   20 ++++----
 mm/swapfile.c               |    9 ++--
 mm/vmscan.c                 |   12 +++---
 9 files changed, 103 insertions(+), 119 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
