From: <xiaoggchen@tencent.com>
Subject: [PATCH 0/5] BT scheduling class
Date: Fri, 21 Jun 2019 15:45:52 +0800
Message-ID: <1561103157-11246-1-git-send-email-xiaoggchen@tencent.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: jasperwang@tencent.com, heddchen@tencent.com
Cc: mingo@redhat.com, peterz@infradead.org, linux-kernel@vger.kernel.org, tj@kernel.org, lizefan@huawei.com, hannes@cmpxchg.org, cgroups@vger.kernel.org, chen xiaoguang <xiaoggchen@tencent.com>

From: chen xiaoguang <xiaoggchen@tencent.com>

This patch set introduces a new scheduler, we name it BT scheduler
for the moment.

First let me introduce the background why we add a new scheduler.

We have two scenarios in our business:

Scenario 1:
Server application need to response to 10 million requests in one minute
and we must achieve to at least 99.99% successful response to the requests
to keep user experience.

First only server application exists in the system and the success
rate is 99.998% and the average cpu use is only 25%.
To improve the cpu use we run some other applications which are not time
critical tasks in the system. Cgroup's share mechanism is used to restrict
the cpu usage for these kinds of tasks. But there are nearly 5000 requests
in one minute that cannot be handled in time by the server and the success
rate is only 99.94%. Then the BT scheduler is used for the other
applications. After test we found that at most 400 requests failed in one
minute and the success rate are 99.996%. The cpu use increased to 70%.

Test results:
------------------------------------------------------------------------
                     | failure counts/m |success rate  |cpu utilization|
------------------------------------------------------------------------
server load(CFS)     | 200              | 99.998%      | 25%           |
------------------------------------------------------------------------
server load(CFS +    | 5000             | 99.95%       | 55%           |
cgroup.shares=65536) |                  |              |               |
other load(CFS +     |                  |              |               |
cgroup.shares=2)     |                  |              |               |
------------------------------------------------------------------------
server load(CFS)     | 200-400          | 99.996%      | 70%           |
other load(BT)       |                  |              |               |
------------------------------------------------------------------------

Scenario 2:
A service program receives 2000 requests per minute and the average latency
per request is 115 milliseconds. Then we add some other tasks into the
system to share the cpu with the service program. While the other tasks use
the CFS scheduler the average latency increased to 138 milliseconds.
Also dozens of failures increased at the same time.
A server program usually depends on several modules which depend on
additional other modules and so on. So if the latency increased several
milliseconds for one module then the whole latency for the service program
will be amplified times.

Then we use the BT scheduler for the other tasks the average latency
is 122 milliseconds but the failures keep the same. 

Test results:
-----------------------------------------------------------------------
                    | failure counts/m | AVG latency(milliseconds)    |
-----------------------------------------------------------------------
server load(CFS)    |                  | 115                          |
-----------------------------------------------------------------------
server load(CFS)+   | increase 30-50   | 138                          |
other load(CFS)     |                  |                              |
-----------------------------------------------------------------------
server load(CFS)+   | no change        | 122                          |
other load(BT)      |                  |                              |
-----------------------------------------------------------------------

From the above two cases we know that tasks with BT scheduler will not
interfere the normal tasks and will run in cpu spare time. It can be
preempted by normal tasks on demand.

We have millions of servers in our company, so it is very important for
us to improve the cpu use to reduce the costs.

The goal of BT scheduler is to improve the cpu use while do not interfere
the normal tasks.

BT is the abbreviation of batch and we will change the name when we find
a more suitable word.

Tasks with BT schedule class are usually cpu-bound and run in background
and will be preempted by normal tasks such as tasks with CFS schedule class
at any time.

This patch set is just the basic schedule class of BT scheduler.
We will send the complete patches after we finish the full test.

The BT scheduler is similar with the CFS scheduler. We also use the
rb-tree as the run queue to save the runnable tasks. And the vruntime 
concept is also used in the BT scheduler. And the priority of BT scheduler
is from 140 to 179. So now the schedulers in the kernel are as follows:
deadline, RT, CFS, BT and idle.

We can restrict the usage percent of tasks with BT scheduler in per cpu
granularity. We also optimized the load balance algorithm by taking 
cpu's ability of running BT tasks and the waiting times in the run
queue of BT tasks into account. We also add cgroup support for BT
scheduling class.

chen xiaoguang (5):
  sched/BT: add BT scheduling entity
  sched/BT: implement the BT scheduling class
  sched/BT: extend the priority for BT scheduling class
  sched/BT: account the cpu time for BT scheduling class
  sched/BT: add debug information for BT scheduling class

 fs/proc/base.c                 |    3 +-
 include/linux/ioprio.h         |    2 +-
 include/linux/sched.h          |   18 +
 include/linux/sched/bt.h       |   30 ++
 include/linux/sched/prio.h     |    5 +-
 include/uapi/linux/sched.h     |    1 +
 init/init_task.c               |    6 +-
 kernel/delayacct.c             |    2 +-
 kernel/exit.c                  |    3 +-
 kernel/sched/Makefile          |    2 +-
 kernel/sched/bt.c              | 1040 ++++++++++++++++++++++++++++++++++++++++
 kernel/sched/core.c            |   55 ++-
 kernel/sched/cputime.c         |   33 +-
 kernel/sched/debug.c           |   37 ++
 kernel/sched/fair.c            |   31 +-
 kernel/sched/loadavg.c         |    5 +-
 kernel/sched/sched.h           |   40 ++
 kernel/time/posix-cpu-timers.c |    2 +-
 18 files changed, 1272 insertions(+), 43 deletions(-)
 create mode 100644 include/linux/sched/bt.h
 create mode 100644 kernel/sched/bt.c

-- 
1.8.3.1

