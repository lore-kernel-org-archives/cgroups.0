From: Juri Lelli <juri.lelli@redhat.com>
Subject: [PATCH v2 0/6] sched/deadline: cpuset: Rework DEADLINE bandwidth restoration
Date: Wed,  3 May 2023 09:22:22 +0200
Message-ID: <20230503072228.115707-1-juri.lelli@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1683098576;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=IIZ/GCCJmx19uZ3mIOzJAELhL8g2Ju+C9RZzvBPp+14=;
        b=UlD8BqzR8DFk0puuZ5Ptlirl9D9/L/DVHBLKqcTnNFKDtMFfm0OEWH4T5GtMUCkvRBzQHh
        /S6TYuDVcPFEeU8nVxq5NL5ndbqUaZLq1x17aP/CyoAxuBgc6BGT0/wxl/pyPwTIxs/BK0
        TZ5JqXCGle5be3/PRNlx5cJe0CQXp9Y=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>, Qais Yousef <qyousef@layalina.io>, Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Hao Luo <haoluo@google.com>
Cc: Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, linux-kernel@vger.kernel.org, luca.abeni@santannapisa.it, claudio@evidence.eu.com, tommaso.cucinotta@santannapisa.it, bristot@redhat.com, mathieu.poirier@linaro.org, cgroups@vger.kernel.org, Vincent Guittot <vincent.guittot@linaro.org>, Wei Wang <wvw@google.com>, Rick Yiu <rickyiu@google.com>, Quentin Perret <qperret@google.com>, Heiko Carstens <hca@linux.ibm.com>, Vasily Gorbik <gor@linux.ibm.com>, Alexander Gordeev <agordeev@linux.ibm.com>, Sudeep Holla <sudeep.holla@arm.com>, Juri Lelli <juri.lelli@redhat.com>

Qais reported [1] that iterating over all tasks when rebuilding root
domains for finding out which ones are DEADLINE and need their bandwidth
correctly restored on such root domains can be a costly operation (10+
ms delays on suspend-resume). He proposed we skip rebuilding root
domains for certain operations, but that approach seemed arch specific
and possibly prone to errors, as paths that ultimately trigger a rebuild
might be quite convoluted (thanks Qais for spending time on this!).

This is v2 of an alternative approach (v1 at [3]) to fix the problem.

 01/06 - Rename functions deadline with DEADLINE accounting (cleanup
         suggested by Qais) - no functional change
 02/06 - Bring back cpuset_mutex (so that we have write access to cpusets
         from scheduler operations - and we also fix some problems
         associated to percpu_cpuset_rwsem)
 03/06 - Keep track of the number of DEADLINE tasks belonging to each cpuset
 04/06 - Use this information to only perform the costly iteration if
         DEADLINE tasks are actually present in the cpuset for which a
         corresponding root domain is being rebuilt
 05/06 - Create DL BW alloc, free & check overflow interface for bulk
         bandwidth allocation/removal - no functional change 
 06/06 - Fix bandwidth allocation handling for cgroup operation
         involving multiple tasks

With respect to the v1 posting [3]

 1 - rebase on top of Linus' tree as of today (865fdb08197e)
 2 - move patch 6 to position 4 - Qais

As the rebase needed some work, I decided to remove the tested and
reviewed bys. Please take another look, just in case I messed something
up.

This set is also available from

https://github.com/jlelli/linux.git deadline/rework-cpusets

Best,
Juri

1 - https://lore.kernel.org/lkml/20230206221428.2125324-1-qyousef@layalina.io/
2 - RFC https://lore.kernel.org/lkml/20230315121812.206079-1-juri.lelli@redhat.com/
3 - v1  https://lore.kernel.org/lkml/20230329125558.255239-1-juri.lelli@redhat.com/

Dietmar Eggemann (2):
  sched/deadline: Create DL BW alloc, free & check overflow interface
  cgroup/cpuset: Free DL BW in case can_attach() fails

Juri Lelli (4):
  cgroup/cpuset: Rename functions dealing with DEADLINE accounting
  sched/cpuset: Bring back cpuset_mutex
  sched/cpuset: Keep track of SCHED_DEADLINE task in cpusets
  cgroup/cpuset: Iterate only if DEADLINE tasks are present

 include/linux/cpuset.h  |  12 +-
 include/linux/sched.h   |   4 +-
 kernel/cgroup/cgroup.c  |   4 +
 kernel/cgroup/cpuset.c  | 242 ++++++++++++++++++++++++++--------------
 kernel/sched/core.c     |  41 +++----
 kernel/sched/deadline.c |  67 ++++++++---
 kernel/sched/sched.h    |   2 +-
 7 files changed, 244 insertions(+), 128 deletions(-)

-- 
2.40.1

