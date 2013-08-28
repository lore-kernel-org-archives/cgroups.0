From: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix rmdir EBUSY regression in 3.11
Date: Wed, 28 Aug 2013 16:31:23 -0700 (PDT)
Message-ID: <alpine.LNX.2.00.1308281624430.1266@eggly.anvils>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20120113;
        h=date:from:to:cc:subject:message-id:user-agent:mime-version
         :content-type;
        bh=qeuXusKo8+NDpXr0Yy64PHLH3I1OFl8/miQoBkiXWlQ=;
        b=OP9qy1JCOtuRZs5w6JsqgzmTKLt5MnC2hs3EyAZhLlUvmJbnMe/e3aNxRSh/We0iBn
         94Ve40Mz9wLh6QI6rImMlFmi5F7HItZV8TqVZioml01OpifwUmD7qYLsBL60FT18usLw
         PMcZKjI5hiTy8FSgIPk88Dra2qFaDtr3XU4Nkb+Oa9UN2aBMZzwisaKFWqDSNhwix2cN
         P0RdmcSWXaDB/gC3mhkL1+OgF9H50WPMW7m/bsviUfVcaTzwWXLjQ0V2O9leGmSyiO0n
         jftYesaQC7z3Vyg7q7jyZmh7KKQZcGeeU6p6iEKDCP8K0uYhMt/McuH6VQpRMRRF2Sel
         DPHw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: TEXT/PLAIN; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

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

Signed-off-by: Hugh Dickins <hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>
---

 kernel/cgroup.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- 3.11-rc7/kernel/cgroup.c	2013-08-11 23:38:33.096579188 -0700
+++ linux/kernel/cgroup.c	2013-08-28 15:44:06.952564071 -0700
@@ -4490,8 +4490,23 @@ static int cgroup_destroy_locked(struct
 	 * @cgrp from being removed while __put_css_set() is in progress.
 	 */
 	read_lock(&css_set_lock);
-	empty = list_empty(&cgrp->cset_links) && list_empty(&cgrp->children);
+	empty = list_empty(&cgrp->cset_links);
 	read_unlock(&css_set_lock);
+
+	if (empty && !list_empty(&cgrp->children)) {
+		struct cgroup *child;
+		/*
+		 * We need "rmdir parent/child parent" to succeed,
+		 * but our children may not have reached step 2 yet.
+		 */
+		rcu_read_lock();
+		list_for_each_entry_rcu(child, &cgrp->children, sibling) {
+			empty = cgroup_is_dead(child);
+			if (!empty)
+				break;
+		}
+		rcu_read_unlock();
+	}
 	if (!empty)
 		return -EBUSY;
 
