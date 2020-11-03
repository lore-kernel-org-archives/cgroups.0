From: Sasha Levin <sashal@kernel.org>
Subject: [PATCH AUTOSEL 5.8 16/29] blk-cgroup: Pre-allocate tree node on blkg_conf_prep
Date: Mon,  2 Nov 2020 20:19:15 -0500
Message-ID: <20201103011928.183145-16-sashal@kernel.org>
References: <20201103011928.183145-1-sashal@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604366389;
        bh=npmEKXMDcEvhL/w2179RDZgxEZSrrkFp4RwsrdkNqPw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kWzxpVSJu86DWbJpJt4PwL2KLyEiiCH3pS2d+1U92WzIxbZs8jjg/FVUAvMAxFB0K
         AzqrePRPlF6hqS1U5ub3c9Rm9JMCMkzNQWbk52SaaMBpHYfSAksZcDpumOo6V32WyJ
         9IuKjNJJvOFRzMFyRcPRfFY2RqJToqoSwIN14x28=
In-Reply-To: <20201103011928.183145-1-sashal@kernel.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Gabriel Krisman Bertazi <krisman@collabora.com>, Tejun Heo <tj@kernel.org>, Jens Axboe <axboe@kernel.dk>, Sasha Levin <sashal@kernel.org>, cgroups@vger.kernel.org, linux-block@vger.kernel.org

From: Gabriel Krisman Bertazi <krisman@collabora.com>

[ Upstream commit f255c19b3ab46d3cad3b1b2e1036f4c926cb1d0c ]

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

Acked-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Gabriel Krisman Bertazi <krisman@collabora.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 block/blk-cgroup.c | 14 ++++++++++++--
 1 file changed, 12 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 67619f4e24907..1cd0574b83bb2 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -676,6 +676,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			goto fail;
 		}
 
+		if (radix_tree_preload(GFP_KERNEL)) {
+			blkg_free(new_blkg);
+			ret = -ENOMEM;
+			goto fail;
+		}
+
 		rcu_read_lock();
 		spin_lock_irq(&q->queue_lock);
 
@@ -683,7 +689,7 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 		if (IS_ERR(blkg)) {
 			ret = PTR_ERR(blkg);
 			blkg_free(new_blkg);
-			goto fail_unlock;
+			goto fail_preloaded;
 		}
 
 		if (blkg) {
@@ -692,10 +698,12 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 			blkg = blkg_create(pos, q, new_blkg);
 			if (IS_ERR(blkg)) {
 				ret = PTR_ERR(blkg);
-				goto fail_unlock;
+				goto fail_preloaded;
 			}
 		}
 
+		radix_tree_preload_end();
+
 		if (pos == blkcg)
 			goto success;
 	}
@@ -705,6 +713,8 @@ int blkg_conf_prep(struct blkcg *blkcg, const struct blkcg_policy *pol,
 	ctx->body = input;
 	return 0;
 
+fail_preloaded:
+	radix_tree_preload_end();
 fail_unlock:
 	spin_unlock_irq(&q->queue_lock);
 	rcu_read_unlock();
-- 
2.27.0

