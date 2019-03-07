From: Joel Savitz <jsavitz@redhat.com>
Subject: [PATCH] cpuset: restore sanity to cpuset_cpus_allowed_fallback()
Date: Wed,  6 Mar 2019 19:54:48 -0500
Message-ID: <1551920088-30685-1-git-send-email-jsavitz@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel@vger.kernel.org
Cc: Joel Savitz <jsavitz@redhat.com>, Li Zefan <lizefan@huawei.com>, cgroups@vger.kernel.org

If a process is limited by taskset (i.e. cpuset) to only be allowed to
run on cpu N, and then cpu N is offlined via hotplug, the process will
be assigned the current value of its cpuset cgroup's effective_cpus field
in a call to do_set_cpus_allowed() in cpuset_cpus_allowed_fallback().
This argument's value does not makes sense for this case, because
task_cs(tsk)->effective_cpus is modified by cpuset_hotplug_workfn()
to reflect the new value of cpu_active_mask after cpu N is removed from
the mask. While this may make sense for the cgroup affinity mask, it
does not make sense on a per-task basis, as a task that was previously
limited to only be run on cpu N will be limited to every cpu _except_ for
cpu N after it is offlined/onlined via hotplug.

Pre-patch behavior:

	$ grep Cpus /proc/$$/status
	Cpus_allowed:	ff
	Cpus_allowed_list:	0-7

	$ taskset -p 4 $$
	pid 19202's current affinity mask: f
	pid 19202's new affinity mask: 4

	$ grep Cpus /proc/self/status
	Cpus_allowed:	04
	Cpus_allowed_list:	2

	# echo off > /sys/devices/system/cpu/cpu2/online 
	$ grep Cpus /proc/$$/status
	Cpus_allowed:	0b
	Cpus_allowed_list:	0-1,3

	# echo on > /sys/devices/system/cpu/cpu2/online 
	$ grep Cpus /proc/$$/status
	Cpus_allowed:	0b
	Cpus_allowed_list:	0-1,3

On a patched system, the final grep produces the following
output instead:

	$ grep Cpus /proc/$$/status
	Cpus_allowed:	ff
	Cpus_allowed_list:	0-7

This patch changes the above behavior by instead simply resetting the mask
to cpu_possible_mask.

Signed-off-by: Joel Savitz <jsavitz@redhat.com>
---
 kernel/cgroup/cpuset.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 479743db6c37..5f65a2167bdf 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -3243,7 +3243,7 @@ void cpuset_cpus_allowed(struct task_struct *tsk, struct cpumask *pmask)
 void cpuset_cpus_allowed_fallback(struct task_struct *tsk)
 {
 	rcu_read_lock();
-	do_set_cpus_allowed(tsk, task_cs(tsk)->effective_cpus);
+	do_set_cpus_allowed(tsk, cpu_possible_mask);
 	rcu_read_unlock();
 
 	/*
-- 
2.20.1

