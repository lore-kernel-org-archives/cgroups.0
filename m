From: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Subject: [PATCH 1/5] Revert "kernfs: do not account ino_ida allocations to memcg"
Date: Sat, 7 Nov 2015 23:07:05 +0300
Message-ID: <c468a2d2b39d755de2383c6ae49be6a53360a22b.1446924358.git.vdavydov@virtuozzo.com>
References: <cover.1446924358.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1446924358.git.vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Greg Thelen <gthelen-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

This reverts commit 499611ed451508a42d1d7d1faff10177827755d5.

Black-list kmem accounting policy (aka __GFP_NOACCOUNT) turned out to be
fragile and difficult to maintain, because there seem to be many more
allocations that should not be accounted than those that should be.
Besides, false accounting an allocation might result in much worse
consequences than not accounting at all, namely increased memory
consumption due to pinned dead kmem caches.

So it was decided to switch to the white-list policy. This patch reverts
bits introducing the black-list policy. The white-list policy will be
introduced later in the series.

Signed-off-by: Vladimir Davydov <vdavydov-5HdwGun5lf+gSpxsJD1C4w@public.gmane.org>
---
 fs/kernfs/dir.c | 9 +--------
 1 file changed, 1 insertion(+), 8 deletions(-)

diff --git a/fs/kernfs/dir.c b/fs/kernfs/dir.c
index 91e004518237..0239a0a76ed5 100644
--- a/fs/kernfs/dir.c
+++ b/fs/kernfs/dir.c
@@ -541,14 +541,7 @@ static struct kernfs_node *__kernfs_new_node(struct kernfs_root *root,
 	if (!kn)
 		goto err_out1;
 
-	/*
-	 * If the ino of the sysfs entry created for a kmem cache gets
-	 * allocated from an ida layer, which is accounted to the memcg that
-	 * owns the cache, the memcg will get pinned forever. So do not account
-	 * ino ida allocations.
-	 */
-	ret = ida_simple_get(&root->ino_ida, 1, 0,
-			     GFP_KERNEL | __GFP_NOACCOUNT);
+	ret = ida_simple_get(&root->ino_ida, 1, 0, GFP_KERNEL);
 	if (ret < 0)
 		goto err_out2;
 	kn->ino = ret;
-- 
2.1.4
