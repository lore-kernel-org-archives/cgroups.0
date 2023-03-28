From: Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 0/9] memcg: make rstat flushing irq and sleep
Date: Tue, 28 Mar 2023 22:16:35 +0000
Message-ID: <20230328221644.803272-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1680041811;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=cwQWCEo9ePRYrBfd54RTGHI4ReD6zTB2CQA9ky8D7Xo=;
        b=ckuVrFZpRMbKkYaT641zugwGgqS/ki1HcHRGVRwRjkqbpYmJn53n3BJxlm4PtefNMZ
         V7Lx0t0VCx9xJbkbk0054d9U/+6MMsQejk2NSwnt5D35xCm5Hq5pZm5SJK5CIZfjCnht
         V0pY409txNDdSi4+78Xf8fYrfgteKRSatE0Yv5rBDd+5j6WpeDHZJpDO5IiqBfLgwy3G
         9G3wSwe0z1jWNeULV+cFUkJOWs1knwD7pW4WcXwfaanarWpk2Ozk+fACPDNx1NcCWRdH
         tAvDGN/2QSuKylRwD/br3VcJA7SF9Tuz8RLoH1VBIr+l7Bie6Py+vND+8JOUEY43Ncvz
         wX4Q==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>
Cc: Vasily Averin <vasily.averin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, bpf-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yosry Ahmed <yosryahmed-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>

Patches 1 and 2 are cleanups requested during reviews of prior versions
of this series.

Patch 3 makes sure we never try to flush from within an irq context, and
patch 4 adds a WARN_ON_ONCE() to make sure we catch any violations.

Patches 5 to 8 introduce separate variants of mem_cgroup_flush_stats()
for atomic and non-atomic flushing, and make sure we only flush the
stats atomically when necessary.

Patch 9 is a slightly tangential optimization that limits the work done
by rstat flushing in some scenarios.

v1 -> v2:
- Added more context in patch 4's commit log.
- Added atomic_read() before atomic_xchg() in patch 5 to avoid
  needlessly locking the cache line (Shakeel).
- Refactored patch 6: added a common helper, do_flush_stats(), for
  mem_cgroup_flush_stats{_atomic}() (Johannes).
- Renamed mem_cgroup_flush_stats_ratelimited() to
  mem_cgroup_flush_stats_atomic_ratelimited() in patch 6. It is restored
  in patch 7, but this maintains consistency (Johannes).
- Added line break to keep the lock section visually separated in patch
  7 (Johannes).

RFC -> v1:
- Dropped patch 1 that attempted to make the global rstat lock a non-irq
  lock, will follow up on that separetly (Shakeel).
- Dropped stats_flush_lock entirely, replaced by an atomic (Johannes).
- Renamed cgroup_rstat_flush_irqsafe() to cgroup_rstat_flush_atomic()
  instead of removing it (Johannes).
- Added a patch to rename mem_cgroup_flush_stats_delayed() to
  mem_cgroup_flush_stats_ratelimited() (Johannes).
- Separate APIs for flushing memcg stats in atomic and non-atomic
  contexts instead of a boolean argument (Johannes).
- Added patches 3 & 4 to make sure we never flush from irq context
  (Shakeel & Johannes).

Yosry Ahmed (9):
  cgroup: rename cgroup_rstat_flush_"irqsafe" to "atomic"
  memcg: rename mem_cgroup_flush_stats_"delayed" to "ratelimited"
  memcg: do not flush stats in irq context
  cgroup: rstat: add WARN_ON_ONCE() if flushing outside task context
  memcg: replace stats_flush_lock with an atomic
  memcg: sleep during flushing stats in safe contexts
  workingset: memcg: sleep when flushing stats in workingset_refault()
  vmscan: memcg: sleep when flushing stats during reclaim
  memcg: do not modify rstat tree for zero updates

 include/linux/cgroup.h     |  2 +-
 include/linux/memcontrol.h |  9 ++++-
 kernel/cgroup/rstat.c      |  6 ++-
 mm/memcontrol.c            | 78 ++++++++++++++++++++++++++++++--------
 mm/workingset.c            |  5 ++-
 5 files changed, 78 insertions(+), 22 deletions(-)

-- 
2.40.0.348.gf938b09366-goog

