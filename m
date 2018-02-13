From: Mathieu Poirier <mathieu.poirier@linaro.org>
Subject: [PATCH V3 00/10] sched/deadline: fix cpusets bandwidth accounting
Date: Tue, 13 Feb 2018 13:32:37 -0700
Message-ID: <1518553967-20656-1-git-send-email-mathieu.poirier@linaro.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=z57Hit3+H8UV09ka/J4Dq70UG1UnZPsYR/dswzp0wLI=;
        b=iz0JoY5S5m6Ko+1krZzw4au/Ujjbsj9tEK35TWUe+Tv3tBdZkC6v4mEeS+fNmc33y0
         3dBLNYAAeD4JeFa86Z7t79dnJ8l4+IuEQz/N5qb52yDx0lsQHX5I9ZVPDmju/tRNmAm2
         mJBcZicIQYImK19PrkpGTlNNEuw5NRCchqaaA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: peterz@infradead.org
Cc: lizefan@huawei.com, mingo@redhat.com, rostedt@goodmis.org, claudio@evidence.eu.com, bristot@redhat.com, tommaso.cucinotta@santannapisa.it, juri.lelli@redhat.com, luca.abeni@santannapisa.it, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

This is the third installment of a patchset that attempt to fix a problem
reported by Steve Rostedt [1] where DL bandwidth accounting is not
recomputed after CPUset and CPU hotplug operations took place.  When CPU
hotplug and some CUPset manipulation take place root domains are destroyed
and new ones created, loosing at the same time DL accounting information
pertaining to utilisation.  Please see [2] for a full description of the
approach.

The most notable change in this revision is the resolution of
synchronisation issues between function __sched_setscheduler() and the
the CPUset subsystem as pointed out by Juri Lelli.

As with the second revision this set is available here [3] with the 
instrumentattion for patch 10/10 in this commit [4].  

This set applies cleanly on top of v4.16-rc1.

Best regards,
Mathieu

------
Changes for V3:
. Addressed potential race conditions between the CPUset subsystem and
  function __sched_setscheduler().
. Added a lockdep asset to function partition_sched_domains(). 

Change for V2:
. Addressing a problem found by Luca Abeni where the mask of a DL task
  isn't modified when cpuset are collapsed.

[1]. https://lkml.org/lkml/2016/2/3/966
[2]. https://groups.google.com/forum/#!topic/linux.kernel/uakbvOQE6rc
[3]. https://git.linaro.org/people/mathieu.poirier/linux.git/log/?h=v4.16-rc1-bandwidth-accounting-v3
[4]. 4a95e8ab0881 sched/debug: Add 'rq_debug' proc entry


Mathieu Poirier (10):
  sched/topology: Add check to backup comment about hotplug lock
  sched/topology: Adding function partition_sched_domains_locked()
  sched/core: Streamlining calls to task_rq_unlock()
  sched/core: Prevent race condition between cpuset and
    __sched_setscheduler()
  cpuset: Rebuild root domain deadline accounting information
  sched/deadline: Keep new DL task within root domain's boundary
  cgroup: Constrain 'sched_load_balance' flag when DL tasks are present
  cgroup: Constrain the addition of CPUs to a new CPUset
  sched/core: Don't change the affinity of DL tasks
  sched/deadline: Prevent CPU hotplug operation if DL task on CPU

 include/linux/cpuset.h         |  12 ++
 include/linux/sched.h          |   5 +
 include/linux/sched/deadline.h |   8 ++
 include/linux/sched/topology.h |  10 ++
 kernel/cgroup/cpuset.c         | 246 ++++++++++++++++++++++++++++++++++++++++-
 kernel/sched/core.c            |  63 ++++++++---
 kernel/sched/deadline.c        |  36 ++++++
 kernel/sched/sched.h           |   3 -
 kernel/sched/topology.c        |  33 +++++-
 9 files changed, 392 insertions(+), 24 deletions(-)

-- 
2.7.4

