From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Subject: Re: [PATCH 4/6] cgroups: forbid pre_destroy callback to fail
Date: Fri, 19 Oct 2012 13:09:49 +0200
Message-ID: <20121019110949.GC799@dhcp22.suse.cz>
References: <1350480648-10905-1-git-send-email-mhocko@suse.cz>
 <1350480648-10905-5-git-send-email-mhocko@suse.cz>
 <50811E5E.1090205@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <50811E5E.1090205-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

On Fri 19-10-12 17:33:18, Li Zefan wrote:
> On 2012/10/17 21:30, Michal Hocko wrote:
> > Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
> > safely move on and forbit all the callbacks to fail. The last missing
> > piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
> > that css_tryget fails so no new charges for the memcg can happen.
> 
> > The callbacks are also called from within cgroup_lock to guarantee that
> > no new tasks show up. 
> 
> I'm afraid this won't work. See commit 3fa59dfbc3b223f02c26593be69ce6fc9a940405
> ("cgroup: fix potential deadlock in pre_destroy")

Very good point. Thanks for poiting this out. So we should call
pre_destroy at the very end? What about the following?
Or should be rather drop the lock after check_for_release(parent) or
sooner but after CGRP_REMOVED is set?
---
From 70ea8718aba1c1784b94bfb26aa2307195c07c0b Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Date: Wed, 17 Oct 2012 13:42:06 +0200
Subject: [PATCH] cgroups: forbid pre_destroy callback to fail

Now that mem_cgroup_pre_destroy callback doesn't fail finally we can
safely move on and forbit all the callbacks to fail. The last missing
piece is moving cgroup_call_pre_destroy after cgroup_clear_css_refs so
that css_tryget fails so no new charges for the memcg can happen.
We cannot, however, move cgroup_call_pre_destroy right after because we
cannot call mem_cgroup_pre_destroy with the cgroup_lock held (see
3fa59dfb cgroup: fix potential deadlock in pre_destroy) so we have to
move it after the lock is released.

Changes since v1
- Li Zefan pointed out that mem_cgroup_pre_destroy cannot be called with
  cgroup_lock held

Signed-off-by: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
---
 kernel/cgroup.c |   30 +++++++++---------------------
 1 file changed, 9 insertions(+), 21 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index b7d9606..4c6adbd 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -855,7 +855,7 @@ static struct inode *cgroup_new_inode(umode_t mode, struct super_block *sb)
  * Call subsys's pre_destroy handler.
  * This is called before css refcnt check.
  */
-static int cgroup_call_pre_destroy(struct cgroup *cgrp)
+static void cgroup_call_pre_destroy(struct cgroup *cgrp)
 {
 	struct cgroup_subsys *ss;
 	int ret = 0;
@@ -864,15 +864,8 @@ static int cgroup_call_pre_destroy(struct cgroup *cgrp)
 		if (!ss->pre_destroy)
 			continue;
 
-		ret = ss->pre_destroy(cgrp);
-		if (ret) {
-			/* ->pre_destroy() failure is being deprecated */
-			WARN_ON_ONCE(!ss->__DEPRECATED_clear_css_refs);
-			break;
-		}
+		BUG_ON(ss->pre_destroy(cgrp));
 	}
-
-	return ret;
 }
 
 static void cgroup_diput(struct dentry *dentry, struct inode *inode)
@@ -4161,7 +4154,6 @@ again:
 		mutex_unlock(&cgroup_mutex);
 		return -EBUSY;
 	}
-	mutex_unlock(&cgroup_mutex);
 
 	/*
 	 * In general, subsystem has no css->refcnt after pre_destroy(). But
@@ -4174,17 +4166,6 @@ again:
 	 */
 	set_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
 
-	/*
-	 * Call pre_destroy handlers of subsys. Notify subsystems
-	 * that rmdir() request comes.
-	 */
-	ret = cgroup_call_pre_destroy(cgrp);
-	if (ret) {
-		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
-		return ret;
-	}
-
-	mutex_lock(&cgroup_mutex);
 	parent = cgrp->parent;
 	if (atomic_read(&cgrp->count) || !list_empty(&cgrp->children)) {
 		clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
@@ -4206,6 +4187,7 @@ again:
 			return -EINTR;
 		goto again;
 	}
+
 	/* NO css_tryget() can success after here. */
 	finish_wait(&cgroup_rmdir_waitq, &wait);
 	clear_bit(CGRP_WAIT_ON_RMDIR, &cgrp->flags);
@@ -4244,6 +4226,12 @@ again:
 	spin_unlock(&cgrp->event_list_lock);
 
 	mutex_unlock(&cgroup_mutex);
+
+	/*
+	 * Call pre_destroy handlers of subsys. Notify subsystems
+	 * that rmdir() request comes.
+	 */
+	cgroup_call_pre_destroy(cgrp);
 	return 0;
 }
 
-- 
1.7.10.4


-- 
Michal Hocko
SUSE Labs
