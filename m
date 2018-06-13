From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v4 0/5] sched/deadline: fix cpusets bandwidth accounting
Date: Wed, 13 Jun 2018 14:17:06 +0200
Message-ID: <20180613121711.5018-1-juri.lelli@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org, mingo@redhat.com, rostedt@goodmis.org
Cc: linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, lizefan@huawei.com, cgroups@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>

Hi,

This is v4 of a series of patches, authored by Mathieu (thanks for your
work and for allowing me to try to move this forward), with the intent
of fixing a long standing issue of SCHED_DEADLINE bandwidth accounting.
As originally reported by Steve [1], when hotplug and/or (certain)
cpuset reconfiguration operations take place, DEADLINE bandwidth
accounting information is lost since root domains are destroyed and
recreated.

Mathieu's approach is based on restoring bandwidth accounting info on
the newly created root domains by iterating through the (DEADLINE) tasks
belonging to the configured cpuset(s).

v3 still had issues (IMHO) because __sched_setscheduler() might race
with the aforementioned restore operation (and it actually looks racy
with cpuset ops in general), but grabbing cpuset_mutex from potential
atomic contexs is a no-go.

I reworked v3 solution a bit ending-up with something that seems to be
working [2]. The idea is simply to trylock such mutex and return -EBUSY
to the user if we raced with cpuset ops. It's gross, but didn't find
anything better (and working) yet. :/

I also don't particularly like 05/05, as it introduces lot of DEADLINE-
iness into cpuset.c. I decided not to change Mathieu's patch for the
moment and see if better approaches are suggested (a per-class thing
maybe, even though other classes don't suffer from this problem and it
is so still going to be DEADLINE specific).

I also left out Mathieu's subsequent patches to focus on this crucial
fix. They can easily come later, IMHO.

Set also available at

 https://github.com/jlelli/linux.git fixes/deadline/root-domain-accounting-v4

Thanks,

- Juri

[1] https://lkml.org/lkml/2016/2/3/966
[2] compare -before (that confirms what Steve saw) with -after
    https://git.io/vhKfW

Mathieu Poirier (5):
  sched/topology: Add check to backup comment about hotplug lock
  sched/topology: Adding function partition_sched_domains_locked()
  sched/core: Streamlining calls to task_rq_unlock()
  sched/core: Prevent race condition between cpuset and
    __sched_setscheduler()
  cpuset: Rebuild root domain deadline accounting information

 include/linux/cpuset.h         |  6 ++++
 include/linux/sched.h          |  5 +++
 include/linux/sched/deadline.h |  8 +++++
 include/linux/sched/topology.h | 10 ++++++
 kernel/cgroup/cpuset.c         | 79 +++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c            | 38 ++++++++++++++------
 kernel/sched/deadline.c        | 31 +++++++++++++++++
 kernel/sched/sched.h           |  3 --
 kernel/sched/topology.c        | 32 ++++++++++++++---
 9 files changed, 193 insertions(+), 19 deletions(-)

-- 
2.14.3

