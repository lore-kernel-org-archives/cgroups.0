From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH UPDATED 02/11] blkcg: __blkg_lookup_create() doesn't need
 radix preload
Date: Fri, 27 Apr 2012 14:18:27 -0700
Message-ID: <20120427211827.GQ26595@google.com>
References: <1335477561-11131-1-git-send-email-tj@kernel.org>
 <1335477561-11131-3-git-send-email-tj@kernel.org>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        bh=FCv7L0yrQAB2gdp+1kvROyBY7qxw9bqGfvmr5JtQoL0=;
        b=Q0ZYA/8zQHdFh4At9UqFrOiZgL5ibF/h558UpCN8cs5ivx0Z6vQTSqJHpxBv/kW4Hg
         2aTD9Z5YZoeMhoA0KWd7GAiMCc30djQI1UGG0yvdOflQXbKD3Bqht3NM69xWyeLkzJiI
         KHSdJAfac3Txj1QpvqOktD0JaxKfhNdjkPjmGAf9BUo96EBD0Z3pZw0j3aM63EcEP7TD
         dC3l7A8drPqp5uy/2vh+lhAbnbGBWQCQvibiMq8/N8bUVVCkVi+5KanBD/uJOt223EI4
         BPR+7lJOzuHzHfPNsB5WjPIHtgNsNYPwrpG0kXfqSiJgA9BhibHFKis9LzgRZGXbWtm2
         XRnA==
Content-Disposition: inline
In-Reply-To: <1335477561-11131-3-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, ctalbott-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, rni-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, containers-cunTk1MwBs9QetFLy7KEm3xJsTq8ys+cHZ5vskTnxNA@public.gmane.org, fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hughd-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org

There's no point in calling radix_tree_preload() if preloading doesn't
use more permissible GFP mask.  Drop preloading from
__blkg_lookup_create().

While at it, drop sparse locking annotation which no longer applies.

v2: Vivek pointed out the odd preload usage.  Instead of updating,
    just drop it.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
We don't need preloading at all.  Just drop it.  git branch updated
accordingly.  All patches apply as-is.

Thanks.

 block/blk-cgroup.c |   10 +---------
 1 files changed, 1 insertions(+), 9 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 4ab7420..af61db0 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -177,7 +177,6 @@ EXPORT_SYMBOL_GPL(blkg_lookup);
 
 static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 					     struct request_queue *q)
-	__releases(q->queue_lock) __acquires(q->queue_lock)
 {
 	struct blkcg_gq *blkg;
 	int ret;
@@ -203,10 +202,6 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 		goto err_put;
 
 	/* insert */
-	ret = radix_tree_preload(GFP_ATOMIC);
-	if (ret)
-		goto err_free;
-
 	spin_lock(&blkcg->lock);
 	ret = radix_tree_insert(&blkcg->blkg_tree, q->id, blkg);
 	if (likely(!ret)) {
@@ -215,14 +210,11 @@ static struct blkcg_gq *__blkg_lookup_create(struct blkcg *blkcg,
 	}
 	spin_unlock(&blkcg->lock);
 
-	radix_tree_preload_end();
-
 	if (!ret)
 		return blkg;
-err_free:
-	blkg_free(blkg);
 err_put:
 	css_put(&blkcg->css);
+	blkg_free(blkg);
 	return ERR_PTR(ret);
 }
 
-- 
1.7.7.3
