From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 7/8] cgroup: Add cgroup_subsys->css_rstat_flush()
Date: Fri, 23 Mar 2018 16:13:12 -0700
Message-ID: <20180323231313.1254142-8-tj@kernel.org>
References: <20180323231313.1254142-1-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=XXazVncbNp9MKFhxysjXIil801yqpN9XCqKQP+Wq76Q=;
        b=FFjhjxxOQkZ1O3t41IWgDeKsu2uhEvZ5A8LiCrzySgT0nh0+gzYQj7cyVaJxb8eNdy
         ijdEPAJmLNpWuhnAPSIYbAm9nHgpm6AMQP4fOmBVaaOaZfVbs/avjAsJqmwrVg+jkrir
         d5SVbzgJEasUuKxS6/pMDphM+jJHzXWTP1qgEk5qBsWsM4sna/ks8YzhTQcX8WPHo16u
         BOB69dA2mssjcpure6lFRcEEiPRle9mmKRyTbaKPiHzPSg1hgJznFQx5KNmPeL6V5SaW
         E9EuOmFYE2VYwJqmUpbVmaz3mZpKfxM7nJUXlqe/4P3lFaTIbld6BrdHkJTOW7s0XTbO
         ePmg==
In-Reply-To: <20180323231313.1254142-1-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: lizefan@huawei.com, hannes@cmpxchg.org
Cc: cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, guro@fb.com, kernel-team@fb.com, Tejun Heo <tj@kernel.org>

This patch adds cgroup_subsys->css_rstat_flush().  If a subsystem has
this callback, its csses are linked on cgrp->css_rstat_list and rstat
will call the function whenever the associated cgroup is flushed.
Flush is also performed when such csses are released so that residual
counts aren't lost.

Combined with the rstat API previous patches factored out, this allows
controllers to plug into rstat to manage their statistics in a
scalable way.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 include/linux/cgroup-defs.h |  5 +++++
 kernel/cgroup/cgroup.c      | 11 +++++++++++
 kernel/cgroup/rstat.c       | 11 ++++++++++-
 3 files changed, 26 insertions(+), 1 deletion(-)

diff --git a/include/linux/cgroup-defs.h b/include/linux/cgroup-defs.h
index cf9db7b..8b8dd17 100644
--- a/include/linux/cgroup-defs.h
+++ b/include/linux/cgroup-defs.h
@@ -130,6 +130,9 @@ struct cgroup_subsys_state {
 	struct list_head sibling;
 	struct list_head children;
 
+	/* flush target list anchored at cgrp->rstat_css_list */
+	struct list_head rstat_css_node;
+
 	/*
 	 * PI: Subsys-unique ID.  0 is unused and root is always 1.  The
 	 * matching css can be looked up using css_from_id().
@@ -412,6 +415,7 @@ struct cgroup {
 
 	/* per-cpu recursive resource statistics */
 	struct cgroup_rstat_cpu __percpu *rstat_cpu;
+	struct list_head rstat_css_list;
 
 	/* cgroup basic resource statistics */
 	struct cgroup_base_stat pending_bstat;	/* pending from children */
@@ -577,6 +581,7 @@ struct cgroup_subsys {
 	void (*css_released)(struct cgroup_subsys_state *css);
 	void (*css_free)(struct cgroup_subsys_state *css);
 	void (*css_reset)(struct cgroup_subsys_state *css);
+	void (*css_rstat_flush)(struct cgroup_subsys_state *css, int cpu);
 	int (*css_extra_stat_show)(struct seq_file *seq,
 				   struct cgroup_subsys_state *css);
 
diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 0d3d093..f29f84e 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1860,6 +1860,7 @@ static void init_cgroup_housekeeping(struct cgroup *cgrp)
 	cgrp->dom_cgrp = cgrp;
 	cgrp->max_descendants = INT_MAX;
 	cgrp->max_depth = INT_MAX;
+	INIT_LIST_HEAD(&cgrp->rstat_css_list);
 	prev_cputime_init(&cgrp->prev_cputime);
 
 	for_each_subsys(ss, ssid)
@@ -4630,6 +4631,11 @@ static void css_release_work_fn(struct work_struct *work)
 
 	if (ss) {
 		/* css release path */
+		if (!list_empty(&css->rstat_css_node)) {
+			cgroup_rstat_flush(cgrp);
+			list_del_rcu(&css->rstat_css_node);
+		}
+
 		cgroup_idr_replace(&ss->css_idr, NULL, css->id);
 		if (ss->css_released)
 			ss->css_released(css);
@@ -4690,6 +4696,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 	css->id = -1;
 	INIT_LIST_HEAD(&css->sibling);
 	INIT_LIST_HEAD(&css->children);
+	INIT_LIST_HEAD(&css->rstat_css_node);
 	css->serial_nr = css_serial_nr_next++;
 	atomic_set(&css->online_cnt, 0);
 
@@ -4698,6 +4705,9 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 		css_get(css->parent);
 	}
 
+	if (cgroup_on_dfl(cgrp) && ss->css_rstat_flush)
+		list_add_rcu(&css->rstat_css_node, &cgrp->rstat_css_list);
+
 	BUG_ON(cgroup_css(cgrp, ss));
 }
 
@@ -4799,6 +4809,7 @@ static struct cgroup_subsys_state *css_create(struct cgroup *cgrp,
 err_list_del:
 	list_del_rcu(&css->sibling);
 err_free_css:
+	list_del_rcu(&css->rstat_css_node);
 	call_rcu(&css->rcu_head, css_free_rcu_fn);
 	return ERR_PTR(err);
 }
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index a5f9338..18b464a 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -143,8 +143,17 @@ static void cgroup_rstat_flush_locked(struct cgroup *cgrp, bool may_sleep)
 		struct cgroup *pos = NULL;
 
 		raw_spin_lock(cpu_lock);
-		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu)))
+		while ((pos = cgroup_rstat_cpu_pop_updated(pos, cgrp, cpu))) {
+			struct cgroup_subsys_state *css;
+
 			cgroup_base_stat_flush(pos, cpu);
+
+			rcu_read_lock();
+			list_for_each_entry_rcu(css, &pos->rstat_css_list,
+						rstat_css_node)
+				css->ss->css_rstat_flush(css, cpu);
+			rcu_read_unlock();
+		}
 		raw_spin_unlock(cpu_lock);
 
 		/* if @may_sleep, play nice and yield if necessary */
-- 
2.9.5

