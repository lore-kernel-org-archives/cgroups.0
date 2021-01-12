From: Daniel Bristot de Oliveira <bristot@redhat.com>
Subject: [PATCH 0/6] sched/deadline: cpuset task acceptance review
Date: Tue, 12 Jan 2021 16:53:39 +0100
Message-ID: <cover.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466847;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=KyiMZR0vfJuhbR4RIu5PNgEE9Brtz8v0SzJO9Fvad9w=;
        b=Wv0/mVJpl19Qx4M7Xgo00MaMy3IjYTlfbGpsHXGlr+fCk5yoQ1uTl7q0rr3t9V/0R0WlX8
        c3gSoiwTCEp4bH9f4nglqzT/g0EIKpOc+MtUdoJ1BVNg/5e+bNXx3/rvBrKjbRTWLm9btF
        30lG2VSn5Tmph0aP8tWFzMOitETirS0=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org
Cc: Marco Perronet <perronet@mpi-sws.org>, Daniel Bristot de Oliveira <bristot@redhat.com>, Ingo Molnar <mingo@redhat.com>, Peter Zijlstra <peterz@infradead.org>, Juri Lelli <juri.lelli@redhat.com>, Vincent Guittot <vincent.guittot@linaro.org>, Dietmar Eggemann <dietmar.eggemann@arm.com>, Steven Rostedt <rostedt@goodmis.org>, Ben Segall <bsegall@google.com>, Mel Gorman <mgorman@suse.de>, Li Zefan <lizefan@huawei.com>, Tejun Heo <tj@kernel.org>, Johannes Weiner <hannes@cmpxchg.org>, Valentin Schneider <valentin.schneider@arm.com>, cgroups@vger.kernel.org

While surveying the properties of the SCHED_DEADLINE, Marco Perronet found some
inconsistencies in the acceptance of DL threads on cpuset. More precisely,
regarding the acceptance of treads with arbitrary affinity. He contacted me,
and while doing the investigation, we found yet other potential issues
addressed in this patch series.

Each patch has a more in-depth explanation, including ways to reproduce
the problem. 

Daniel Bristot de Oliveira (6):
  sched/deadline: Consolidate the SCHED_DL task_can_attach() check on
    its own function
  sched/deadline: Inform dl_task_can_attach() if the cpuset is exclusive
  sched/deadline: Allow DL tasks on empty (cgroup v2) cpusets
  sched/deadline: Block DL tasks on non-exclusive cpuset if bandwitdh
    control is enable
  sched/deadline: Add helpers to get the correct root domain/span/dl_bw
  sched/deadline: Fixes cpu/rd/dl_bw references for suspended tasks

 include/linux/sched.h   |  2 +-
 kernel/cgroup/cpuset.c  |  5 ++++-
 kernel/sched/core.c     | 13 ++++++------
 kernel/sched/deadline.c | 28 ++++++++++++++++++++++---
 kernel/sched/sched.h    | 45 ++++++++++++++++++++++++++++++++++++++++-
 5 files changed, 80 insertions(+), 13 deletions(-)

-- 
2.29.2

