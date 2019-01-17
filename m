From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v6 0/5] sched/deadline: fix cpusets bandwidth accounting
Date: Thu, 17 Jan 2019 09:47:34 +0100
Message-ID: <20190117084739.17078-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

Hi,

v6 of a series of patches, originally authored by Mathieu, with the intent
of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
As originally reported by Steve [1], when hotplug and/or (certain)
cpuset reconfiguration operations take place, DEADLINE bandwidth
accounting information is lost since root domains are destroyed and
recreated.

Mathieu's approach is based on restoring bandwidth accounting info on
the newly created root domains by iterating through the (DEADLINE) tasks
belonging to the configured cpuset(s).

Apart from some minor refactoring needed to rebase the set on top of
Waiman Long's cpuset for cgroup series (now mainline), two changes worth
of notice:

 - added some more descriptive comments about why callback_lock gives
   the holder read-only access to cpusets [Steve] 04/05
 - call cgroup_enable_task_cg_list if we need to traverse the list of
   tasks belonging to a particular cgroup (to rebuild its bandwidth),
   but such list is not yet ready (this can for example happen if CPUs
   are hotplugged during early boot stages) 05/05

Set also available at

 https://github.com/jlelli/linux.git fixes/deadline/root-domain-accounting-v6

Thanks,

- Juri

[1] https://lkml.org/lkml/2016/2/3/966

Juri Lelli (1):
  cgroup/cpuset: make callback_lock raw

Mathieu Poirier (4):
  sched/topology: Adding function partition_sched_domains_locked()
  sched/core: Streamlining calls to task_rq_unlock()
  sched/core: Prevent race condition between cpuset and
    __sched_setscheduler()
  cpuset: Rebuild root domain deadline accounting information

 include/linux/cgroup.h         |   1 +
 include/linux/cpuset.h         |   6 ++
 include/linux/sched.h          |   5 ++
 include/linux/sched/deadline.h |   8 ++
 include/linux/sched/topology.h |  10 +++
 kernel/cgroup/cgroup.c         |   2 +-
 kernel/cgroup/cpuset.c         | 159 +++++++++++++++++++++++++--------
 kernel/sched/core.c            |  34 ++++---
 kernel/sched/deadline.c        |  31 +++++++
 kernel/sched/sched.h           |   3 -
 kernel/sched/topology.c        |  32 +++++--
 11 files changed, 234 insertions(+), 57 deletions(-)

-- 
2.17.2

