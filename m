From: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] cgroup: remove bind() method from cgroup_subsys.
Date: Wed, 10 Apr 2013 14:41:17 +0300
Message-ID: <1365594077-17655-1-git-send-email-ramirose@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=x-received:from:to:cc:subject:date:message-id:x-mailer;
        bh=Tdnh0b9iUzmhTXEOhVkmDal+eLxXLQGhd4FrVj0mt9I=;
        b=PW3FjrXHaFM2fQFWk1dDmB2FrTcC6X9Ekf10zW8/CDgV/u91h8CekYqdgX5ut31K9x
         fxVrCU+jMOtPil7EGXj9RGbtb3pdIAKzVBNk32W/W3iJZ5FElT3DG6IBtDRv4sn0n1MU
         FMcfgIrwaL8QTnnO7oqPLTxACj/hsqqBvcvblgWxA/ziJG04eqlSjx1hqOksXqNu4DVK
         AmWjaEkiQHatEhWpDp5xfh7NnTziknnTTZuA9HhF7i8WUgrB2fNn7xBgGgIHLXzfvjJW
         plPO4skd879PSE53SnUtLlcauK01WRF0ejEbl8pjAvQc8GY7fXjwBP6LjE6kFhhSnX0L
         sADg==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

The bind() method of cgroup_subsys is not used in any of the controllers
(cpuset, freezer, blkio, net_cls, memcg, net_prio, devices, perf, hugetlb, 
cpu and cpuacct)

Signed-off-by: Rami Rosen <ramirose-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/cgroup.h | 2 --
 kernel/cgroup.c        | 4 ----
 2 files changed, 6 deletions(-)

diff --git a/include/linux/cgroup.h b/include/linux/cgroup.h
index 515927e..92acf86 100644
--- a/include/linux/cgroup.h
+++ b/include/linux/cgroup.h
@@ -483,8 +483,6 @@ struct cgroup_subsys {
 	void (*fork)(struct task_struct *task);
 	void (*exit)(struct cgroup *cgrp, struct cgroup *old_cgrp,
 		     struct task_struct *task);
-	void (*bind)(struct cgroup *root);
-
 	int subsys_id;
 	int active;
 	int disabled;
diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index ba3e24a..fd38e1c 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1064,16 +1064,12 @@ static int rebind_subsystems(struct cgroupfs_root *root,
 			cgrp->subsys[i]->cgroup = cgrp;
 			list_move(&ss->sibling, &root->subsys_list);
 			ss->root = root;
-			if (ss->bind)
-				ss->bind(cgrp);
 			/* refcount was already taken, and we're keeping it */
 		} else if (bit & removed_mask) {
 			/* We're removing this subsystem */
 			BUG_ON(ss == NULL);
 			BUG_ON(cgrp->subsys[i] != dummytop->subsys[i]);
 			BUG_ON(cgrp->subsys[i]->cgroup != cgrp);
-			if (ss->bind)
-				ss->bind(dummytop);
 			dummytop->subsys[i]->cgroup = dummytop;
 			cgrp->subsys[i] = NULL;
 			subsys[i]->root = &rootnode;
-- 
1.8.1.4
