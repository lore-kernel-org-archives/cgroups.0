From: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 0/2] sched/isolation: Prep work for pcp cache draining isolation
Date: Sat,  4 Feb 2023 00:24:07 +0100
Message-ID: <20230203232409.163847-1-frederic@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675466656;
        bh=DPCD11U3iraVLwoI0ZmoNtXTwzpTxLUsmQXJIlJGVSE=;
        h=From:To:Cc:Subject:Date:From;
        b=iYsRI9WEJSXvQrf3WdnsJctWyoYSHpJ9XXhS6XfxCe9MFaOWmzH9nklIEiPNAFzk8
         pgm2UXKuqznGQ9qmSaKceq8HGb2NVkuTjU9EHO047NuRFGkIkK7AlwYph4NuaW6CQu
         Yfv4Tt5Kmfs5Ph+phIQd92418JDtLA37TmbbZntv5WKDNeGCmoA3lLPfpheDROYOBy
         lex84MWnpMjkDQaUxDAy4Gg9ssjU4vP/ZmUrpgKdpkwdhD6w39f63rijUzdbVrr8Su
         QF5e33ZTIhClNBvjwku0s/7M1KOLWbStucstrSvrrl6/K6UOTQnzktd7t6vVSWSsLw
         Wg9XHpLFpy0LA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Leonardo <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Thomas Gleixner <tglx-hfZtesqFncYOwBW4kG4KsQ@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org

For reference: https://lore.kernel.org/lkml/20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org/
And the latest proposal: https://lore.kernel.org/lkml/Y90mZQhW89HtYfT9-2MMpYkNvuYDjFM9bn6wA6Q@public.gmane.org/

Pcp cache draining isolation needs a function that abstracts checking
if a CPU is isolated through isolcpus= or nohz_full=. Take advantage
of that to do some cleanups.

Frederic Weisbecker (2):
  sched/isolation: Merge individual nohz_full features into a common
    housekeeping flag
  sched/isolation: Add cpu_is_isolated() API

 arch/x86/kvm/x86.c              |  2 +-
 drivers/char/random.c           |  2 +-
 drivers/pci/pci-driver.c        |  2 +-
 include/linux/sched/isolation.h | 13 +++++++------
 include/net/ip_vs.h             |  4 ++--
 kernel/cpu.c                    |  4 ++--
 kernel/kthread.c                |  4 ++--
 kernel/rcu/tasks.h              |  2 +-
 kernel/rcu/tree_plugin.h        |  6 +++---
 kernel/sched/core.c             | 12 ++++++------
 kernel/sched/fair.c             |  6 +++---
 kernel/sched/isolation.c        | 22 ++++++----------------
 kernel/watchdog.c               |  2 +-
 kernel/workqueue.c              |  2 +-
 net/core/net-sysfs.c            |  2 +-
 net/netfilter/ipvs/ip_vs_ctl.c  |  2 +-
 16 files changed, 39 insertions(+), 48 deletions(-)

-- 
2.34.1

