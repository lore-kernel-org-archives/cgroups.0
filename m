From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v7 0/7]  sched/deadline: fix cpusets bandwidth accounting
Date: Wed,  3 Apr 2019 10:46:43 +0200
Message-ID: <20190403084650.4414-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

Hi,

v7 of a series of patches, originally authored by Mathieu, with the intent
of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
As originally reported by Steve [1], when hotplug and/or (certain)
cpuset reconfiguration operations take place, DEADLINE bandwidth
accounting information is lost since root domains are destroyed and
recreated.

Mathieu's approach is based on restoring bandwidth accounting info on
the newly created root domains by iterating through the (DEADLINE) tasks
belonging to the configured cpuset(s).

Apart from the usual rebase on top of cgroup/for-next, changes worth of
notice are:

 - commented about potential problems w.r.t. userspace operations that
   grabs callback_lock (03/07 - peterz)
 - take cpuset_read_only_lock() before rq an pi locks, as to not
   introduce a dependency between the former and the latters; on !CONFIG_
   CPUSET cpuset_read_only(un)lock() (dis/en)ables irqs and preemption
   (04/07 - peterz)
 - make dl_add_task_root_domain() use !_irqsave (un)lock functions
 - also use __dl_add() to update root domain total_bw
 - 06/07 new patch; seq_show operations can be guarded by cpuset_mutex
   (peterz)
 - 07/07 new patch; deals with offline migrations (noticed the problem
   while testing)

Set also available at

 https://github.com/jlelli/linux.git fixes/deadline/root-domain-accounting-v7

Thanks,

- Juri

[1] https://lkml.org/lkml/2016/2/3/966

Juri Lelli (5):
  cgroup/cpuset: make callback_lock raw
  sched/core: Prevent race condition between cpuset and
    __sched_setscheduler()
  cpuset: Rebuild root domain deadline accounting information
  cgroup/cpuset: Use cpuset_mutex to protect seq_show operations
  sched/deadline: Fix bandwidth accounting at all levels after offline
    migration

Mathieu Poirier (2):
  sched/topology: Adding function partition_sched_domains_locked()
  sched/core: Streamlining calls to task_rq_unlock()

 include/linux/cgroup.h         |   1 +
 include/linux/cpuset.h         |  14 +++
 include/linux/sched.h          |   5 +
 include/linux/sched/deadline.h |   8 ++
 include/linux/sched/topology.h |  10 ++
 kernel/cgroup/cgroup.c         |   2 +-
 kernel/cgroup/cpuset.c         | 161 +++++++++++++++++++++++++--------
 kernel/sched/core.c            |  49 +++++++---
 kernel/sched/deadline.c        |  63 +++++++++++++
 kernel/sched/sched.h           |   3 -
 kernel/sched/topology.c        |  30 +++++-
 11 files changed, 286 insertions(+), 60 deletions(-)

-- 
2.17.2

