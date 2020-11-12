From: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2] cpuset: fix race between hotplug work and later CPU offline
Date: Thu, 12 Nov 2020 12:17:11 -0500
Message-ID: <20201112171711.639541-1-daniel.m.jordan@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : mime-version : content-transfer-encoding;
 s=corp-2020-01-29; bh=hnDD1OaQV3/V8O1ynyyI2YtOMS2gUFD+PHh5569AHdU=;
 b=c+g4DiulHXt6cLuxrGOTiFnhu599gnVJ4zGqJorgNZUGZ7m9DLJ7IsR9FKMpoUUELtR8
 12009ufC3nTNZLL/laGPiJb3UsbMPyEWfN6ay9ZMd6vHkCg3+EeNaM+nNvUJoT2yRZ41
 3PyI7WaA0T7m4oAzhh+udcf0MXU5a42Gr0VXoRBO448N3sHijXqMKZqfjV365J0ImnGU
 idLGR5gXurtX/b09ALrF12VkACh4KxCliGVp2qTZpeoxtbls5NqNcIben7ZZxhzLu1V4
 8QAoX3ns6RSoofmOnQ2tgE61VPSBUGZQUaoDU0aXM7toqsW88/ZirIOizcr60rTOPxKV RQ== 
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>

One of our machines keeled over trying to rebuild the scheduler domains.
Mainline produces the same splat:

  BUG: unable to handle page fault for address: 0000607f820054db
  CPU: 2 PID: 149 Comm: kworker/1:1 Not tainted 5.10.0-rc1-master+ #6
  Workqueue: events cpuset_hotplug_workfn
  RIP: build_sched_domains
  Call Trace:
   partition_sched_domains_locked
   rebuild_sched_domains_locked
   cpuset_hotplug_workfn

It happens with cgroup2 and exclusive cpusets only.  This reproducer
triggers it on an 8-cpu vm and works most effectively with no
preexisting child cgroups:

  cd $UNIFIED_ROOT
  mkdir cg1
  echo 4-7 > cg1/cpuset.cpus
  echo root > cg1/cpuset.cpus.partition

  # with smt/control reading 'on',
  echo off > /sys/devices/system/cpu/smt/control

RIP maps to

  sd->shared = *per_cpu_ptr(sdd->sds, sd_id);

from sd_init().  sd_id is calculated earlier in the same function:

  cpumask_and(sched_domain_span(sd), cpu_map, tl->mask(cpu));
  sd_id = cpumask_first(sched_domain_span(sd));

tl->mask(cpu), which reads cpu_sibling_map on x86, returns an empty mask
and so cpumask_first() returns >= nr_cpu_ids, which leads to the bogus
value from per_cpu_ptr() above.

The problem is a race between cpuset_hotplug_workfn() and a later
offline of CPU N.  cpuset_hotplug_workfn() updates the effective masks
when N is still online, the offline clears N from cpu_sibling_map, and
then the worker uses the stale effective masks that still have N to
generate the scheduling domains, leading the worker to read
N's empty cpu_sibling_map in sd_init().

rebuild_sched_domains_locked() prevented the race during the cgroup2
cpuset series up until the Fixes commit changed its check.  Make the
check more robust so that it can detect an offline CPU in any exclusive
cpuset's effective mask, not just the top one.

Fixes: 0ccea8feb980 ("cpuset: Make generate_sched_domains() work with partition")
Signed-off-by: Daniel Jordan <daniel.m.jordan-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Cc: Prateek Sood <prsood-sgV2jX0FEOL9JmXXK+q4OQ@public.gmane.org>
Cc: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
---

v2:
 - Made the comment more descriptive (Peter)

 kernel/cgroup/cpuset.c | 33 ++++++++++++++++++++++++++++-----
 1 file changed, 28 insertions(+), 5 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 57b5b5d0a5fd..53c70c470a38 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -983,25 +983,48 @@ partition_and_rebuild_sched_domains(int ndoms_new, cpumask_var_t doms_new[],
  */
 static void rebuild_sched_domains_locked(void)
 {
+	struct cgroup_subsys_state *pos_css;
 	struct sched_domain_attr *attr;
 	cpumask_var_t *doms;
+	struct cpuset *cs;
 	int ndoms;
 
 	lockdep_assert_cpus_held();
 	percpu_rwsem_assert_held(&cpuset_rwsem);
 
 	/*
-	 * We have raced with CPU hotplug. Don't do anything to avoid
+	 * If we have raced with CPU hotplug, return early to avoid
 	 * passing doms with offlined cpu to partition_sched_domains().
-	 * Anyways, hotplug work item will rebuild sched domains.
+	 * Anyways, cpuset_hotplug_workfn() will rebuild sched domains.
+	 *
+	 * With no CPUs in any subpartitions, top_cpuset's effective CPUs
+	 * should be the same as the active CPUs, so checking only top_cpuset
+	 * is enough to detect racing CPU offlines.
 	 */
 	if (!top_cpuset.nr_subparts_cpus &&
 	    !cpumask_equal(top_cpuset.effective_cpus, cpu_active_mask))
 		return;
 
-	if (top_cpuset.nr_subparts_cpus &&
-	   !cpumask_subset(top_cpuset.effective_cpus, cpu_active_mask))
-		return;
+	/*
+	 * With subpartition CPUs, however, the effective CPUs of a partition
+	 * root should be only a subset of the active CPUs.  Since a CPU in any
+	 * partition root could be offlined, all must be checked.
+	 */
+	if (top_cpuset.nr_subparts_cpus) {
+		rcu_read_lock();
+		cpuset_for_each_descendant_pre(cs, pos_css, &top_cpuset) {
+			if (!is_partition_root(cs)) {
+				pos_css = css_rightmost_descendant(pos_css);
+				continue;
+			}
+			if (!cpumask_subset(cs->effective_cpus,
+					    cpu_active_mask)) {
+				rcu_read_unlock();
+				return;
+			}
+		}
+		rcu_read_unlock();
+	}
 
 	/* Generate domain masks and attrs */
 	ndoms = generate_sched_domains(&doms, &attr);

base-commit: 3d5e28bff7ad55aea081c1af516cc1c94a5eca7d
-- 
2.29.2

