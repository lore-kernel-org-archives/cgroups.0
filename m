From: Glauber Costa <glommer@parallels.com>
Subject: [PATCH v5 00/11] per-cgroup cpu-stat
Date: Wed,  9 Jan 2013 15:45:27 +0400
Message-ID: <1357731938-8417-1-git-send-email-glommer@parallels.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>, Tejun Heo <tj@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>

[ update: I thought I posted this already before leaving for holidays. However,
  now that I am checking for replies, I can't find nor replies nor the original
  mail in my boxes or archives. I am posting again for safety sake, but sorry
  you are getting this twice by any chance ]

Hi all,

This is an attempt to provide userspace with enough information to reconstruct
per-container version of files like "/proc/stat". In particular, we are
interested in knowing the per-cgroup slices of user time, system time, wait
time, number of processes, and a variety of statistics.

This task is made more complicated by the fact that multiple controllers are
involved in collecting those statistics: cpu and cpuacct. So the first thing I
am doing here, is ressurecting Tejun's patches that aim at deprecating cpuacct.

This is one of the major differences from earlier attempts: all data is provided
by the cpu controller, resulting in greater simplicity.

This also tries to hook into the existing scheduler hierarchy walks instead of
providing new ones.

Glauber Costa (7):
  don't call cpuacct_charge in stop_task.c
  sched: adjust exec_clock to use it as cpu usage metric
  cpuacct: don't actually do anything.
  account guest time per-cgroup as well.
  record per-cgroup number of context switches
  sched: change nr_context_switches calculation.
  sched: introduce cgroup file stat_percpu

Peter Zijlstra (1):
  sched: Push put_prev_task() into pick_next_task()

Tejun Heo (3):
  cgroup: implement CFTYPE_NO_PREFIX
  cgroup, sched: let cpu serve the same files as cpuacct
  cgroup, sched: deprecate cpuacct

 include/linux/cgroup.h   |   1 +
 include/linux/sched.h    |   8 +-
 init/Kconfig             |  11 +-
 kernel/cgroup.c          |  57 ++++++-
 kernel/sched/core.c      | 375 +++++++++++++++++++++++++++++++++++++++++++++--
 kernel/sched/cputime.c   |  28 +++-
 kernel/sched/fair.c      |  38 ++++-
 kernel/sched/idle_task.c |   9 +-
 kernel/sched/rt.c        |  42 ++++--
 kernel/sched/sched.h     |  18 ++-
 kernel/sched/stop_task.c |   8 +-
 11 files changed, 551 insertions(+), 44 deletions(-)

-- 
1.7.11.7
