From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [patch 0/7] mm: memcg fixlets for 3.3 v2
Date: Tue, 29 Nov 2011 11:51:58 +0100
Message-ID: <1322563925-1667-1-git-send-email-hannes@cmpxchg.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Rientjes <rientjes-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Version 2:
o dropped the non-atomic bitops against pc->flags (Hugh et al)
o added VM_BUG_ONs where page sanity checks were removed (Kame)
o made the page_cgroup array checks in lookup_page_cgroup()
  depend on CONFIG_DEBUG_VM, like the only caller that needs 'em
o added ack tags

 include/linux/memcontrol.h |   16 ++++----
 include/linux/oom.h        |    2 +-
 include/linux/rmap.h       |    4 +-
 mm/memcontrol.c            |   96 ++++++++++++++++++--------------------------
 mm/oom_kill.c              |   42 ++++++++++----------
 mm/page_cgroup.c           |   18 +++++++-
 mm/rmap.c                  |   20 +++++-----
 mm/swapfile.c              |    9 ++--
 mm/vmscan.c                |   12 +++---
 9 files changed, 108 insertions(+), 111 deletions(-)

--
To unsubscribe from this list: send the line "unsubscribe cgroups" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
