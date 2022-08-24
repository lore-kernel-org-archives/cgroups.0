From: Chengming Zhou <zhouchengming@bytedance.com>
Subject: [PATCH v3 00/10] sched/psi: some optimization and extension
Date: Wed, 24 Aug 2022 16:18:19 +0800
Message-ID: <20220824081829.33748-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc;
        bh=sIwNmqerjqaiTdP/9SuVUBFcXcyvJnbToq4VHqojaB8=;
        b=Om+ippFq5VDjfampfj8skRptXpd8NK2EmMp93WkO1WFM2P+9cmvM50W9OIQ8PYKZ3Z
         V7YaOExX88F5cnsKw+Yx6nnJ1spX+YL2qWPVeXJyCeECldNQm/Yy9dajP8ZBfunV0mZT
         VKAK8TXVEQs6Bso6BAxV40s72baz1S0t1fRI77xf4iTajYadAHra4Z6LEo6mexc/KEVH
         TZ7EcwSaIQtHsiCvDWxTC6jHbBxc8LbvGRrhqGsgCDqPIHrTyUhZpFm2DX48W6DSAFxL
         NsRG6zAsn4cyfoRZjvWKOHogMQwNFHla7+6OrD+EXHdzhEuSDeoOqq+igUU8PuC2KTTV
         SmgA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj@kernel.org, hannes@cmpxchg.org, mkoutny@suse.com, surenb@google.com
Cc: gregkh@linuxfoundation.org, corbet@lwn.net, mingo@redhat.com, peterz@infradead.org, songmuchun@bytedance.com, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org, Chengming Zhou <zhouchengming@bytedance.com>

Hi all,

This patch series are some optimizations and extensions for PSI.

patch 1/10 fix periodic aggregation shut off problem introduced by earlier
commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups").

patch 2-4 are some misc optimizations, so put them in front of this series.

patch 5/10 optimize task switch inside shared cgroups when in_memstall status
of prev task and next task are different.

patch 6/10 remove NR_ONCPU task accounting to save 4 bytes in the first
cacheline to be used by the following patch 7/10, which introduce new
PSI resource PSI_IRQ to track IRQ/SOFTIRQ pressure stall information.

patch 8-9 cache parent psi_group in struct psi_group to speed up
the hot iteration path.

patch 10/10 introduce a per-cgroup interface "cgroup.pressure" to disable
or re-enable PSI in the cgroup level, and we implement hiding and unhiding
the pressure files per Tejun's suggestion[1], which depends on his work[2].

[1] https://lore.kernel.org/all/YvqjhqJQi2J8RG3X@slm.duckdns.org/
[2] https://lore.kernel.org/all/20220820000550.367085-1-tj@kernel.org/

Performance test using mmtests/config-scheduler-perfpipe in /user.slice/user-0.slice/session-4.scope

                                 next                patched       patched/only-leaf
Min       Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 (   9.32%)
1st-qrtle Time        8.90 (   0.00%)        8.58 (   3.63%)        8.05 (   9.58%)
2nd-qrtle Time        8.94 (   0.00%)        8.61 (   3.65%)        8.09 (   9.50%)
3rd-qrtle Time        8.99 (   0.00%)        8.65 (   3.75%)        8.15 (   9.35%)
Max-1     Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 (   9.32%)
Max-5     Time        8.82 (   0.00%)        8.49 (   3.74%)        8.00 (   9.32%)
Max-10    Time        8.84 (   0.00%)        8.55 (   3.20%)        8.04 (   9.05%)
Max-90    Time        9.04 (   0.00%)        8.67 (   4.10%)        8.18 (   9.51%)
Max-95    Time        9.04 (   0.00%)        8.68 (   4.03%)        8.20 (   9.26%)
Max-99    Time        9.07 (   0.00%)        8.73 (   3.82%)        8.25 (   9.11%)
Max       Time        9.12 (   0.00%)        8.89 (   2.54%)        8.27 (   9.29%)
Amean     Time        8.95 (   0.00%)        8.62 *   3.67%*        8.11 *   9.43%*

Thanks!

Changes in v3:
 - Rebase on linux-next and reorder patches to put misc optimizations
   patches in the front of this series.
 - Drop patch "sched/psi: don't change task psi_flags when migrate CPU/group"
   since it caused a little performance regression and it's just
   code refactoring, so drop it.
 - Don't define PSI_IRQ and PSI_IRQ_FULL when !CONFIG_IRQ_TIME_ACCOUNTING,
   in which case they are not used.
 - Add patch 8/10 "sched/psi: consolidate cgroup_psi()" make cgroup_psi()
   can handle all cgroups including root cgroup, make patch 9/10 simpler.
 - Rename interface to "cgroup.pressure" and add some explanation
   per Michal's suggestion.
 - Hide and unhide pressure files when disable/re-enable cgroup PSI,
   depends on Tejun's work.

Changes in v2:
 - Add Acked-by tags from Johannes Weiner. Thanks for review!
 - Fix periodic aggregation wakeup for common ancestors in
   psi_task_switch().
 - Add patch 7/10 from Johannes Weiner, which remove NR_ONCPU
   task accounting to save 4 bytes in the first cacheline.
 - Remove "psi_irq=" kernel cmdline parameter in last version.
 - Add per-cgroup interface "cgroup.psi" to disable/re-enable
   PSI stats accounting in the cgroup level.

Chengming Zhou (9):
  sched/psi: fix periodic aggregation shut off
  sched/psi: don't create cgroup PSI files when psi_disabled
  sched/psi: save percpu memory when !psi_cgroups_enabled
  sched/psi: move private helpers to sched/stats.h
  sched/psi: optimize task switch inside shared cgroups again
  sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
  sched/psi: consolidate cgroup_psi()
  sched/psi: cache parent psi_group to speed up groups iterate
  sched/psi: per-cgroup PSI accounting disable/re-enable interface

Johannes Weiner (1):
  sched/psi: remove NR_ONCPU task accounting

 Documentation/admin-guide/cgroup-v2.rst |  23 +++
 include/linux/cgroup-defs.h             |   3 +
 include/linux/cgroup.h                  |   5 -
 include/linux/psi.h                     |  12 +-
 include/linux/psi_types.h               |  29 ++-
 kernel/cgroup/cgroup.c                  |  94 ++++++++-
 kernel/sched/core.c                     |   1 +
 kernel/sched/psi.c                      | 256 +++++++++++++++++-------
 kernel/sched/stats.h                    |   6 +
 9 files changed, 338 insertions(+), 91 deletions(-)

-- 
2.37.2

