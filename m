From: trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Subject: [PATCH] cgroup: cleanup comments
Date: Sat,  5 Mar 2022 12:46:57 -0800
Message-ID: <20220305204657.707070-1-trix@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646513224;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=2fc8Gxpcx7Zhgatwh3dEBnBzDu9lzxud4zSky9VbbU4=;
        b=K+dAwXe3VgnixLPETYwsefACmb4N8cqKvHw80ggnSiXV8lwNdNsDF0WrpFohEbYM6lDick
        UAsEgCydAH0l2EKD0B50jdUE/ggVo0Mxqi5QTnQ4+z7m/nd5tBBvGaZxzbW2pH7ucMEn2C
        L8opP35PENdJxrvVG0h+setgisBCHos=
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org, tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

From: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

for spdx, add a space before //

replacements
judgement to judgment
transofrmed to transformed
partitition to partition
histrical to historical
migratecd to migrated

Signed-off-by: Tom Rix <trix-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c  | 10 +++++-----
 kernel/cgroup/freezer.c |  2 +-
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index ef88cc366bb84..9390bfd9f1cd3 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -71,7 +71,7 @@ DEFINE_STATIC_KEY_FALSE(cpusets_enabled_key);
 
 /*
  * There could be abnormal cpuset configurations for cpu or memory
- * node binding, add this key to provide a quick low-cost judgement
+ * node binding, add this key to provide a quick low-cost judgment
  * of the situation.
  */
 DEFINE_STATIC_KEY_FALSE(cpusets_insane_config_key);
@@ -1181,7 +1181,7 @@ enum subparts_cmd {
  * effective_cpus. The function will return 0 if all the CPUs listed in
  * cpus_allowed can be granted or an error code will be returned.
  *
- * For partcmd_disable, the cpuset is being transofrmed from a partition
+ * For partcmd_disable, the cpuset is being transformed from a partition
  * root back to a non-partition root. Any CPUs in cpus_allowed that are in
  * parent's subparts_cpus will be taken away from that cpumask and put back
  * into parent's effective_cpus. 0 should always be returned.
@@ -2027,7 +2027,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 }
 
 /*
- * update_prstate - update partititon_root_state
+ * update_prstate - update partition_root_state
  * cs: the cpuset to update
  * new_prs: new partition root state
  *
@@ -2879,7 +2879,7 @@ static int cpuset_css_online(struct cgroup_subsys_state *css)
 	/*
 	 * Clone @parent's configuration if CGRP_CPUSET_CLONE_CHILDREN is
 	 * set.  This flag handling is implemented in cgroup core for
-	 * histrical reasons - the flag may be specified during mount.
+	 * historical reasons - the flag may be specified during mount.
 	 *
 	 * Currently, if any sibling cpusets have exclusive cpus or mem, we
 	 * refuse to clone the configuration - thereby refusing the task to
@@ -3076,7 +3076,7 @@ hotplug_update_tasks_legacy(struct cpuset *cs,
 
 	/*
 	 * Don't call update_tasks_cpumask() if the cpuset becomes empty,
-	 * as the tasks will be migratecd to an ancestor.
+	 * as the tasks will be migrated to an ancestor.
 	 */
 	if (cpus_updated && !cpumask_empty(cs->cpus_allowed))
 		update_tasks_cpumask(cs);
diff --git a/kernel/cgroup/freezer.c b/kernel/cgroup/freezer.c
index 3984dd6b8ddbc..617861a547935 100644
--- a/kernel/cgroup/freezer.c
+++ b/kernel/cgroup/freezer.c
@@ -1,4 +1,4 @@
-//SPDX-License-Identifier: GPL-2.0
+// SPDX-License-Identifier: GPL-2.0
 #include <linux/cgroup.h>
 #include <linux/sched.h>
 #include <linux/sched/task.h>
-- 
2.26.3

