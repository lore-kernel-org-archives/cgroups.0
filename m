From: Vladimir Davydov <vdavydov@virtuozzo.com>
Subject: [PATCH v2 1/6] Revert "kernfs: do not account ino_ida allocations to memcg"
Date: Tue, 10 Nov 2015 21:34:02 +0300
Message-ID: <c468a2d2b39d755de2383c6ae49be6a53360a22b.1447172835.git.vdavydov@virtuozzo.com>
References: <cover.1447172835.git.vdavydov@virtuozzo.com>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
In-Reply-To: <cover.1447172835.git.vdavydov@virtuozzo.com>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Johannes Weiner <hannes@cmpxchg.org>, Michal Hocko <mhocko@kernel.org>, Tejun Heo <tj@kernel.org>, Greg Thelen <gthelen@google.com>, Christoph Lameter <cl@linux.com>, Pekka Enberg <penberg@kernel.org>, David Rientjes <rientjes@google.com>, Joonsoo Kim <iamjoonsoo.kim@lge.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org

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

Signed-off-by: Vladimir Davydov <vdavydov@virtuozzo.com>
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

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
