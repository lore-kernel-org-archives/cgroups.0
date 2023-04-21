From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 0/5] cgroup: eliminate atomic rstat flushing
Date: Fri, 21 Apr 2023 17:40:15 +0000
Message-ID: <20230421174020.2994750-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1682098823; x=1684690823;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=PreKFJTa4Nhy/d8G1S1pWlqvl89TyRSt3luKcVUPmzw=;
        b=RbrkYV0CJdmfBIbmUIvZnVKhJQyLH4CYaft3mk2yfKLvyJZF8dDaaqVVnx3eiK4Ab7
         lZDDw30q1ppsBNzI772XXB/FRji5/R8TeuWfOOnXpJHy3+Y7JyutQQ2Gj19sY9tbj8iD
         l3vp+8XcixoSCatriNQ/fKYwuCkpY6rEOUk7vfFOeJNxNuSbxeoNvs3hSBNc92fiAIj4
         a4voAS83/3J7lvlMPpBscMu6mKr9RPsusaetGLt5BbQVCI9eFbxjUyZ5WoZ+y39zt/1d
         13legztw2c8S9smKxFGhZzKMk7rQhrAr+Y1NpiTukgQZJEDzm31H36UsudJPK7jznpxJ
         jqQw==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Alexander Viro <viro-RmSDqhL/yNMiFSDQTTA3OLVCufUGDwFn@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Jan Kara <jack-AlSwsSmVLrQ@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, linux-fsdevel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

A previous patch series ([1] currently in mm-stable) changed most
atomic rstat flushing contexts to become non-atomic. This was done to
avoid an expensive operation that scales with # cgroups and # cpus to
happen with irqs disabled and scheduling not permitted. There were two
remaining atomic flushing contexts after that series. This series tries
to eliminate them as well, eliminating atomic rstat flushing completely.

The two remaining atomic flushing contexts are:
(a) wb_over_bg_thresh()->mem_cgroup_wb_stats()
(b) mem_cgroup_threshold()->mem_cgroup_usage()

For (a), flushing needs to be atomic as wb_writeback() calls
wb_over_bg_thresh() with a spinlock held. However, it seems like the
call to wb_over_bg_thresh() doesn't need to be protected by that
spinlock, so this series proposes a refactoring that moves the call
outside the lock criticial section and makes the stats flushing
in mem_cgroup_wb_stats() non-atomic.

For (b), flushing needs to be atomic as mem_cgroup_threshold() is called
with irqs disabled. We only flush the stats when calculating the root
usage, as it is approximated as the sum of some memcg stats (file, anon,
and optionally swap) instead of the conventional page counter. This
series proposes changing this calculation to use the global stats
instead, eliminating the need for a memcg stat flush.

After these 2 contexts are eliminated, we no longer need
mem_cgroup_flush_stats_atomic() or cgroup_rstat_flush_atomic(). We can
remove them and simplify the code.

[1] https://lore.kernel.org/linux-mm/20230330191801.1967435-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

RFC -> v1:
- Collected R-b's and A-b's (Thanks everyone!).
- Rebased onto mm-stable.
- Cosmetic changes to commit logs.

RFC: https://lore.kernel.org/linux-mm/20230403220337.443510-1-yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org/

Yosry Ahmed (5):
  writeback: move wb_over_bg_thresh() call outside lock section
  memcg: flush stats non-atomically in mem_cgroup_wb_stats()
  memcg: calculate root usage from global state
  memcg: remove mem_cgroup_flush_stats_atomic()
  cgroup: remove cgroup_rstat_flush_atomic()

 fs/fs-writeback.c          | 16 +++++++----
 include/linux/cgroup.h     |  1 -
 include/linux/memcontrol.h |  5 ----
 kernel/cgroup/rstat.c      | 26 ++++--------------
 mm/memcontrol.c            | 54 ++++++++------------------------------
 5 files changed, 27 insertions(+), 75 deletions(-)

-- 
2.40.0.634.g4ca3ef3211-goog

