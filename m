From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [GIT PULL] cgroup fixes for v4.11-rc6
Date: Mon, 17 Apr 2017 00:33:28 +0900
Message-ID: <20170416153328.GA27786@wtj.duckdns.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=UgOkCwNVf7uVxFBAKY6OnQ2jZeVD190czUIHveDCZZM=;
        b=ko8lAc+zj5MNcjo7Yd7x+xdCd51q+MGyfMFEdhx0UmrDah+gNKJ84gFtidZb8y/P93
         ayYvypaZJgEmzh5G05lFHHVnpxKxmB5uXa8Slxb1u7vuNigh6Omvhx+0aWS21QoO5zg1
         EZIHZqP5PzO+QBxhJmy1e++yu6vg+VrrBjQy7RQ3GeabKzI8T+noFUBfHNCbmt7DyFJC
         b9U6+UqIWZhpqEZtjFsFqBlwOm2W98vij+qhDW2BHiEW+Ur17Cr5PJmbQ2Fr4mSHCoDP
         acmoh2BaDoQjvf6DL4QduB2FWm1/2AZ4Up1C4CyCgqU1gl/R58h/c26+hMzc4HNbMjRT
         PNIQ==
Content-Disposition: inline
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrei Vagin <avagin-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>

Hello, Linus.

Unfortunately, the commit to fix the cgroup mount race in the previous
pull request can lead to hangs.  The original bug has been around for
a while and isn't too likely to be triggered in usual use cases.
Revert the commit for now.

Thanks.

The following changes since commit bfb0b80db5f9dca5ac0a5fd0edb765ee555e5a8e:

  cgroup: avoid attaching a cgroup root to two different superblocks (2017-04-11 09:00:57 +0900)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tj/cgroup.git for-4.11-fixes

for you to fetch changes up to 330c418638612d7658b6314e6a244fcb5f7efac5:

  Revert "cgroup: avoid attaching a cgroup root to two different superblocks" (2017-04-16 23:17:37 +0900)

----------------------------------------------------------------
Tejun Heo (1):
      Revert "cgroup: avoid attaching a cgroup root to two different superblocks"

 kernel/cgroup/cgroup-v1.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
index 12e19f0..1dc22f6 100644
--- a/kernel/cgroup/cgroup-v1.c
+++ b/kernel/cgroup/cgroup-v1.c
@@ -1146,7 +1146,7 @@ struct dentry *cgroup1_mount(struct file_system_type *fs_type, int flags,
 		 * path is super cold.  Let's just sleep a bit and retry.
 		 */
 		pinned_sb = kernfs_pin_sb(root->kf_root, NULL);
-		if (IS_ERR_OR_NULL(pinned_sb) ||
+		if (IS_ERR(pinned_sb) ||
 		    !percpu_ref_tryget_live(&root->cgrp.self.refcnt)) {
 			mutex_unlock(&cgroup_mutex);
 			if (!IS_ERR_OR_NULL(pinned_sb))
