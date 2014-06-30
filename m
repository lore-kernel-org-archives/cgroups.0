From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: Re: [PATCH v3 3/3] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()
Date: Mon, 30 Jun 2014 10:19:46 -0400
Message-ID: <20140630141946.GC14807@htj.dyndns.org>
References: <53B0DE66.5080100@huawei.com>
 <53B0DEA3.80807@huawei.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=v1yZObVQF06oAWRLcvQUzfcng9tvB+JFqH4GTIhpfaU=;
        b=S9dhM37ToYRFVXJhnAEUX2HvEkRKnWVjZcyZGChkm6etzyQoHatkHL1sMpTjtNidWG
         wONBV2YRdFv9s6/b/V0nkYMzNU1CRI+WL5U1ccstw5j+0bAJzDqup4eSJp59Q/V5DOT5
         KqVcwqlHXDL76qgloPppW048IU0zVk1PxWUtucHoPoZ/ANmJKhMsOOEkBgXDHm4oMSYu
         Ojl2uor9TdywSIAkt0Q1GU3AV4BM4D+1vz0649t67Y7AoTJKccl1Edx0XOfFDcB+Ry11
         uoLQ42FxK4D2wxfl5slIZaE6zEj8BJbHSs91A5acdquvNyi4sUtej8u5rUx6S1AQvh2y
         l0Sg==
Content-Disposition: inline
In-Reply-To: <53B0DEA3.80807-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>

Applied to cgroup/for-3.16-fixes with minor updates.  Thanks.
------ 8< ------
From 3a32bd72d77058d768dbb38183ad517f720dd1bc Mon Sep 17 00:00:00 2001
From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Date: Mon, 30 Jun 2014 11:50:59 +0800
Subject: [PATCH 3/3] cgroup: fix a race between cgroup_mount() and
 cgroup_kill_sb()

We've converted cgroup to kernfs so cgroup won't be intertwined with
vfs objects and locking, but there are dark areas.

Run two instances of this script concurrently:

    for ((; ;))
    {
    	mount -t cgroup -o cpuacct xxx /cgroup
    	umount /cgroup
    }

After a while, I saw two mount processes were stuck at retrying, because
they were waiting for a subsystem to become free, but the root associated
with this subsystem never got freed.

This can happen, if thread A is in the process of killing superblock but
hasn't called percpu_ref_kill(), and at this time thread B is mounting
the same cgroup root and finds the root in the root list and performs
percpu_ref_try_get().

To fix this, we try to increase both the refcnt of the superblock and the
percpu refcnt of cgroup root.

v2:
- we should try to get both the superblock refcnt and cgroup_root refcnt,
  because cgroup_root may have no superblock assosiated with it.
- adjust/add comments.

tj: Updated comments.  Renamed @sb to @pinned_sb.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 3.15
Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 kernel/cgroup.c | 33 ++++++++++++++++++++++++++-------
 1 file changed, 26 insertions(+), 7 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 6406866..70776ae 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1648,6 +1648,7 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 			 int flags, const char *unused_dev_name,
 			 void *data)
 {
+	struct super_block *pinned_sb = NULL;
 	struct cgroup_subsys *ss;
 	struct cgroup_root *root;
 	struct cgroup_sb_opts opts;
@@ -1740,15 +1741,23 @@ static struct dentry *cgroup_mount(struct file_system_type *fs_type,
 		}
 
 		/*
-		 * A root's lifetime is governed by its root cgroup.
-		 * tryget_live failure indicate that the root is being
-		 * destroyed.  Wait for destruction to complete so that the
-		 * subsystems are free.  We can use wait_queue for the wait
-		 * but this path is super cold.  Let's just sleep for a bit
-		 * and retry.
+		 * We want to reuse @root whose lifetime is governed by its
+		 * ->cgrp.  Let's check whether @root is alive and keep it
+		 * that way.  As cgroup_kill_sb() can happen anytime, we
+		 * want to block it by pinning the sb so that @root doesn't
+		 * get killed before mount is complete.
+		 *
+		 * With the sb pinned, tryget_live can reliably indicate
+		 * whether @root can be reused.  If it's being killed,
+		 * drain it.  We can use wait_queue for the wait but this
+		 * path is super cold.  Let's just sleep a bit and retry.
 		 */
-		if (!percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
+		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
+		if (IS_ERR(pinned_sb) ||
+		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
+			if (!IS_ERR_OR_NULL(pinned_sb))
+				deactivate_super(pinned_sb);
 			msleep(10);
 			ret = restart_syscall();
 			goto out_free;
@@ -1793,6 +1802,16 @@ out_free:
 				CGROUP_SUPER_MAGIC, &new_sb);
 	if (IS_ERR(dentry) || !new_sb)
 		cgroup_put(&root->cgrp);
+
+	/*
+	 * If @pinned_sb, we're reusing an existing root and holding an
+	 * extra ref on its sb.  Mount is complete.  Put the extra ref.
+	 */
+	if (pinned_sb) {
+		WARN_ON(new_sb);
+		deactivate_super(pinned_sb);
+	}
+
 	return dentry;
 }
 
-- 
1.9.3
