From: Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH v2 00/10] sched/psi: some optimization and extension
Date: Mon,  8 Aug 2022 19:03:31 +0800
Message-ID: <20220808110341.15799-1-zhouchengming@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20210112.gappssmtp.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ZuKaLhLa5tbyftaj2zqrE8vh2E3RCbHj+YPIfBePDGE=;
        b=JAQoR2JLXXcFnQ+8VpKRcSa7MZKg44EUwQQjW+f+SUR7Y8Few/TDsJ9Ogq4yvpQkwW
         8+B3YBQuZUiDJnBaB5UNAWggMNoZ5zgoDgeNyV5SWJhDp7xaX+a3KRoq2sdt5+pGHiJj
         J2lXpcXgMUPbB1AC9mG57fI+Sxg38YAQJhb1DOd5BCeB9F7C40I8dXP1YsPOmieLh+oC
         TSHR6XDNtwsjfy9f8dKalMpr+LlGpfkvb+jfGp7y1I7JyLeohHqLtXJ1fuyNgJ5n8XZR
         wOvzJ5RUbwKdSolOiqm1o2NHdMgOAtOgCOcdsIUM5E6c85XAzgaTHhj3kM8MH6J13fKI
         xeRA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, corbet-T1hC0tSOHrs@public.gmane.org, surenb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, Chengming Zhou <zhouchengming-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

Hi all,

This patch series are some optimization and extension for PSI, based on
the tip/sched/core branch.

patch 1/10 fix periodic aggregation shut off problem introduced by earlier
commit 4117cebf1a9f ("psi: Optimize task switch inside shared cgroups").

patch 2/10 optimize task switch inside shared cgroups when in_memstall status
of prev task and next task are different.

patch 3-4 optimize and simplify PSI status tracking by don't change task
psi_flags when migrate CPU/cgroup.

patch 7/10 remove NR_ONCPU task accounting to save 4 bytes in the first
cacheline to be used by the following patch 8/10, which introduce new
PSI resource PSI_IRQ to track IRQ/SOFTIRQ pressure stall information.

patch 9/10 introduce a per-cgroup interface "cgroup.psi" to disable
or re-enable PSI stats accounting in the cgroup level.

patch 10/10 cache parent psi_group in struct psi_group to speed up
the hot iteration path.

Thanks!

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
  sched/psi: optimize task switch inside shared cgroups again
  sched/psi: move private helpers to sched/stats.h
  sched/psi: don't change task psi_flags when migrate CPU/group
  sched/psi: don't create cgroup PSI files when psi_disabled
  sched/psi: save percpu memory when !psi_cgroups_enabled
  sched/psi: add PSI_IRQ to track IRQ/SOFTIRQ pressure
  sched/psi: per-cgroup PSI stats disable/re-enable interface
  sched/psi: cache parent psi_group to speed up groups iterate

Johannes Weiner (1):
  sched/psi: remove NR_ONCPU task accounting

 Documentation/admin-guide/cgroup-v2.rst |  13 ++
 include/linux/psi.h                     |   6 +-
 include/linux/psi_types.h               |  25 +--
 include/linux/sched.h                   |   3 -
 kernel/cgroup/cgroup.c                  |  73 +++++++
 kernel/sched/core.c                     |   2 +
 kernel/sched/psi.c                      | 247 +++++++++++++++++-------
 kernel/sched/stats.h                    |  60 +++---
 8 files changed, 313 insertions(+), 116 deletions(-)

-- 
2.36.1

