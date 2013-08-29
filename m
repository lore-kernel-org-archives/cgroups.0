From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH cgroup/for-3.11-fixes] cgroup: fix rmdir EBUSY regression in
 3.11
Date: Thu, 29 Aug 2013 11:42:34 -0400
Message-ID: <20130829154234.GA23531@htj.dyndns.org>
References: <alpine.LNX.2.00.1308281624430.1266@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=gsAUwIHspbA2rOv1+NENqSM82vr5vQtWTdzvELVhd+8=;
        b=BNLaBUPzO0ohEIg3iffE8PmHBxGE2lB033dd4i+gr2D+5GmyJXhWuGiWYD7CDJwoQE
         pfX4yGNz24JBelrk+A4KmPiBMS6JNkYVNycXVLKSAF2A0pB+wosmNfXdQTJsvs20H0Pn
         x4LFJ4/GrHrKelcNPhsLaiRUjHCj+VCHrqa3GGClKrZjh/HqGzpc9N8OLijuLVZcG53C
         k2n/3uFFDwFakloZLVlg+2oyOtLrYdVyWBN9UxVQD/hv2KbpX+j/Nu9OvSWIIlxJc7vZ
         Lrt5OQBdRotFeBV3rpf/igdO2P/+sgyZFhlC36gGBEl7jOEGGhApN2eOMsqRwX0QnUxs
         YxcQ==
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1308281624430.1266-fupSdm12i1nKWymIFiNcPA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

Hello, Hugh.

Oops, sorry about that.  I massaged the patch a bit and applied it to
cgroup/for-3.11-fixes.  Will send pull request to Linus right away.

Thanks.
------ 8< ------
From bb78a92f47696b2da49f2692b6a9fa56d07c444a Mon Sep 17 00:00:00 2001
From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Date: Wed, 28 Aug 2013 16:31:23 -0700

On 3.11-rc we are seeing cgroup directories left behind when they should
have been removed.  Here's a trivial reproducer:

cd /sys/fs/cgroup/memory
mkdir parent parent/child; rmdir parent/child parent
rmdir: failed to remove `parent': Device or resource busy

It's because cgroup_destroy_locked() (step 1 of destruction) leaves
cgroup on parent's children list, letting cgroup_offline_fn() (step 2 of
destruction) remove it; but step 2 is run by work queue, which may not
yet have removed the children when parent destruction checks the list.

Fix that by checking through a non-empty list of children: if every one
of them has already been marked CGRP_DEAD, then it's safe to proceed:
those children are invisible to userspace, and should not obstruct rmdir.

(I didn't see any reason to keep the cgrp->children checks under the
unrelated css_set_lock, so moved them out.)

tj: Flattened nested ifs a bit and updated comment so that it's
    correct on both for-3.11-fixes and for-3.12.

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 19 ++++++++++++++++++-
 1 file changed, 18 insertions(+), 1 deletion(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 781845a..e919633 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -4480,6 +4480,7 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	struct dentry *d = cgrp->dentry;
 	struct cgroup_event *event, *tmp;
 	struct cgroup_subsys *ss;
+	struct cgroup *child;
 	bool empty;
 
 	lockdep_assert_held(&d->d_inode->i_mutex);
@@ -4490,12 +4491,28 @@ static int cgroup_destroy_locked(struct cgroup *cgrp)
 	 * @cgrp from being removed while __put_css_set() is in progress.
 	 */
 	read_lock(&css_set_lock);
-	empty = list_empty(&cgrp->cset_links) && list_empty(&cgrp->children);
+	empty = list_empty(&cgrp->cset_links);
 	read_unlock(&css_set_lock);
 	if (!empty)
 		return -EBUSY;
 
 	/*
+	 * Make sure there's no live children.  We can't test ->children
+	 * emptiness as dead children linger on it while being destroyed;
+	 * otherwise, "rmdir parent/child parent" may fail with -EBUSY.
+	 */
+	empty = true;
+	rcu_read_lock();
+	list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+		empty = cgroup_is_dead(child);
+		if (!empty)
+			break;
+	}
+	rcu_read_unlock();
+	if (!empty)
+		return -EBUSY;
+
+	/*
 	 * Block new css_tryget() by killing css refcnts.  cgroup core
 	 * guarantees that, by the time ->css_offline() is invoked, no new
 	 * css reference will be given out via css_tryget().  We can't
-- 
1.8.3.1
