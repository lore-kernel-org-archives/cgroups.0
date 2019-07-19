From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v9 0/8] sched/deadline: fix cpusets bandwidth accounting
Date: Fri, 19 Jul 2019 15:59:52 +0200
Message-ID: <20190719140000.31694-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org, tj@kernel.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, longman@redhat.com, dietmar.eggemann@arm.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

Hi,

v9 of a series of patches, originally authored by Mathieu, with the intent
of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
As originally reported by Steve [1], when hotplug and/or (certain)
cpuset reconfiguration operations take place, DEADLINE bandwidth
accounting information is lost since root domains are destroyed and
recreated.

Mathieu's approach is based on restoring bandwidth accounting info on
the newly created root domains by iterating through the (DEADLINE) tasks
belonging to the configured cpuset(s).

Apart from the usual rebase on top of cgroup/for-next, this version

 - make cpuset_{can,cancel}_attach grab cpuset_rwsem for write (5/8 - Peter)
 - moves v8 8/8 to 7/8 for bisectability (Peter)
 - adds comment in changelog regarding normalize_rt_tasks() (8/8 - Peter)

Set also available at

 https://github.com/jlelli/linux.git fixes/deadline/root-domain-accounting-v9

Thanks,

- Juri

[1] https://lkml.org/lkml/2016/2/3/966

Juri Lelli (6):
  cpuset: Rebuild root domain deadline accounting information
  sched/deadline: Fix bandwidth accounting at all levels after offline
    migration
  cgroup/cpuset: convert cpuset_mutex to percpu_rwsem
  cgroup/cpuset: Change cpuset_rwsem and hotplug lock order
  rcu/tree: Setschedule gp ktread to SCHED_FIFO outside of atomic region
  sched/core: Prevent race condition between cpuset and
    __sched_setscheduler()

Mathieu Poirier (2):
  sched/topology: Adding function partition_sched_domains_locked()
  sched/core: Streamlining calls to task_rq_unlock()

 include/linux/cgroup.h         |   1 +
 include/linux/cpuset.h         |  13 ++-
 include/linux/sched.h          |   5 +
 include/linux/sched/deadline.h |   8 ++
 include/linux/sched/topology.h |  10 ++
 kernel/cgroup/cgroup.c         |   2 +-
 kernel/cgroup/cpuset.c         | 163 +++++++++++++++++++++++++--------
 kernel/rcu/tree.c              |   6 +-
 kernel/sched/core.c            |  57 ++++++++----
 kernel/sched/deadline.c        |  63 +++++++++++++
 kernel/sched/sched.h           |   3 -
 kernel/sched/topology.c        |  30 +++++-
 12 files changed, 290 insertions(+), 71 deletions(-)

-- 
2.17.2

