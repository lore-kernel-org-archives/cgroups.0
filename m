From: Waiman Long <longman@redhat.com>
Subject: [PATCH v8 5/7] cgroup/cpuset: Check partition conflict with housekeeping setup
Date: Tue,  5 Sep 2023 09:32:41 -0400
Message-ID: <20230905133243.91107-6-longman@redhat.com>
References: <20230905133243.91107-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693920777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=xpywMhCSI4nUvJd4HJj3m6pA8mTWgmEGbD+CeqR1nWU=;
        b=fgNtm8n/pNlWJPpA8ZI6O6M2QCcYF+T8dZxjvx6l2F6TpGLX5AsA/xpZoUaFFi9f6ZUcEr
        6hrppoHbMjTvxuNLIqiv9U57eVNQF2j56JMDMx4JFPML8ZIihzs/A2/emX9UaWHTuj2fca
        VynBpN3EbrChdQMAUKD1hyrMmlL35bk=
In-Reply-To: <20230905133243.91107-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Christian Brauner <brauner@kernel.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Dietmar Eggemann <dietmar.eggemann@arm.com>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny@suse.com>, Giuseppe Scrivano <gscrivan@redhat.com>, Waiman Long <longman@redhat.com>

A user can pre-configure certain CPUs in an isolated state at boot time
with the "isolcpus" kernel boot command line option. Those CPUs will
not be in the housekeeping_cpumask(HK_TYPE_DOMAIN) and so will not
be in any sched domains. This may conflict with the partition setup
at runtime. Those boot time isolated CPUs should only be used in an
isolated partition.

This patch adds the necessary check and disallows partition setup if the
check fails.

Signed-off-by: Waiman Long <longman@redhat.com>
---
 kernel/cgroup/cpuset.c | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7ac320e079b8..15f399153a2e 100644
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
@@ -1646,6 +1648,26 @@ static void remote_partition_check(struct cpuset *cs, struct cpumask *newmask,
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
@@ -1748,6 +1770,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		    !cpumask_intersects(xcpus, parent->effective_xcpus))
 			return PERR_INVCPUS;
 
+		if (prstate_housekeeping_conflict(new_prs, xcpus))
+			return PERR_HKEEPING;
+
 		/*
 		 * A parent can be left with no CPU as long as there is no
 		 * task directly associated with the parent partition.
@@ -2335,6 +2360,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (cpumask_empty(trialcs->effective_xcpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_INVCPUS;
+		} else if (prstate_housekeeping_conflict(old_prs, trialcs->effective_xcpus)) {
+			invalidate = true;
+			cs->prs_err = PERR_HKEEPING;
 		} else if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_NOCPUS;
@@ -2469,6 +2497,9 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (cpumask_empty(trialcs->effective_xcpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_INVCPUS;
+		} else if (prstate_housekeeping_conflict(old_prs, trialcs->effective_xcpus)) {
+			invalidate = true;
+			cs->prs_err = PERR_HKEEPING;
 		} else if (tasks_nocpu_error(parent, cs, trialcs->effective_xcpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_NOCPUS;
-- 
2.31.1

