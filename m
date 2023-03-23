From: Yosry Ahmed <yosryahmed@google.com>
Subject: [RFC PATCH 0/7] Make rstat flushing IRQ and sleep friendly
Date: Thu, 23 Mar 2023 04:00:30 +0000
Message-ID: <20230323040037.2389095-1-yosryahmed@google.com>
Mime-Version: 1.0
Return-path: <bpf-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112; t=1679544041;
        h=cc:to:from:subject:message-id:mime-version:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=dQm6vY6azaIWfVBk9OleqJiypEWxonUrfDuxGdzwvEo=;
        b=Wqjo2gOwLuBNwjRWcqy/e97mtEalxuitp0xY/9ucFAeoVjzZqkLFNj+Kg/bS7+SLso
         0mEqszCZOwticCjD28rnJun5qYG8zLpCe7Lgqr1Zcq77xAINPLQkmlCr1RUZ3ZFrFZLe
         yVSSzSX2DRXw2LGgoiHCS2XSksG6+AorfME/vlcB+xENetBawM2tXFoeFxzlxQ+CDzRr
         rABuT5MXEbil4k21Tw2rj0lLKNuTBpVjCslzrHFHpTW3cYQbR83DpY9L8+R2A0wlBskB
         V7890htQHHBp7dpJzFMQR7ATN69oyvzWl1Z0FZ3aHCz1QscoKhEDDw6wgjhuKwrEdKtk
         wggQ==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj@kernel.org>, Josef Bacik <josef@toxicpanda.com>, Jens Axboe <axboe@kernel.dk>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Roman Gushchin <roman.gushchin@linux.dev>, Shakeel Butt <shakeelb@google.com>, Muchun Song <muchun.song@linux.dev>, Andrew Morton <akpm@linux-foundation.org>
Cc: Vasily Averin <vasily.averin@linux.dev>, cgroups@vger.kernel.org, linux-block@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org, bpf@vger.kernel.org, Yosry Ahmed <yosryahmed@google.com>

Currently, if rstat flushing is invoked using the irqsafe variant
cgroup_rstat_flush_irqsafe(), we keep interrupts disabled and do not
sleep for the entire flush operation, which is O(# cpus * # cgroups).
This can be rather dangerous.

Not all contexts that use cgroup_rstat_flush_irqsafe() actually cannot
sleep, and among those that cannot sleep, not all contexts require
interrupts to be disabled. This patch series breaks down the
O(# cpus * # cgroups) duration that we disable interrupts for into a
series of O(# cgroups) durations. Disabling interrupts is deferred to
the caller if needed.

Patch 1 mainly addresses this by not requiring interrupts to be
disabled for the global rstat lock to be acquired. As a side effect of
that, the we disable rstat flushing in interrupt context. See patch 1
for more details.

One thing I am not sure about is whether the only caller of
cgroup_rstat_flush_hold() -- cgroup_base_stat_cputime_show(),
currently has any dependency on that call disabling interrupts.

Patch 2 follows suit for stats_flush_lock in the memcg code, allowing it
to be acquired without disabling interrupts.

Patch 3 removes cgroup_rstat_flush_irqsafe() and updates
cgroup_rstat_flush() to be more explicit about sleeping.

Patch 4 changes memcg code paths that invoke rstat flushing to sleep
where possible. The patch changes code paths where it is naturally saef
to sleep: userspace reads and the background periodic flusher.

Patches 5 & 6 allow sleeping while rstat flushing in reclaim context and
refault context. I am not sure if this is okay, especially the latter,
so I placed them in separate patches for ease of revert/drop.

Patch 7 is a slightly tangential optimization that limits the work done
by rstat flushing in some scenarios.

Yosry Ahmed (7):
  cgroup: rstat: only disable interrupts for the percpu lock
  memcg: do not disable interrupts when holding stats_flush_lock
  cgroup: rstat: remove cgroup_rstat_flush_irqsafe()
  memcg: sleep during flushing stats in safe contexts
  vmscan: memcg: sleep when flushing stats during reclaim
  workingset: memcg: sleep when flushing stats in workingset_refault()
  memcg: do not modify rstat tree for zero updates

 block/blk-cgroup.c         |  2 +-
 include/linux/cgroup.h     |  3 +--
 include/linux/memcontrol.h |  8 +++---
 kernel/cgroup/cgroup.c     |  4 +--
 kernel/cgroup/rstat.c      | 54 ++++++++++++++++++++------------------
 mm/memcontrol.c            | 52 ++++++++++++++++++++++--------------
 mm/vmscan.c                |  2 +-
 mm/workingset.c            |  4 +--
 8 files changed, 73 insertions(+), 56 deletions(-)

-- 
2.40.0.rc1.284.g88254d51c5-goog

