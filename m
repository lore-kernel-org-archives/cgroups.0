From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 4/7] cgroup: Make debug cgroup support v2 and thread mode
Date: Wed, 14 Jun 2017 16:08:39 -0400
Message-ID: <20170614200842.15174-5-tj@kernel.org>
References: <20170614200842.15174-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=mCqRKvUS9x++gjAbXVCGgZJgzlqLX4rbQ450qBtOJ08=;
        b=lQlGbkLe+5VXta9pJ89woBcfEfmepqmJ3hc/iKWeKwEPLq3xYCc2EKtV3DDwyplulG
         QJEzah80h1aPhlwcn7s7+ENH/l6gwE7ecYSdT3IHlsm5bR6XvYDScHM7HbItU3vmLXHf
         cJYGy+xWMBx+yQr1jMc5QWagVnBsxh7fbiUwJd5Qiq8rdhyJDsJFKqSf2rUKvNCAWWEb
         AsK5FxcjDF+nHdV4hZYbU9FpLLM88GCmT4exeJL0mRl7bMZMFyxVG4ZKMqnK0cSeriVf
         ibdtTgz3HEE1cnA1FxSSDKYwGy4XpYEqKMYfUp5qW389qitQlKy6t55hU/qcs0LqwPfc
         6CAg==
In-Reply-To: <20170614200842.15174-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Waiman Long <longman@redhat.com>
Cc: lizefan@huawei.com, hannes@cmpxchg.org, peterz@infradead.org, mingo@redhat.com, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

From: Waiman Long <longman@redhat.com>

Besides supporting cgroup v2 and thread mode, the following changes
are also made:
 1) current_* cgroup files now resides only at the root as we don't
    need duplicated files of the same function all over the cgroup
    hierarchy.
 2) The cgroup_css_links_read() function is modified to report
    the number of tasks that are skipped because of overflow.
 3) The number of extra unaccounted references are displayed.
 4) The current_css_set_read() function now prints out the addresses of
    the css'es associated with the current css_set.
 5) A new cgroup_subsys_states file is added to display the css objects
    associated with a cgroup.
 6) A new cgroup_masks file is added to display the various controller
    bit masks in the cgroup.

tj: Dropped thread mode related information for now so that debug
    controller changes aren't blocked on the thread mode.

Signed-off-by: Waiman Long <longman@redhat.com>
Signed-off-by: Tejun Heo <tj@kernel.org>
---
 kernel/cgroup/debug.c | 170 +++++++++++++++++++++++++++++++++++++++++++++-----
 1 file changed, 153 insertions(+), 17 deletions(-)

diff --git a/kernel/cgroup/debug.c b/kernel/cgroup/debug.c
index cbe77a2087c5..057d9b07f461 100644
--- a/kernel/cgroup/debug.c
+++ b/kernel/cgroup/debug.c
@@ -36,10 +36,37 @@ static u64 debug_taskcount_read(struct cgroup_subsys_state *css,
 	return cgroup_task_count(css->cgroup);
 }
 
-static u64 current_css_set_read(struct cgroup_subsys_state *css,
-				struct cftype *cft)
+static int current_css_set_read(struct seq_file *seq, void *v)
 {
-	return (u64)(unsigned long)current->cgroups;
+	struct css_set *cset;
+	struct cgroup_subsys *ss;
+	struct cgroup_subsys_state *css;
+	int i, refcnt;
+
+	mutex_lock(&cgroup_mutex);
+	spin_lock_irq(&css_set_lock);
+	rcu_read_lock();
+	cset = rcu_dereference(current->cgroups);
+	refcnt = refcount_read(&cset->refcount);
+	seq_printf(seq, "css_set %pK %d", cset, refcnt);
+	if (refcnt > cset->nr_tasks)
+		seq_printf(seq, " +%d", refcnt - cset->nr_tasks);
+	seq_puts(seq, "\n");
+
+	/*
+	 * Print the css'es stored in the current css_set.
+	 */
+	for_each_subsys(ss, i) {
+		css = cset->subsys[ss->id];
+		if (!css)
+			continue;
+		seq_printf(seq, "%2d: %-4s\t- %lx[%d]\n", ss->id, ss->name,
+			  (unsigned long)css, css->id);
+	}
+	rcu_read_unlock();
+	spin_unlock_irq(&css_set_lock);
+	mutex_unlock(&cgroup_mutex);
+	return 0;
 }
 
 static u64 current_css_set_refcount_read(struct cgroup_subsys_state *css,
@@ -84,31 +111,126 @@ static int cgroup_css_links_read(struct seq_file *seq, void *v)
 {
 	struct cgroup_subsys_state *css = seq_css(seq);
 	struct cgrp_cset_link *link;
+	int dead_cnt = 0, extra_refs = 0;
 
 	spin_lock_irq(&css_set_lock);
 	list_for_each_entry(link, &css->cgroup->cset_links, cset_link) {
 		struct css_set *cset = link->cset;
 		struct task_struct *task;
 		int count = 0;
+		int refcnt = refcount_read(&cset->refcount);
 
-		seq_printf(seq, "css_set %pK\n", cset);
+		seq_printf(seq, " %d", refcnt);
+		if (refcnt - cset->nr_tasks > 0) {
+			int extra = refcnt - cset->nr_tasks;
+
+			seq_printf(seq, " +%d", extra);
+			/*
+			 * Take out the one additional reference in
+			 * init_css_set.
+			 */
+			if (cset == &init_css_set)
+				extra--;
+			extra_refs += extra;
+		}
+		seq_puts(seq, "\n");
 
 		list_for_each_entry(task, &cset->tasks, cg_list) {
-			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
-				goto overflow;
-			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
+			if (count++ <= MAX_TASKS_SHOWN_PER_CSS)
+				seq_printf(seq, "  task %d\n",
+					   task_pid_vnr(task));
 		}
 
 		list_for_each_entry(task, &cset->mg_tasks, cg_list) {
-			if (count++ > MAX_TASKS_SHOWN_PER_CSS)
-				goto overflow;
-			seq_printf(seq, "  task %d\n", task_pid_vnr(task));
+			if (count++ <= MAX_TASKS_SHOWN_PER_CSS)
+				seq_printf(seq, "  task %d\n",
+					   task_pid_vnr(task));
 		}
-		continue;
-	overflow:
-		seq_puts(seq, "  ...\n");
+		/* show # of overflowed tasks */
+		if (count > MAX_TASKS_SHOWN_PER_CSS)
+			seq_printf(seq, "  ... (%d)\n",
+				   count - MAX_TASKS_SHOWN_PER_CSS);
+
+		if (cset->dead) {
+			seq_puts(seq, "    [dead]\n");
+			dead_cnt++;
+		}
+
+		WARN_ON(count != cset->nr_tasks);
 	}
 	spin_unlock_irq(&css_set_lock);
+
+	if (!dead_cnt && !extra_refs)
+		return 0;
+
+	seq_puts(seq, "\n");
+	if (extra_refs)
+		seq_printf(seq, "extra references = %d\n", extra_refs);
+	if (dead_cnt)
+		seq_printf(seq, "dead css_sets = %d\n", dead_cnt);
+
+	return 0;
+}
+
+static int cgroup_subsys_states_read(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct cgroup_subsys *ss;
+	struct cgroup_subsys_state *css;
+	char pbuf[16];
+	int i;
+
+	mutex_lock(&cgroup_mutex);
+	for_each_subsys(ss, i) {
+		css = rcu_dereference_check(cgrp->subsys[ss->id], true);
+		if (!css)
+			continue;
+
+		pbuf[0] = '\0';
+
+		/* Show the parent CSS if applicable*/
+		if (css->parent)
+			snprintf(pbuf, sizeof(pbuf) - 1, " P=%d",
+				 css->parent->id);
+		seq_printf(seq, "%2d: %-4s\t- %lx[%d] %d%s\n", ss->id, ss->name,
+			  (unsigned long)css, css->id,
+			  atomic_read(&css->online_cnt), pbuf);
+	}
+	mutex_unlock(&cgroup_mutex);
+	return 0;
+}
+
+static int cgroup_masks_read(struct seq_file *seq, void *v)
+{
+	struct cgroup *cgrp = seq_css(seq)->cgroup;
+	struct cgroup_subsys *ss;
+	int i, j;
+	struct {
+		u16  *mask;
+		char *name;
+	} mask_list[] = {
+		{ &cgrp->subtree_control,  "subtree_control"  },
+		{ &cgrp->subtree_ss_mask,  "subtree_ss_mask"  },
+	};
+
+	mutex_lock(&cgroup_mutex);
+	for (i = 0; i < ARRAY_SIZE(mask_list); i++) {
+		u16 mask = *mask_list[i].mask;
+		bool first = true;
+
+		seq_printf(seq, "%-17s: ", mask_list[i].name);
+		for_each_subsys(ss, j) {
+			if (!(mask & (1 << ss->id)))
+				continue;
+			if (!first)
+				seq_puts(seq, ", ");
+			seq_puts(seq, ss->name);
+			first = false;
+		}
+		seq_putc(seq, '\n');
+	}
+
+	mutex_unlock(&cgroup_mutex);
 	return 0;
 }
 
@@ -126,17 +248,20 @@ static struct cftype debug_files[] =  {
 
 	{
 		.name = "current_css_set",
-		.read_u64 = current_css_set_read,
+		.seq_show = current_css_set_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
 
 	{
 		.name = "current_css_set_refcount",
 		.read_u64 = current_css_set_refcount_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
 
 	{
 		.name = "current_css_set_cg_links",
 		.seq_show = current_css_set_cg_links_read,
+		.flags = CFTYPE_ONLY_ON_ROOT,
 	},
 
 	{
@@ -145,6 +270,16 @@ static struct cftype debug_files[] =  {
 	},
 
 	{
+		.name = "cgroup_subsys_states",
+		.seq_show = cgroup_subsys_states_read,
+	},
+
+	{
+		.name = "cgroup_masks",
+		.seq_show = cgroup_masks_read,
+	},
+
+	{
 		.name = "releasable",
 		.read_u64 = releasable_read,
 	},
@@ -153,7 +288,8 @@ static struct cftype debug_files[] =  {
 };
 
 struct cgroup_subsys debug_cgrp_subsys = {
-	.css_alloc = debug_css_alloc,
-	.css_free = debug_css_free,
-	.legacy_cftypes = debug_files,
+	.css_alloc	= debug_css_alloc,
+	.css_free	= debug_css_free,
+	.legacy_cftypes	= debug_files,
+	.dfl_cftypes	= debug_files,
 };
-- 
2.13.0

