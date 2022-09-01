From: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v12 05/10] cgroup/cpuset: Add a new isolated cpus.partition type
Date: Thu,  1 Sep 2022 16:57:40 -0400
Message-ID: <20220901205745.323326-6-longman@redhat.com>
References: <20220901205745.323326-1-longman@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1662065903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=QnU31Nsmclkfh0AaTfrO7QonqM4KLt/sdDNST71bYRQ=;
        b=NuxXNw1esXngW4UgYEwTOk9SMvC3LyeSM1tBdjQru7iqvAb9cwZc5eNgj1UvgoyInJ0JTm
        fIqEK7UEL/t2szEUS0jvaXwsg8ex08SW4C95Y3tzb9vDY6YdCLhT/24WpvMS0ZyEz06aKC
        BZ9DtFjOUneetWcGI7vqu87bFfDRfvU=
In-Reply-To: <20220901205745.323326-1-longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Zefan Li <lizefan.x-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Jonathan Corbet <corbet-T1hC0tSOHrs@public.gmane.org>, Shuah Khan <shuah-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-doc-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kselftest-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Phil Auld <pauld-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Juri Lelli <juri.lelli-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Frederic Weisbecker <frederic-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, =?UTF-8?q?Michal=20Koutn=C3=BD?= <mkoutny-IBi9RG/b67k@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>

Cpuset v1 uses the sched_load_balance control file to determine if load
balancing should be enabled.  Cpuset v2 gets rid of sched_load_balance
as its use may require disabling load balancing at cgroup root.

For workloads that require very low latency like DPDK, the latency
jitters caused by periodic load balancing may exceed the desired
latency limit.

When cpuset v2 is in use, the only way to avoid this latency cost is to
use the "isolcpus=" kernel boot option to isolate a set of CPUs. After
the kernel boot, however, there is no way to add or remove CPUs from
this isolated set. For workloads that are more dynamic in nature, that
means users have to provision enough CPUs for the worst case situation
resulting in excess idle CPUs.

To address this issue for cpuset v2, a new cpuset.cpus.partition type
"isolated" is added which allows the creation of a cpuset partition
without load balancing. This will allow system administrators to
dynamically adjust the size of isolated partition to the current need
of the workload without rebooting the system.

Signed-off-by: Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup/cpuset.c | 74 +++++++++++++++++++++++++++++++++++-------
 1 file changed, 63 insertions(+), 11 deletions(-)

diff --git a/kernel/cgroup/cpuset.c b/kernel/cgroup/cpuset.c
index 7f64bb1a7bef..f53ca022549c 100644
--- a/kernel/cgroup/cpuset.c
+++ b/kernel/cgroup/cpuset.c
@@ -178,11 +178,15 @@ struct cpuset {
  *
  *   0 - member (not a partition root)
  *   1 - partition root
+ *   2 - partition root without load balancing (isolated)
  *  -1 - invalid partition root
+ *  -2 - invalid isolated partition root
  */
 #define PRS_MEMBER		0
 #define PRS_ROOT		1
+#define PRS_ISOLATED		2
 #define PRS_INVALID_ROOT	-1
+#define PRS_INVALID_ISOLATED	-2
 
 static inline bool is_prs_invalid(int prs_state)
 {
@@ -282,7 +286,8 @@ static inline int is_partition_invalid(const struct cpuset *cs)
  */
 static inline void make_partition_invalid(struct cpuset *cs)
 {
-	cs->partition_root_state = PRS_INVALID_ROOT;
+	if (is_partition_valid(cs))
+		cs->partition_root_state = -cs->partition_root_state;
 }
 
 /*
@@ -1380,17 +1385,19 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 
 	if (cmd == partcmd_update) {
 		/*
-		 * Check for possible transition between PRS_ROOT
-		 * and PRS_INVALID_ROOT.
+		 * Check for possible transition between valid and invalid
+		 * partition root.
 		 */
 		switch (cs->partition_root_state) {
 		case PRS_ROOT:
+		case PRS_ISOLATED:
 			if (part_error)
-				new_prs = PRS_INVALID_ROOT;
+				new_prs = -old_prs;
 			break;
 		case PRS_INVALID_ROOT:
+		case PRS_INVALID_ISOLATED:
 			if (!part_error)
-				new_prs = PRS_ROOT;
+				new_prs = -old_prs;
 			break;
 		}
 	}
@@ -1400,7 +1407,7 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 
 	/*
 	 * Transitioning between invalid to valid or vice versa may require
-	 * changing CS_CPU_EXCLUSIVE.
+	 * changing CS_CPU_EXCLUSIVE and CS_SCHED_LOAD_BALANCE.
 	 */
 	if (old_prs != new_prs) {
 		if (is_prs_invalid(old_prs) && !is_cpu_exclusive(cs) &&
@@ -1443,8 +1450,17 @@ static int update_parent_subparts_cpumask(struct cpuset *cs, int cmd,
 	if (adding || deleting)
 		update_tasks_cpumask(parent);
 
+	/*
+	 * Set or clear CS_SCHED_LOAD_BALANCE when partcmd_update, if necessary.
+	 * rebuild_sched_domains_locked() may be called.
+	 */
+	if (old_prs != new_prs) {
+		if (old_prs == PRS_ISOLATED)
+			update_flag(CS_SCHED_LOAD_BALANCE, cs, 1);
+		else if (new_prs == PRS_ISOLATED)
+			update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
+	}
 	notify_partition_change(cs, old_prs);
-
 	return 0;
 }
 
@@ -1519,6 +1535,7 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 		if ((cp != cs) && old_prs) {
 			switch (parent->partition_root_state) {
 			case PRS_ROOT:
+			case PRS_ISOLATED:
 				update_parent = true;
 				break;
 
@@ -1528,7 +1545,8 @@ static void update_cpumasks_hier(struct cpuset *cs, struct tmpmasks *tmp,
 				 * invalid, child partition roots become
 				 * invalid too.
 				 */
-				new_prs = PRS_INVALID_ROOT;
+				if (is_partition_valid(cp))
+					new_prs = -cp->partition_root_state;
 				break;
 			}
 		}
@@ -2110,6 +2128,7 @@ static int update_flag(cpuset_flagbits_t bit, struct cpuset *cs,
 static int update_prstate(struct cpuset *cs, int new_prs)
 {
 	int err = 0, old_prs = cs->partition_root_state;
+	bool sched_domain_rebuilt = false;
 	struct cpuset *parent = parent_cs(cs);
 	struct tmpmasks tmpmask;
 
@@ -2120,8 +2139,10 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	 * For a previously invalid partition root, leave it at being
 	 * invalid if new_prs is not "member".
 	 */
-	if (new_prs && is_prs_invalid(old_prs))
+	if (new_prs && is_prs_invalid(old_prs)) {
+		cs->partition_root_state = -new_prs;
 		return 0;
+	}
 
 	if (alloc_cpumasks(NULL, &tmpmask))
 		return -ENOMEM;
@@ -2147,6 +2168,22 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 			update_flag(CS_CPU_EXCLUSIVE, cs, 0);
 			goto out;
 		}
+
+		if (new_prs == PRS_ISOLATED) {
+			/*
+			 * Disable the load balance flag should not return an
+			 * error unless the system is running out of memory.
+			 */
+			update_flag(CS_SCHED_LOAD_BALANCE, cs, 0);
+			sched_domain_rebuilt = true;
+		}
+	} else if (old_prs && new_prs) {
+		/*
+		 * A change in load balance state only, no change in cpumasks.
+		 */
+		update_flag(CS_SCHED_LOAD_BALANCE, cs, (new_prs != PRS_ISOLATED));
+		sched_domain_rebuilt = true;
+		goto out;	/* Sched domain is rebuilt in update_flag() */
 	} else {
 		/*
 		 * Switching back to member is always allowed even if it
@@ -2168,6 +2205,12 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 
 		/* Turning off CS_CPU_EXCLUSIVE will not return error */
 		update_flag(CS_CPU_EXCLUSIVE, cs, 0);
+
+		if (!is_sched_load_balance(cs)) {
+			/* Make sure load balance is on */
+			update_flag(CS_SCHED_LOAD_BALANCE, cs, 1);
+			sched_domain_rebuilt = true;
+		}
 	}
 
 	update_tasks_cpumask(parent);
@@ -2175,13 +2218,14 @@ static int update_prstate(struct cpuset *cs, int new_prs)
 	if (parent->child_ecpus_count)
 		update_sibling_cpumasks(parent, cs, &tmpmask);
 
-	rebuild_sched_domains_locked();
+	if (!sched_domain_rebuilt)
+		rebuild_sched_domains_locked();
 out:
 	/*
 	 * Make partition invalid if an error happen
 	 */
 	if (err)
-		new_prs = PRS_INVALID_ROOT;
+		new_prs = -new_prs;
 	spin_lock_irq(&callback_lock);
 	cs->partition_root_state = new_prs;
 	spin_unlock_irq(&callback_lock);
@@ -2691,12 +2735,18 @@ static int sched_partition_show(struct seq_file *seq, void *v)
 	case PRS_ROOT:
 		seq_puts(seq, "root\n");
 		break;
+	case PRS_ISOLATED:
+		seq_puts(seq, "isolated\n");
+		break;
 	case PRS_MEMBER:
 		seq_puts(seq, "member\n");
 		break;
 	case PRS_INVALID_ROOT:
 		seq_puts(seq, "root invalid\n");
 		break;
+	case PRS_INVALID_ISOLATED:
+		seq_puts(seq, "isolated invalid\n");
+		break;
 	}
 	return 0;
 }
@@ -2717,6 +2767,8 @@ static ssize_t sched_partition_write(struct kernfs_open_file *of, char *buf,
 		val = PRS_ROOT;
 	else if (!strcmp(buf, "member"))
 		val = PRS_MEMBER;
+	else if (!strcmp(buf, "isolated"))
+		val = PRS_ISOLATED;
 	else
 		return -EINVAL;
 
-- 
2.31.1

