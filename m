From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v5 3/5] cgroup/cpuset: Check partition conflict with housekeeping setup
Date: Thu, 13 Jul 2023 13:25:59 -0400
Message-ID: <20230713172601.3285847-4-longman@redhat.com>
References: <20230713172601.3285847-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689269189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=YhbHfkkyMLUVZBMfytZR4SEPeF8T5uIgeTwYKIX8mco=;
        b=BID4OpQzeo7Qs0rXwgWx6dvjCEFBRHgDm4+RvO6S1hC96lxOUTOr/HbNUMr3HlEUtvNCZ8
        nTgK9s8dJvkNCewhXA1rA9w+IvzaAqTuyAPlTpx05UfRA12WVKOr57CBVQDMO97ji3x23r
        QeyefvuXmTI7W52Go6WuOt2UDOZnR20=
In-Reply-To: <20230713172601.3285847-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Christian Brauner <brauner-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Dietmar Eggemann <dietmar.eggemann-5wv7dgnIgG8@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Giuseppe Scrivano <gscrivan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

A user can pre-configure certain CPUs in an isolated state at boot time
with the "isolcpus" kernel boot command line option. Those CPUs will
not be in the housekeeping_cpumask(HK_TYPE_DOMAIN) and so will not
be in any sched domains. This may conflict with the partition setup
at runtime. Those boot time isolated CPUs should only be used in an
isolated partition.

This patch adds the necessary check and disallows partition setup if the
check fails.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index b1fc8ba3cfbf..ff16fa8b24fb 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -75,6 +75,7 @@ enum prs_errcode {
 	PERR_NOCPUS,
 	PERR_HOTPLUG,
 	PERR_CPUSEMPTY,
+	PERR_HKEEPING,
 };
 
 static const char * const perr_strings[] = {
@@ -85,6 +86,7 @@ static const char * const perr_strings[] = {
 	[PERR_NOCPUS]    = "Parent unable to distribute cpu downstream",
 	[PERR_HOTPLUG]   = "No cpu available due to hotplug",
 	[PERR_CPUSEMPTY] = "cpuset.cpus is empty",
+	[PERR_HKEEPING]  = "partition config conflicts with housekeeping setup",
 };
 
 struct cpuset {
@@ -1658,6 +1660,26 @@ static void remote_partition_check(struct cpuset *cs, struct cpumask *newmask,
 		rebuild_sched_domains_locked();
 }
 
+/*
+ * prstate_housekeeping_conflict - check for partition & housekeeping conflicts
+ * @prstate: partition root state to be checked
+ * @new_cpus: cpu mask
+ * Return: true if there is conflict, false otherwise
+ *
+ * CPUs outside of housekeeping_cpumask(HK_TYPE_DOMAIN) can only be used in
+ * an isolated partition.
+ */
+static bool prstate_housekeeping_conflict(int prstate, struct cpumask *new_cpus)
+{
+	const struct cpumask *hk_domain = housekeeping_cpumask(HK_TYPE_DOMAIN);
+	bool all_in_hk = cpumask_subset(new_cpus, hk_domain);
+
+	if (!all_in_hk && (prstate != PRS_ISOLATED))
+		return true;
+
+	return false;
+}
+
 /**
  * update_parent_effective_cpumask - update effective_cpus mask of parent cpuset
  * @cs:      The cpuset that requests change in partition root state
@@ -1758,6 +1780,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (!cpumask_intersects(xcpus, parent->exclusive_cpus))
 			return PERR_INVCPUS;
 
+		if (prstate_housekeeping_conflict(new_prs, xcpus))
+			return PERR_HKEEPING;
+
 		/*
 		 * A parent can be left with no CPU as long as there is no
 		 * task directly associated with the parent partition.
@@ -2335,6 +2360,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (cpumask_empty(trialcs->exclusive_cpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_INVCPUS;
+		} else if (prstate_housekeeping_conflict(old_prs, trialcs->exclusive_cpus)) {
+			invalidate = true;
+			cs->prs_err = PERR_HKEEPING;
 		} else if (tasks_nocpu_error(parent, cs, trialcs->exclusive_cpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_NOCPUS;
@@ -2473,6 +2501,9 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (cpumask_empty(trialcs->exclusive_cpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_INVCPUS;
+		} else if (prstate_housekeeping_conflict(old_prs, trialcs->exclusive_cpus)) {
+			invalidate = true;
+			cs->prs_err = PERR_HKEEPING;
 		} else if (tasks_nocpu_error(parent, cs, trialcs->exclusive_cpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_NOCPUS;
-- 
2.31.1

