From: Shakeel Butt <shakeelb@google.com>
Subject: [PATCH v2 0/4] memcg: robust enforcement of memory.high
Date: Thu, 10 Feb 2022 22:49:13 -0800
Message-ID: <20220211064917.2028469-1-shakeelb@google.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=7cEUUMm8No+47SEC0UonhOqIuTdbXjwICtqwH1vHhoQ=;
        b=fb3bmiUsrp8W4YmAG3agpua6xnfwRewOZ8YA8GXSqnYAPC8zDIVx6AoedzrfSysYph
         zzvjaiNO751h5z4oCLk4zWH107SG09igxaI4HWBb1br4poFMySSL6hi1EE3b+DYhoSkr
         E8isZ/nwurJsTuixeh5zQ22wHMxuwcRqJYWTA+SlpVkjSTo1VKwRMe+ZUHsup7SwY5XP
         j0dXPMF/835VLYM3EhP1F/flECnKhOMqisNWuPeE9/Uo+X/0hqoGEnt+lp+mcMd8/d04
         p1R9iZ10rYSwdyqK3vsqBTfPZ8kYkC+5e/3cs9ufj47kI+7yPQufY7yIHZMwKB5NfcpC
         ioxA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@suse.com>, Roman Gushchin <guro@fb.com>
Cc: Chris Down <chris@chrisdown.name>, Andrew Morton <akpm@linux-foundation.org>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Shakeel Butt <shakeelb@google.com>

Due to the semantics of memory.high enforcement i.e. throttle the
workload without oom-kill, we are trying to use it for right sizing the
workloads in our production environment. However we observed the
mechanism fails for some specific applications which does big chunck of
allocations in a single syscall. The reason behind this failure is due
to the limitation of the memory.high enforcement's current
implementation. This patch series solves this issue by enforcing the
memory.high synchronously if the current process has accumulated a large
amount of high overcharge.

Changes since v1:
- Based on Roman's comment simply the sync enforcement and only target
  the extreme cases.

Shakeel Butt (4):
  memcg: refactor mem_cgroup_oom
  memcg: unify force charging conditions
  selftests: memcg: test high limit for single entry allocation
  memcg: synchronously enforce memory.high for large overcharges

 mm/memcontrol.c                               | 66 +++++++---------
 tools/testing/selftests/cgroup/cgroup_util.c  | 15 +++-
 tools/testing/selftests/cgroup/cgroup_util.h  |  1 +
 .../selftests/cgroup/test_memcontrol.c        | 78 +++++++++++++++++++
 4 files changed, 120 insertions(+), 40 deletions(-)

-- 
2.35.1.265.g69c8d7142f-goog

