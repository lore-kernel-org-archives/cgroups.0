From: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
Subject: [PATCH] blk-cgroup: Pre-allocate tree node on blkg_conf_prep
Date: Thu, 22 Oct 2020 14:29:45 -0400
Message-ID: <20201022182945.1679730-1-krisman@collabora.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, khazhy-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>, kernel-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org

Similarly to commit 457e490f2b741 ("blkcg: allocate struct blkcg_gq
outside request queue spinlock"), blkg_create can also trigger
occasional -ENOMEM failures at the radix insertion because any
allocation inside blkg_create has to be non-blocking, making it more
likely to fail.  This causes trouble for userspace tools trying to
configure io weights who need to deal with this condition.

This patch reduces the occurrence of -ENOMEMs on this path by preloading
the radix tree element on a GFP_KERNEL context, such that we guarantee
the later non-blocking insertion won't fail.

A similar solution exists in blkcg_init_queue for the same situation.

Signed-off-by: Gabriel Krisman Bertazi <krisman-ZGY8ohtN/8qB+jHODAdFcQ@public.gmane.org>
---
 block/blk-cgroup.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index f9b55614d67d..bbf848604089 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -612,6 +612,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	struct gendisk *disk;
 	struct request_queue *q;
 	struct blkcg_gq *blkg;
+	bool preloaded = false;
 	int ret;
 
 	disk = blkcg_conf_get_disk(&input);
@@ -657,6 +658,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail;
 		}
 
+		preloaded = !radix_tree_preload(GFP_KERNEL);
+
 		rcu_read_lock();
 		spin_lock_irq(&q->queue_lock);
 
@@ -676,6 +679,9 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			}
 		}
 
+		if (preloaded)
+			radix_tree_preload_end();
+
 		if (pos == blkcg)
 			goto success;
 	}
@@ -688,6 +694,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 fail_unlock:
 	spin_unlock_irq(&q->queue_lock);
 	rcu_read_unlock();
+	if (preloaded)
+		radix_tree_preload_end();
 fail:
 	put_disk_and_module(disk);
 	/*
-- 
2.28.0

