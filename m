From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 06/13] cpuset: cleanup cpuset[_can]_attach()
Date: Thu,  3 Jan 2013 13:36:00 -0800
Message-ID: <1357248967-24959-7-git-send-email-tj@kernel.org>
References: <1357248967-24959-1-git-send-email-tj@kernel.org>
Return-path: <owner-linux-mm@kvack.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:sender:from:to:cc:subject:date:message-id:x-mailer
         :in-reply-to:references;
        bh=5Pa4kqyLmd9zXlAU6ybRZEdT3ZAOXhHWuaminoOZfzU=;
        b=CMijL6Gq7WhHM++GnQLAP3yCAlKC8JIPpm6L61tGznQYxIEcix6MpZ4Ynh6cz02ZUH
         x3Uh9Ey9+K7+fgqvZpKERBwvZ1xY/zpr0SV1xzRuTQUU0NiMVDH/cPDbFsG82Bo3iIZb
         Nw9fSl6ry05IjfsL+UXJmj6gaOWXV1WW9H8OgCCBHhXpGtwvh/gRkPlFlwEG4oPig0RD
         obW6VOiz7kSqq/hRcX/dtEV7KJ+GucERFZveHrRz2jzT2vt/uIDpRwO2lH8KA0aknVEu
         lQ0O0hTy8P/QKo0RqgnprR2tDJJo756S4PeH/P9VFig45I4wiKuTifoh7sLnJ0/MmBVC
         zeDQ==
In-Reply-To: <1357248967-24959-1-git-send-email-tj@kernel.org>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, paul@paulmenage.org, glommer@parallels.com
Cc: containers@lists.linux-foundation.org, cgroups@vger.kernel.org, peterz@infradead.org, mhocko@suse.cz, bsingharora@gmail.com, hannes@cmpxchg.org, kamezawa.hiroyu@jp.fujitsu.com, linux-mm@kvack.org, linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>, Rusty Russell <rusty@rustcorp.com.au>

cpuset_can_attach() prepare global variables cpus_attach and
cpuset_attach_nodemask_{to|from} which are used by cpuset_attach().
There is no reason to prepare in cpuset_can_attach().  The same
information can be accessed from cpuset_attach().

Move the prepartion logic from cpuset_can_attach() to cpuset_attach()
and make the global variables static ones inside cpuset_attach().

With this change, there's no reason to keep
cpuset_attach_nodemask_{from|to} global.  Move them inside
cpuset_attach().  Unfortunately, we need to keep cpus_attach global as
it can't be allocated from cpuset_attach().

v2: cpus_attach not converted to cpumask_t as per Li Zefan and Rusty
    Russell.

Signed-off-by: Tejun Heo <tj@kernel.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>
Cc: Li Zefan <lizefan@huawei.com>
---
 kernel/cpuset.c | 35 ++++++++++++++++++-----------------
 1 file changed, 18 insertions(+), 17 deletions(-)

diff --git a/kernel/cpuset.c b/kernel/cpuset.c
index 4b054b9..c5edc6b 100644
--- a/kernel/cpuset.c
+++ b/kernel/cpuset.c
@@ -1395,15 +1395,6 @@ static int fmeter_getrate(struct fmeter *fmp)
 	return val;
 }
 
-/*
- * Protected by cgroup_lock. The nodemasks must be stored globally because
- * dynamically allocating them is not allowed in can_attach, and they must
- * persist until attach.
- */
-static cpumask_var_t cpus_attach;
-static nodemask_t cpuset_attach_nodemask_from;
-static nodemask_t cpuset_attach_nodemask_to;
-
 /* Called by cgroups to determine if a cpuset is usable; cgroup_mutex held */
 static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
@@ -1430,19 +1421,21 @@ static int cpuset_can_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 			return ret;
 	}
 
-	/* prepare for attach */
-	if (cs == &top_cpuset)
-		cpumask_copy(cpus_attach, cpu_possible_mask);
-	else
-		guarantee_online_cpus(cs, cpus_attach);
-
-	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
-
 	return 0;
 }
 
+/*
+ * Protected by cgroup_mutex.  cpus_attach is used only by cpuset_attach()
+ * but we can't allocate it dynamically there.  Define it global and
+ * allocate from cpuset_init().
+ */
+static cpumask_var_t cpus_attach;
+
 static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 {
+	/* static bufs protected by cgroup_mutex */
+	static nodemask_t cpuset_attach_nodemask_from;
+	static nodemask_t cpuset_attach_nodemask_to;
 	struct mm_struct *mm;
 	struct task_struct *task;
 	struct task_struct *leader = cgroup_taskset_first(tset);
@@ -1450,6 +1443,14 @@ static void cpuset_attach(struct cgroup *cgrp, struct cgroup_taskset *tset)
 	struct cpuset *cs = cgroup_cs(cgrp);
 	struct cpuset *oldcs = cgroup_cs(oldcgrp);
 
+	/* prepare for attach */
+	if (cs == &top_cpuset)
+		cpumask_copy(cpus_attach, cpu_possible_mask);
+	else
+		guarantee_online_cpus(cs, cpus_attach);
+
+	guarantee_online_mems(cs, &cpuset_attach_nodemask_to);
+
 	cgroup_taskset_for_each(task, cgrp, tset) {
 		/*
 		 * can_attach beforehand should guarantee that this doesn't
-- 
1.8.0.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
