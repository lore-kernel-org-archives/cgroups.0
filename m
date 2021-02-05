From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: [PATCH 4/8] cgroup: rstat: support cgroup1
Date: Fri,  5 Feb 2021 13:28:02 -0500
Message-ID: <20210205182806.17220-5-hannes@cmpxchg.org>
References: <20210205182806.17220-1-hannes@cmpxchg.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=BaUO0pgli+w3WAaSzoSou9pv5Ds3nAQBJUbmAgL0bVs=;
        b=AM3ZrZz8cvpBGn6MlO823+OEBTcXj/+p9LQp8MY8YAsGWuGslA5P7ox7fpa8rJoWfz
         md7ddBktXxCCmBlfPQRL549Cd+kHwYzfDMlBuA1Kis8uOitRMBu+JIr0TBY1JkhLaqEf
         U6c2a+wxWq9lQCLJwx5tuF3oJ+o5JNlwpkQa+paSMBwZ1veYAxAWfl0/TuCpDj4fsHzU
         mgGcUaIJfJbIt2Gl73PUll0IqbMyV3Cv4UHN3wInAJwUu3LsbL5p2rCnT+RMn6fSGVVV
         m4YfPHNDXLPlX5akurOGBWHjkX/aOxnlghimaHbpxRs9Q/5ddg7sX2By63vXOjhvn27H
         M5qg==
In-Reply-To: <20210205182806.17220-1-hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

Rstat currently only supports the default hierarchy in cgroup2. In
order to replace memcg's private stats infrastructure - used in both
cgroup1 and cgroup2 - with rstat, the latter needs to support cgroup1.

The initialization and destruction callbacks for regular cgroups are
already in place. Remove the cgroup_on_dfl() guards to handle cgroup1.

The initialization of the root cgroup is currently hardcoded to only
handle cgrp_dfl_root.cgrp. Move those callbacks to cgroup_setup_root()
and cgroup_destroy_root() to handle the default root as well as the
various cgroup1 roots we may set up during mounting.

The linking of css to cgroups happens in code shared between cgroup1
and cgroup2 as well. Simply remove the cgroup_on_dfl() guard.

Linkage of the root css to the root cgroup is a bit trickier: per
default, the root css of a subsystem controller belongs to the default
hierarchy (i.e. the cgroup2 root). When a controller is mounted in its
cgroup1 version, the root css is stolen and moved to the cgroup1 root;
on unmount, the css moves back to the default hierarchy. Annotate
rebind_subsystems() to move the root css linkage along between roots.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Reviewed-by: Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
---
 kernel/cgroup/cgroup.c | 34 +++++++++++++++++++++-------------
 kernel/cgroup/rstat.c  |  2 --
 2 files changed, 21 insertions(+), 15 deletions(-)

diff --git a/kernel/cgroup/cgroup.c b/kernel/cgroup/cgroup.c
index 9153b20e5cc6..e049edd66776 100644
--- a/kernel/cgroup/cgroup.c
+++ b/kernel/cgroup/cgroup.c
@@ -1339,6 +1339,7 @@ static void cgroup_destroy_root(struct cgroup_root *root)
 
 	mutex_unlock(&cgroup_mutex);
 
+	cgroup_rstat_exit(cgrp);
 	kernfs_destroy_root(root->kf_root);
 	cgroup_free_root(root);
 }
@@ -1751,6 +1752,12 @@ int rebind_subsystems(struct cgroup_root *dst_root, u16 ss_mask)
 				       &dcgrp->e_csets[ss->id]);
 		spin_unlock_irq(&css_set_lock);
 
+		if (ss->css_rstat_flush) {
+			list_del_rcu(&css->rstat_css_node);
+			list_add_rcu(&css->rstat_css_node,
+				     &dcgrp->rstat_css_list);
+		}
+
 		/* default hierarchy doesn't enable controllers by default */
 		dst_root->subsys_mask |= 1 << ssid;
 		if (dst_root == &cgrp_dfl_root) {
@@ -1971,10 +1978,14 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	if (ret)
 		goto destroy_root;
 
-	ret = rebind_subsystems(root, ss_mask);
+	ret = cgroup_rstat_init(root_cgrp);
 	if (ret)
 		goto destroy_root;
 
+	ret = rebind_subsystems(root, ss_mask);
+	if (ret)
+		goto exit_stats;
+
 	ret = cgroup_bpf_inherit(root_cgrp);
 	WARN_ON_ONCE(ret);
 
@@ -2006,6 +2017,8 @@ int cgroup_setup_root(struct cgroup_root *root, u16 ss_mask)
 	ret = 0;
 	goto out;
 
+exit_stats:
+	cgroup_rstat_exit(root_cgrp);
 destroy_root:
 	kernfs_destroy_root(root->kf_root);
 	root->kf_root = NULL;
@@ -4934,8 +4947,7 @@ static void css_free_rwork_fn(struct work_struct *work)
 			cgroup_put(cgroup_parent(cgrp));
 			kernfs_put(cgrp->kn);
 			psi_cgroup_free(cgrp);
-			if (cgroup_on_dfl(cgrp))
-				cgroup_rstat_exit(cgrp);
+			cgroup_rstat_exit(cgrp);
 			kfree(cgrp);
 		} else {
 			/*
@@ -4976,8 +4988,7 @@ static void css_release_work_fn(struct work_struct *work)
 		/* cgroup release path */
 		TRACE_CGROUP_PATH(release, cgrp);
 
-		if (cgroup_on_dfl(cgrp))
-			cgroup_rstat_flush(cgrp);
+		cgroup_rstat_flush(cgrp);
 
 		spin_lock_irq(&css_set_lock);
 		for (tcgrp = cgroup_parent(cgrp); tcgrp;
@@ -5034,7 +5045,7 @@ static void init_and_link_css(struct cgroup_subsys_state *css,
 		css_get(css->parent);
 	}
 
-	if (cgroup_on_dfl(cgrp) && ss->css_rstat_flush)
+	if (ss->css_rstat_flush)
 		list_add_rcu(&css->rstat_css_node, &cgrp->rstat_css_list);
 
 	BUG_ON(cgroup_css(cgrp, ss));
@@ -5159,11 +5170,9 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 	if (ret)
 		goto out_free_cgrp;
 
-	if (cgroup_on_dfl(parent)) {
-		ret = cgroup_rstat_init(cgrp);
-		if (ret)
-			goto out_cancel_ref;
-	}
+	ret = cgroup_rstat_init(cgrp);
+	if (ret)
+		goto out_cancel_ref;
 
 	/* create the directory */
 	kn = kernfs_create_dir(parent->kn, name, mode, cgrp);
@@ -5250,8 +5259,7 @@ static struct cgroup *cgroup_create(struct cgroup *parent, const char *name,
 out_kernfs_remove:
 	kernfs_remove(cgrp->kn);
 out_stat_exit:
-	if (cgroup_on_dfl(parent))
-		cgroup_rstat_exit(cgrp);
+	cgroup_rstat_exit(cgrp);
 out_cancel_ref:
 	percpu_ref_exit(&cgrp->self.refcnt);
 out_free_cgrp:
diff --git a/kernel/cgroup/rstat.c b/kernel/cgroup/rstat.c
index d51175cedfca..faa767a870ba 100644
--- a/kernel/cgroup/rstat.c
+++ b/kernel/cgroup/rstat.c
@@ -285,8 +285,6 @@ void __init cgroup_rstat_boot(void)
 
 	for_each_possible_cpu(cpu)
 		raw_spin_lock_init(per_cpu_ptr(&cgroup_rstat_cpu_lock, cpu));
-
-	BUG_ON(cgroup_rstat_init(&cgrp_dfl_root.cgrp));
 }
 
 /*
-- 
2.30.0

