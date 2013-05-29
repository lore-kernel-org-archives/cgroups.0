From: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH v7 06/11] sched: document the cpu cgroup.
Date: Wed, 29 May 2013 15:03:17 +0400
Message-ID: <1369825402-31046-7-git-send-email-glommer@openvz.org>
References: <1369825402-31046-1-git-send-email-glommer@openvz.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1369825402-31046-1-git-send-email-glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
Cc: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Frederic Weisbecker <fweisbec-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>

The CPU cgroup is so far, undocumented. Although data exists in the
Documentation directory about its functioning, it is usually spread,
and/or presented in the context of something else. This file
consolidates all cgroup-related information about it.

Signed-off-by: Glauber Costa <glommer-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 Documentation/cgroups/cpu.txt | 81 +++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 81 insertions(+)
 create mode 100644 Documentation/cgroups/cpu.txt

diff --git a/Documentation/cgroups/cpu.txt b/Documentation/cgroups/cpu.txt
new file mode 100644
index 0000000..072fd58
--- /dev/null
+++ b/Documentation/cgroups/cpu.txt
@@ -0,0 +1,81 @@
+CPU Controller
+--------------
+
+The CPU controller is responsible for grouping tasks together that will be
+viewed by the scheduler as a single unit. The CFS scheduler will first divide
+CPU time equally between all entities in the same level, and then proceed by
+doing the same in the next level. Basic use cases for that are described in the
+main cgroup documentation file, cgroups.txt.
+
+Users of this functionality should be aware that deep hierarchies will of
+course impose scheduler overhead, since the scheduler will have to take extra
+steps and look up additional data structures to make its final decision.
+
+Through the CPU controller, the scheduler is also able to cap the CPU
+utilization of a particular group. This is particularly useful in environments
+in which CPU is paid for by the hour, and one values predictability over
+performance.
+
+CPU Accounting
+--------------
+
+The CPU cgroup will also provide additional files under the prefix "cpuacct".
+Those files provide accounting statistics and were previously provided by the
+separate cpuacct controller. Although the cpuacct controller will still be kept
+around for compatibility reasons, its usage is discouraged. If both the CPU and
+cpuacct controllers are present in the system, distributors are encouraged to
+always mount them together.
+
+Files
+-----
+
+The CPU controller exposes the following files to the user:
+
+ - cpu.shares: The weight of each group living in the same hierarchy, that
+ translates into the amount of CPU it is expected to get. Upon cgroup creation,
+ each group gets assigned a default of 1024. The percentage of CPU assigned to
+ the cgroup is the value of shares divided by the sum of all shares in all
+ cgroups in the same level.
+
+ - cpu.cfs_period_us: The duration in microseconds of each scheduler period, for
+ bandwidth decisions. This defaults to 100000us or 100ms. Larger periods will
+ improve throughput at the expense of latency, since the scheduler will be able
+ to sustain a cpu-bound workload for longer. The opposite of true for smaller
+ periods. Note that this only affects non-RT tasks that are scheduled by the
+ CFS scheduler.
+
+- cpu.cfs_quota_us: The maximum time in microseconds during each cfs_period_us
+  in for the current group will be allowed to run. For instance, if it is set to
+  half of cpu_period_us, the cgroup will only be able to peak run for 50 % of
+  the time. One should note that this represents aggregate time over all CPUs
+  in the system. Therefore, in order to allow full usage of two CPUs, for
+  instance, one should set this value to twice the value of cfs_period_us.
+
+- cpu.stat: statistics about the bandwidth controls. No data will be presented
+  if cpu.cfs_quota_us is not set. The file presents three
+  numbers:
+	nr_periods: how many full periods have been elapsed.
+	nr_throttled: number of times we exausted the full allowed bandwidth
+	throttled_time: total time the tasks were not run due to being overquota
+
+ - cpu.rt_runtime_us and cpu.rt_period_us: Those files are the RT-tasks
+   analogous to the CFS files cfs_quota_us and cfs_period_us. One important
+   difference, though, is that while the cfs quotas are upper bounds that
+   won't necessarily be met, the rt runtimes form a stricter guarantee.
+   Therefore, no overlap is allowed. Implications of that are that given a
+   hierarchy with multiple children, the sum of all rt_runtime_us may not exceed
+   the runtime of the parent. Also, a rt_runtime_us of 0, means that no rt tasks
+   can ever be run in this cgroup. For more information about rt tasks runtime
+   assignments, see scheduler/sched-rt-group.txt
+
+ - cpuacct.usage: The aggregate CPU time, in nanoseconds, consumed by all tasks
+   in this group.
+
+ - cpuacct.usage_percpu: The CPU time, in nanoseconds, consumed by all tasks in
+   this group, separated by CPU. The format is an space-separated array of time
+   values, one for each present CPU.
+
+ - cpuacct.stat: aggregate user and system time consumed by tasks in this group.
+   The format is
+	user: x
+	system: y
-- 
1.8.1.4
