From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/3] cgroup: clean up cgroup_serial_nr_cursor
Date: Tue, 18 Jun 2013 11:18:35 -0700
Message-ID: <20130618181835.GC1596@htj.dyndns.org>
References: <51C03AF2.7050702@huawei.com>
 <51C03B05.4080504@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=XJljqDnYlOkpRXkG9qwHTyM6I9gKKoDVYVgW7JJD/i8=;
        b=HhxT1Y9P6M+8tmN+nfliRgrxFMk307ZkcaqddogqUYdUwSY4oONGvDkfC/klKT43HL
         CwdErclHbCtaWaVF0GW8CBuZ9arYJ0seTSmxs9yCdMu43vY4iKjuDE75oouEXI5DfrRy
         UPhAg4FhKTCBPCoZM9dVfXO0eZ60LX/zfgr78P34AewmINv8942rOgMs8wFAYnexZKw9
         UhDIlOw5TqRr8eOuy+yKVvW+u7iOZVPxg8aL0kyt/hwahnCNsocNicBCEVJoPB8z1Boi
         CrJEEXvySNSzMov/INBz18G9hoI67BZqD2X/UDKW50m5DPNnlCmBUSik3EHzsjI9AIzF
         LL7g==
Content-Disposition: inline
In-Reply-To: <51C03B05.4080504-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From 00356bd5f0f5e04183fb15805eb29e97c2fc20ac Mon Sep 17 00:00:00 2001
From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Date: Tue, 18 Jun 2013 11:14:22 -0700

cgroup_serial_nr_cursor was created atomic64_t because I thought it
was never gonna used for anything other than assigning unique numbers
to cgroups and didn't want to worry about synchronization; however,
now we're using it as an event-stamp to distinguish cgroups created
before and after certain point which assumes that it's protected by
cgroup_mutex.

Let's make it clear by making it a u64.  Also, rename it to
cgroup_serial_nr_next and make it point to the next nr to allocate so
that where it's pointing to is clear and more conventional.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
Applied to cgroup/for-3.11 as a follow-up.

Thanks.

 kernel/cgroup.c | 15 ++++++++-------
 1 file changed, 8 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 0ed7d8d..65f333e 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -203,9 +203,10 @@ static struct cgroup_name root_cgroup_name = { .name = "/" };
  * guarantees cgroups with bigger numbers are newer than those with smaller
  * numbers.  Also, as cgroups are always appended to the parent's
  * ->children list, it guarantees that sibling cgroups are always sorted in
- * the ascending serial number order on the list.
+ * the ascending serial number order on the list.  Protected by
+ * cgroup_mutex.
  */
-static atomic64_t cgroup_serial_nr_cursor = ATOMIC64_INIT(0);
+static u64 cgroup_serial_nr_next = 1;
 
 /* This flag indicates whether tasks in the fork and exit paths should
  * check for fork/exit handlers to call. This avoids us having to do
@@ -2803,7 +2804,7 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 	struct super_block *sb = ss->root->sb;
 	struct dentry *prev = NULL;
 	struct inode *inode;
-	u64 update_upto;
+	u64 update_before;
 
 	/* %NULL @cfts indicates abort and don't bother if @ss isn't attached */
 	if (!cfts || ss->root == &rootnode ||
@@ -2815,9 +2816,9 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 	/*
 	 * All cgroups which are created after we drop cgroup_mutex will
 	 * have the updated set of files, so we only need to update the
-	 * cgroups created before the current @cgroup_serial_nr_cursor.
+	 * cgroups created before the current @cgroup_serial_nr_next.
 	 */
-	update_upto = atomic64_read(&cgroup_serial_nr_cursor);
+	update_before = cgroup_serial_nr_next;
 
 	mutex_unlock(&cgroup_mutex);
 
@@ -2844,7 +2845,7 @@ static void cgroup_cfts_commit(struct cgroup_subsys *ss,
 
 		mutex_lock(&inode->i_mutex);
 		mutex_lock(&cgroup_mutex);
-		if (cgrp->serial_nr <= update_upto && !cgroup_is_dead(cgrp))
+		if (cgrp->serial_nr < update_before && !cgroup_is_dead(cgrp))
 			cgroup_addrm_files(cgrp, ss, cfts, is_add);
 		mutex_unlock(&cgroup_mutex);
 		mutex_unlock(&inode->i_mutex);
@@ -4327,7 +4328,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_free_all;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
-	cgrp->serial_nr = atomic64_inc_return(&cgroup_serial_nr_cursor);
+	cgrp->serial_nr = cgroup_serial_nr_next++;
 
 	/* allocation complete, commit to creation */
 	list_add_tail_rcu(&cgrp->sibling, &cgrp->parent->children);
-- 
1.8.2.1
