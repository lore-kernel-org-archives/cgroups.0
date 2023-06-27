From: Waiman Long <longman@redhat.com>
Subject: [PATCH v4 7/9] cgroup/cpuset: Check partition conflict with housekeeping setup
Date: Tue, 27 Jun 2023 10:35:06 -0400
Message-ID: <20230627143508.1576882-8-longman@redhat.com>
References: <20230627143508.1576882-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-doc-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1687876563;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=vmQ47yrk6oi4cwmpXV9NlSGFJ5Yq05aPKaX6AWXHzFg=;
        b=UN21Mqra9VuzAjK4Oq9vSEUtX9R4K61p2qSfpiw0AXVxYXPojVTcyA/6e7y5+f19X82IkB
        xIZWogAsiSO34MeXc32glZvZGEhcpOoEDY8Ia2ksSR6j7/YVVFz7EAmR4jZ/968pHqTyKq
        /rJt9NElVZOF+IdF5W0I2Vu2zd0IPk4=
In-Reply-To: <20230627143508.1576882-1-longman@redhat.com>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>, Johannes Weiner <hannes@cmpxchg.org>, Jonathan Corbet <corbet@lwn.net>, Shuah Khan <shuah@kernel.org>
Cc: linux-kernel@vger.kernel.org, cgroups@vger.kernel.org, linux-doc@vger.kernel.org, linux-kselftest@vger.kernel.org, Juri Lelli <juri.lelli@redhat.com>, Valentin Schneider <vschneid@redhat.com>, Frederic Weisbecker <frederic@kernel.org>, Mrunal Patel <mpatel@redhat.com>, Ryan Phillips <rphillips@redhat.com>, Brent Rowsell <browsell@redhat.com>, Peter Hunt <pehunt@redhat.com>, Phil Auld <pauld@redhat.com>, Waiman Long <longman@redhat.com>

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
index 56aa7b4f213c..3b0805eacb6b 100644
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
@@ -1574,6 +1576,26 @@ static int remote_cpus_update(struct cpuset *cs, struct cpumask *newmask,
 	return 0;
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
@@ -1674,6 +1696,9 @@ static int update_parent_effective_cpumask(struct cpuset *cs, int cmd,
 		if (!cpumask_intersects(xcpus, parent->exclusive_cpus))
 			return PERR_INVCPUS;
 
+		if (prstate_housekeeping_conflict(new_prs, xcpus))
+			return PERR_HKEEPING;
+
 		/*
 		 * A parent can be left with no CPU as long as there is no
 		 * task directly associated with the parent partition.
@@ -2249,6 +2274,9 @@ static int update_cpumask(struct cpuset *cs, struct cpuset *trialcs,
 		if (cpumask_empty(trialcs->exclusive_cpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_INVCPUS;
+		} else if (prstate_housekeeping_conflict(old_prs, trialcs->exclusive_cpus)) {
+			invalidate = true;
+			cs->prs_err = PERR_HKEEPING;
 		} else if (tasks_nocpu_error(parent, cs, trialcs->exclusive_cpus)) {
 			invalidate = true;
 			cs->prs_err = PERR_NOCPUS;
@@ -2381,6 +2409,9 @@ static int update_exclusive_cpumask(struct cpuset *cs, struct cpuset *trialcs,
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

