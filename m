From: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Subject: [PATCH v3 3/6] expose fine-grained per-cpu data for cpuacct stats
Date: Wed, 30 May 2012 13:48:34 +0400
Message-ID: <1338371317-5980-4-git-send-email-glommer@parallels.com>
References: <1338371317-5980-1-git-send-email-glommer@parallels.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1338371317-5980-1-git-send-email-glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, devel-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org, Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, "Eric W. Biederman" <ebiederm-aS9lmoZGLiVWk0Htik3J/w@public.gmane.org>, handai.szj-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Andrew.Phillips-xheW4WVAX9Y@public.gmane.org, Serge Hallyn <serge.hallyn-Z7WLFzj8eWMS+FvcfC7Uqw@public.gmane.org>, Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>

The cpuacct cgroup already exposes user and system numbers in a per-cgroup
fashion. But they are a summation along the whole group, not a per-cpu figure.
Also, they are coarse-grained version of the stats usually shown at places
like /proc/stat.

I want to have enough cgroup data to emulate the /proc/stat interface. To
achieve that, I am creating a new file "stat_percpu" that displays the
fine-grained per-cpu data. The original data is left alone.

The format of this file resembles the one found in the usual cgroup's stat
files. But of course, the fields will be repeated, one per cpu, and prefixed
with the cpu number.

Therefore, we'll have something like:

  cpu0.user X
  cpu0.system Y
  ...
  cpu1.user X1
  cpu1.system Y1
  ...

Signed-off-by: Glauber Costa <glommer-bzQdu9zFT3WakBO8gow8eQ@public.gmane.org>
CC: Peter Zijlstra <a.p.zijlstra-/NLkJaSkS4VmR6Xm/wNWPw@public.gmane.org>
CC: Paul Turner <pjt-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---
 kernel/sched/core.c |   33 +++++++++++++++++++++++++++++++++
 1 file changed, 33 insertions(+)

diff --git a/kernel/sched/core.c b/kernel/sched/core.c
index 220d416..4c1d7e9 100644
--- a/kernel/sched/core.c
+++ b/kernel/sched/core.c
@@ -8178,6 +8178,35 @@ static int cpuacct_stats_show(struct cgroup *cgrp, struct cftype *cft,
 	return 0;
 }
 
+static inline void do_fill_cb(struct cgroup_map_cb *cb, struct cpuacct *ca,
+			      char *str, int cpu, int index)
+{
+	char name[24];
+	struct kernel_cpustat *kcpustat = per_cpu_ptr(ca->cpustat, cpu);
+
+	snprintf(name, sizeof(name), "cpu%d.%s", cpu, str);
+	cb->fill(cb, name, cputime64_to_clock_t(kcpustat->cpustat[index]));
+}
+
+static int cpuacct_stats_percpu_show(struct cgroup *cgrp, struct cftype *cft,
+				     struct cgroup_map_cb *cb)
+{
+	struct cpuacct *ca = cgroup_ca(cgrp);
+	int cpu;
+
+	for_each_online_cpu(cpu) {
+		do_fill_cb(cb, ca, "user", cpu, CPUTIME_USER);
+		do_fill_cb(cb, ca, "nice", cpu, CPUTIME_NICE);
+		do_fill_cb(cb, ca, "system", cpu, CPUTIME_SYSTEM);
+		do_fill_cb(cb, ca, "irq", cpu, CPUTIME_IRQ);
+		do_fill_cb(cb, ca, "softirq", cpu, CPUTIME_SOFTIRQ);
+		do_fill_cb(cb, ca, "guest", cpu, CPUTIME_GUEST);
+		do_fill_cb(cb, ca, "guest_nice", cpu, CPUTIME_GUEST_NICE);
+	}
+
+	return 0;
+}
+
 static struct cftype files[] = {
 	{
 		.name = "usage",
@@ -8192,6 +8221,10 @@ static struct cftype files[] = {
 		.name = "stat",
 		.read_map = cpuacct_stats_show,
 	},
+	{
+		.name = "stat_percpu",
+		.read_map = cpuacct_stats_percpu_show,
+	},
 	{ }	/* terminate */
 };
 
-- 
1.7.10.2
