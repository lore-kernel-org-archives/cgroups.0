From: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] cgroup: fix top cgroup refcnt leak
Date: Fri, 14 Feb 2014 17:36:19 +0800
Message-ID: <52FDE393.6050607@huawei.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Cgroups <cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>

If we mount the same cgroupfs in serveral mount points, and then
umount all of them, kill_sb() will be called only once.

Therefore it's wrong to increment top_cgroup's refcnt when we find
an existing cgroup_root.

Try:
	# mount -t cgroup -o cpuacct xxx /cgroup
	# mount -t cgroup -o cpuacct xxx /cgroup2
	# cat /proc/cgroups | grep cpuacct
	cpuacct 2       1       1
	# umount /cgroup
	# umount /cgroup2
	# cat /proc/cgroups | grep cpuacct
	cpuacct 2       1       1

You'll see cgroupfs will never be freed.

Also move this chunk of code upwards.

Signed-off-by: Li Zefan <lizefan-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 kernel/cgroup.c | 32 ++++++++++++++++----------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/kernel/cgroup.c b/kernel/cgroup.c
index 37d94a2..5bfe738 100644
--- a/kernel/cgroup.c
+++ b/kernel/cgroup.c
@@ -1498,6 +1498,22 @@ retry:
 		bool name_match = false;
 
 		/*
+		 * A root's lifetime is governed by its top cgroup.  Zero
+		 * ref indicate that the root is being destroyed.  Wait for
+		 * destruction to complete so that the subsystems are free.
+		 * We can use wait_queue for the wait but this path is
+		 * super cold.  Let's just sleep for a bit and retry.
+		 */
+		if (!atomic_read(&root->top_cgroup.refcnt)) {
+			mutex_unlock(&cgroup_mutex);
+			mutex_unlock(&cgroup_tree_mutex);
+			kfree(opts.release_agent);
+			kfree(opts.name);
+			msleep(10);
+			goto retry;
+		}
+
+		/*
 		 * If we asked for a name then it must match.  Also, if
 		 * name matches but sybsys_mask doesn't, we should fail.
 		 * Remember whether name matched.
@@ -1530,22 +1546,6 @@ retry:
 			}
 		}
 
-		/*
-		 * A root's lifetime is governed by its top cgroup.  Zero
-		 * ref indicate that the root is being destroyed.  Wait for
-		 * destruction to complete so that the subsystems are free.
-		 * We can use wait_queue for the wait but this path is
-		 * super cold.  Let's just sleep for a bit and retry.
-		 */
-		if (!atomic_inc_not_zero(&root->top_cgroup.refcnt)) {
-			mutex_unlock(&cgroup_mutex);
-			mutex_unlock(&cgroup_tree_mutex);
-			kfree(opts.release_agent);
-			kfree(opts.name);
-			msleep(10);
-			goto retry;
-		}
-
 		ret = 0;
 		goto out_unlock;
 	}
-- 
1.8.0.2
