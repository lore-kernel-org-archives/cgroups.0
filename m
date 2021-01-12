From: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 4/6] sched/deadline: Block DL tasks on non-exclusive cpuset if bandwitdh control is enable
Date: Tue, 12 Jan 2021 16:53:43 +0100
Message-ID: <7b336c37cc3c38def6de181df8ba8c3148c5cc0c.1610463999.git.bristot@redhat.com>
References: <cover.1610463999.git.bristot@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610466876;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=9IT6yiKkF8lRzpuZXeT04IN/gm10k9t0WsQGxRpDxkw=;
        b=H8nyWU1qZR/hixMMbE3dt0V77VNMQLxpgGRYGiPWmWJQ+D47CNl0fmzcwlqtR/aehhC9lN
        aORhTSwaBhBuZ2J3AAP/Ef6UXOvoXSK33o8670p5CXstpL71wGvKphjCSkTUHHBMroYuWo
        n0Xu+sJYzqQ3nUFsXA3VSm5S/YKa7sg=
In-Reply-To: <cover.1610463999.git.bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>, Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>, Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

The current SCHED_DEADLINE design supports only global scheduler,
or variants of it, i.e., clustered and partitioned, via cpuset config.
To enable the partitioning of a system with clusters of CPUs, the
documentation advises the usage of exclusive cpusets, creating an
exclusive root_domain for the cpuset.

Attempts to change the cpu affinity of a thread to a cpu mask different
from the root domain results in an error. For instance:

----- %< -----
[root@x1 linux]# chrt -d --sched-period 1000000000 --sched-runtime 100000000 0 sleep 10000 &
[1] 69020
[root@x1 linux]# taskset -p -c 0 69020
pid 69020's current affinity list: 0-7
taskset: failed to set pid 69020's affinity: Device or resource busy
----- >% -----

However, such restriction can be bypassed by disabling the
SCHED_DEADLINE admission test, under the assumption that
the user is aware of the implications of such a decision.

However, Marco Perronet noticed that it was possible to
by-pass this mechanism because no restriction is currently
imposed by the cpuset mechanism.

For instance, this script:
----- %< -----
#!/bin/bash

# Enter on the cgroup directory
cd /sys/fs/cgroup/

# Check it if is cgroup v2 and enable cpuset
if [ -e cgroup.subtree_control ]; then
	# Enable cpuset controller on cgroup v2
	echo +cpuset > cgroup.subtree_control
fi

echo LOG: create a cpuset and assigned the CPU 0 to it
# Create cpuset groups
rmdir dl-group &> /dev/null
mkdir dl-group

# Restrict the task to the CPU 0
echo 0 > dl-group/cpuset.mems
echo 0 > dl-group/cpuset.cpus

# Place a task in the root cgroup
echo LOG: dispatching the first DL task
chrt -d --sched-period 1000000000 --sched-runtime 100000000 0 sleep 100 &
ROOT_PID="$!"
ROOT_ALLOWED=`cat /proc/$ROOT_PID/status | grep Cpus_allowed_list | awk '{print $2}'`

# Disapatch another task in the root cgroup, to move it later.
echo LOG: dispatching the second DL task
chrt -d --sched-period 1000000000 --sched-runtime 100000000 0 sleep 100 &
CPUSET_PID="$!"

# let them settle down
sleep 1

# Assign the second task to the cgroup
echo LOG: moving the second DL task to the cpuset
echo "$CPUSET_PID" > dl-group/cgroup.procs 2> /dev/null
ACCEPTED=$?
CPUSET_ALLOWED=`cat /proc/$CPUSET_PID/status | grep Cpus_allowed_list | awk '{print $2}'`

if [ $ACCEPTED == 0 ]; then
	echo FAIL: a DL task was accepted on a non-exclusive cpuset
else
	echo PASS: DL task was rejected on a non-exclusive cpuset
fi

if [ $ROOT_ALLOWED == $CPUSET_ALLOWED ]; then
	echo PASS: the affinity did not change: $CPUSET_ALLOWED == $ROOT_ALLOWED
else
	echo FAIL: the cpu affinity is different: $CPUSET_ALLOWED == $ROOT_ALLOWED
fi

# Just ignore the clean up
exec > /dev/null 2>&1
kill -9 $CPUSET_PID
kill -9 $ROOT_PID
rmdir dl-group
----- >% -----

Shows these results:
----- %< -----
LOG: create a cpuset and assigned the CPU 0 to it
LOG: dispatching the first DL task
LOG: dispatching the second DL task
LOG: moving the second DL task to the cpuset
FAIL: a DL task was accepted on a non-exclusive cpuset
FAIL: the cpu affinity is different: 0 == 0-3
----- >% -----

This result is a problem because the two tasks have a different
cpu mask, but they end up sharing the cpu 0, which is something
not supported in the current SCHED_DEADLINE designed (APA - Arbitrary
Processor Affinities).

To avoid such scenario, the correct action to be taken is rejecting
the attach of SCHED_DEADLINE thread to a non-exclusive cpuset.

With the proposed patch in place, the script above returns:

----- %< -----
LOG: create a cpuset and assigned the CPU 0 to it
LOG: dispatching the first DL task
LOG: dispatching the second DL task
LOG: moving the second DL task to the cpuset
PASS: DL task was rejected on a non-exclusive cpuset
PASS: the affinity did not change: 0-3 == 0-3
----- >% -----

Still, likewise for taskset, this restriction can be bypassed by
disabling the admission test, i.e.:

# sysctl -w kernel.sched_rt_runtime_us=-1

and work at their own risk.

Reported-by: Marco Perronet <perronet-41PbBDiSz5tAfugRpC6u6w@public.gmane.org>
Signed-off-by: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Ingo Molnar <mingo-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Vincent Guittot <vincent.guittot-QSEj5FYQhm4dnm+yROfE0A@public.gmane.org>
Cc: Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>
Cc: Steven Rostedt <rostedt-nx8X9YLhiw1AfugRpC6u6w@public.gmane.org>
Cc: Ben Segall <bsegall-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Cc: Daniel Bristot de Oliveira <bristot-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Valentin Schneider <valentin.schneider-5wv7dgnIgG8@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---
 kernel/sched/deadline.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/sched/deadline.c b/kernel/sched/deadline.c
index 788a391657a5..c221e14d5b86 100644
--- a/kernel/sched/deadline.c
+++ b/kernel/sched/deadline.c
@@ -2878,6 +2878,13 @@ int dl_task_can_attach(struct task_struct *p,
 	if (cpumask_empty(cs_cpus_allowed))
 		return 0;
 
+	/*
+	 * Do not allow moving tasks to non-exclusive cpusets
+	 * if bandwidth control is enabled.
+	 */
+	if (dl_bandwidth_enabled() && !exclusive)
+		return -EBUSY;
+
 	/*
 	 * The task is not moving to another root domain, so it is
 	 * already accounted.
-- 
2.29.2

