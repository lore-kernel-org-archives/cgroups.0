From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3 cgroup/for-3.19] cgroup: implement cgroup_get_e_css()
Date: Mon, 17 Nov 2014 15:58:55 -0500
Message-ID: <20141117205855.GC23126@htj.dyndns.org>
References: <20141117205652.GA23126@htj.dyndns.org>
 <20141117205734.GB23126@htj.dyndns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=6MJn4yes2/gIobkX4X6Mqug8OzAqi1g7py9OGQ91eVQ=;
        b=r+IArPnB3RONMYHjnR5RdeODQw5uYW0Bbox7mXINEtcvtKwwy5n1WOYw8/rlEI5zwH
         gI7Y6yOFfEdmAwYtCBG2lVvbEOWopG7Ny5d7N2jCI9rjo+q5grLcknJK0PV9o8P+5/sB
         u2a1fdctcpIqszbm6pvGDjvXsh+ybdK1IF79NhPgp050/bl6qmMGaNDfe8ymgcmONonA
         1RoXN3Pjs3nuEzecr7xNA0mWSKHlVNOkmvqZx6L6Fj1gY8miKnT7yN0rNb2YpnJfKMzU
         7nMHKCZ74Mm2R1kTczYiOXSubk+hUkEAIZQQSVN3QCEcuVsaZ/qh+AvDJX/SYUZ3CjNr
         1zpQ==
Content-Disposition: inline
In-Reply-To: <20141117205734.GB23126-Gd/HAXX7CRxy/B6EtB590w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Implement cgroup_get_e_css() which finds and gets the effective css
for the specified cgroup and subsystem combination.  This function
always returns a valid pinned css.  This will be used by cgroup
writeback support.

While at it, add comment to cgroup_e_css() to explain why that
function is different from cgroup_get_e_css() and has to test
cgrp->child_subsys_mask instead of cgroup_css(cgrp, ss).

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 include/linux/cgroup.h |    2 ++
 kernel/cgroup.c        |   37 +++++++++++++++++++++++++++++++++++++
 2 files changed, 39 insertions(+)

--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -910,6 +910,8 @@ void css_task_iter_end(struct css_task_i
 int cgroup_attach_task_all(struct task_struct *from, struct task_struct *);
 int cgroup_transfer_tasks(struct cgroup *to, struct cgroup *from);
 
+struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgroup,
+					     struct cgroup_subsys *ss);
 struct cgroup_subsys_state *css_tryget_online_from_dir(struct dentry *dentry,
 						       struct cgroup_subsys *ss);
 
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -277,6 +277,10 @@ static struct cgroup_subsys_state *cgrou
 	if (!(cgrp->root->subsys_mask & (1 << ss->id)))
 		return NULL;
 
+	/*
+	 * This function is used while updating css associations and thus
+	 * can't test the csses directly.  Use ->child_subsys_mask.
+	 */
 	while (cgroup_parent(cgrp) &&
 	       !(cgroup_parent(cgrp)->child_subsys_mask & (1 << ss->id)))
 		cgrp = cgroup_parent(cgrp);
@@ -284,6 +288,39 @@ static struct cgroup_subsys_state *cgrou
 	return cgroup_css(cgrp, ss);
 }
 
+/**
+ * cgroup_get_e_css - get a cgroup's effective css for the specified subsystem
+ * @cgrp: the cgroup of interest
+ * @ss: the subsystem of interest
+ *
+ * Find and get the effective css of @cgrp for @ss.  The effective css is
+ * defined as the matching css of the nearest ancestor including self which
+ * has @ss enabled.  If @ss is not mounted on the hierarchy @cgrp is on,
+ * the root css is returned, so this function always returns a valid css.
+ * The returned css must be put using css_put().
+ */
+struct cgroup_subsys_state *cgroup_get_e_css(struct cgroup *cgrp,
+					     struct cgroup_subsys *ss)
+{
+	struct cgroup_subsys_state *css;
+
+	rcu_read_lock();
+
+	do {
+		css = cgroup_css(cgrp, ss);
+
+		if (css && css_tryget_online(css))
+			goto out_unlock;
+		cgrp = cgroup_parent(cgrp);
+	} while (cgrp);
+
+	css = init_css_set.subsys[ss->id];
+	css_get(css);
+out_unlock:
+	rcu_read_unlock();
+	return css;
+}
+
 /* convenient tests for these bits */
 static inline bool cgroup_is_dead(const struct cgroup *cgrp)
 {
