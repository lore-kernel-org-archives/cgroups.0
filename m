From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 6/6] cgroup: remove bogus comments in cgroup_diput()
Date: Thu, 17 Jan 2013 16:05:09 +0800
Message-ID: <50F7B0B5.9050207@huawei.com>
References: <50F7B040.2020906@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <50F7B040.2020906-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Peter Zijlstra <peterz-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Ingo Molnar <mingo-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

Since commit 48ddbe194623ae089cc0576e60363f2d2e85662a
("cgroup: make css->refcnt clearing on cgroup removal optional"),
each css holds a ref on cgroup's dentry, so cgroup_diput() won't be
called until all css' refs go down to 0, which invalids the comments.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 83ac78b..77ab520 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -899,12 +899,6 @@ static void cgroup_diput(struct dentry *dentry, struct inode *inode)
 		struct cgroup *cgrp = dentry->d_fsdata;
 
 		BUG_ON(!(cgroup_is_removed(cgrp)));
-		/* It's possible for external users to be holding css
-		 * reference counts on a cgroup; css_put() needs to
-		 * be able to access the cgroup after decrementing
-		 * the reference count in order to know if it needs to
-		 * queue the cgroup to be handled by the release
-		 * agent */
 		call_rcu(&cgrp->rcu_head, cgroup_free_rcu);
 	} else {
 		struct cfent *cfe = __d_cfe(dentry);
-- 
1.8.0.2
