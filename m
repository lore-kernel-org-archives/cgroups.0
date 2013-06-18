From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH 1/2][UPDATED] cgroup: make serial_nr_cursor available
 throughout cgroup.c
Date: Tue, 18 Jun 2013 11:16:18 -0700
Message-ID: <20130618181618.GA1596@htj.dyndns.org>
References: <51C03AF2.7050702@huawei.com>
 <51C03C41.2040704@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=WqYpYlsUGMpXGiiocJO9C1Ckh/ZKqYjAEOpnNbsEHvw=;
        b=gu6xezW98jnivaQkWtPLUu1+T85MjoEHSSfGgMWXbaj6ZpghQG4CaIdDxPHIvBLX0G
         ccE2wwmq3Ed8aAcRFyDkBP6Y1/R0DTcasRMaf+rQPmxPHfmP7fFRjI5zplxofEW0DJ6M
         ZtewVnuSjAP6OCwoI8zC2/xIlKupZeUHGnJSTiOTNTnhQ10F4j5mBTum3SwCE660U2bk
         WSwKdF6s0i3w2PXfEN7r6O9HqH7yCLApfW0mIYQRsn+F8fvwj6zJgxABc2Hy0SKnw5aZ
         fCkzXrIcKIzdmkb+B8UsRIp38KHsia9svYlkaLcD8+ERGBHj3VaxC/uWCu2nPjLfvvZp
         EAyA==
Content-Disposition: inline
In-Reply-To: <51C03C41.2040704-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

From 794611a1dfcb055d7d41ce133378dd8197d73e38 Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Tue, 18 Jun 2013 18:53:53 +0800

The next patch will use it to determine if a cgroup is newly created
while we're iterating the cgroup hierarchy.

tj: Rephrased the comment on top of cgroup_serial_nr_cursor.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
Applied to cgroup/for-3.11 with minor update.

Thanks.

 kernel/cgroup.c | 18 ++++++++++--------
 1 file changed, 10 insertions(+), 8 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 1d4f471..e6571ca 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -198,6 +198,15 @@ static DEFINE_IDR(cgroup_hierarchy_idr);
 
 static struct cgroup_name root_cgroup_name = { .name = "/" };
 
+/*
+ * Assign a monotonically increasing serial number to cgroups.  It
+ * guarantees cgroups with bigger numbers are newer than those with smaller
+ * numbers.  Also, as cgroups are always appended to the parent's
+ * ->children list, it guarantees that sibling cgroups are always sorted in
+ * the ascending serial number order on the list.
+ */
+static atomic64_t cgroup_serial_nr_cursor = ATOMIC64_INIT(0);
+
 /* This flag indicates whether tasks in the fork and exit paths should
  * check for fork/exit handlers to call. This avoids us having to do
  * extra work in the fork/exit path if none of the subsystems need to
@@ -4222,7 +4231,6 @@ static void offline_css(struct cgroup_subsys *ss, struct cgroup *cgrp)
 static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 			     umode_t mode)
 {
-	static atomic64_t serial_nr_cursor = ATOMIC64_INIT(0);
 	struct cgroup *cgrp;
 	struct cgroup_name *name;
 	struct cgroupfs_root *root = parent->root;
@@ -4309,13 +4317,7 @@ static long cgroup_create(struct cgroup *parent, struct dentry *dentry,
 		goto err_free_all;
 	lockdep_assert_held(&dentry->d_inode->i_mutex);
 
-	/*
-	 * Assign a monotonically increasing serial number.  With the list
-	 * appending below, it guarantees that sibling cgroups are always
-	 * sorted in the ascending serial number order on the parent's
-	 * ->children.
-	 */
-	cgrp->serial_nr = atomic64_inc_return(&serial_nr_cursor);
+	cgrp->serial_nr = atomic64_inc_return(&cgroup_serial_nr_cursor);
 
 	/* allocation complete, commit to creation */
 	list_add_tail(&cgrp->allcg_node, &root->allcg_list);
-- 
1.8.2.1
