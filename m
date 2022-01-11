From: Cruz Zhao <CruzZhao-KPsoFbNs7GizrGE5bRqYAgC/G2K4zDHf@public.gmane.org>
Subject: [PATCH v2 0/3] Accounting forced idle time per cpu and per cgroup
Date: Tue, 11 Jan 2022 17:55:58 +0800
Message-ID: <1641894961-9241-1-git-send-email-CruzZhao@linux.alibaba.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org, juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org, dietmar.eggemann-5wv7dgnIgG8@public.gmane.org, rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org, bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, mgorman-l3A5Bk7waGM@public.gmane.org, bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, joshdon-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

There are two types of forced idle time: forced idle time from cookie'd 
task and forced idle time form uncookie'd task. The forced idle time from
uncookie'd task is actually caused by the cookie'd task in runqueue
indirectly, and it's more accurate to measure the capacity loss with the
sum of both.

This patch set accounts forced idle time for each cpu to measure how long
the cpu is forced idle, which is displayed via via /proc/schedstat, and
also accounts for each cgroup to measure how long it forced its SMT siblings
into idle, which is displayed via /sys/fs/cgroup/cpuacct/cpuacct.forceidle
and /sys/fs/cgroup/cpuacct/cpuacct.forceidle_percpu. It is worth noting that
the forced idle time and the force idle time have different meanings.

We can get the total system forced idle time by looking at the root cgroup,
and we can get how long the cgroup forced it SMT siblings into idle. If the
force idle time of a cgroup is high, that can be rectified by making some
changes(ie. affinity, cpu budget, etc.) to the cgroup.

Cruz Zhao (3):
  sched/core: Accounting forceidle time for all tasks except idle task
  sched/core: Forced idle accounting per-cpu
  sched/core: Force idle accounting per cgroup

 include/linux/cgroup.h    |  7 +++++
 kernel/sched/core.c       | 10 ++++--
 kernel/sched/core_sched.c | 10 ++++--
 kernel/sched/cpuacct.c    | 79 +++++++++++++++++++++++++++++++++++++++++++++++
 kernel/sched/sched.h      |  4 +++
 kernel/sched/stats.c      | 17 ++++++++--
 6 files changed, 119 insertions(+), 8 deletions(-)

-- 
1.8.3.1

