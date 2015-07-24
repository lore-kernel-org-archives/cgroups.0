From: Tejun Heo <tj@kernel.org>
Subject: [PATCH 03/10] blkcg: remove unnecessary NULL checks from __cfqg_set_weight_device()
Date: Fri, 24 Jul 2015 14:43:47 -0400
Message-ID: <1437763434-28699-4-git-send-email-tj@kernel.org>
References: <1437763434-28699-1-git-send-email-tj@kernel.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=jm+f8Wol5YC3eCsiD1IlnFjJzkLh6BgeT86yDfsDiO0=;
        b=WY0ib5CWUtEBFk1b+NCzWMNWWRYOYVXlZfX+gSEBewYpefNEq4xj12wpYPCympa66G
         ZCunRiOAMOHfL0C7NgFxppY2HO9nyioCxi/P7weUzex2HC7LXwBWV2+RtBvSBmyAe1FA
         kSIQjY4fIb7zqIjfBZSqOCYR4R2ElsLctvch+PddItN3FUc84OMpOAF2tyA09opr/swr
         U8F/gA62eRU5vBVTRZP6FeCOC95XxRuOqkSuv1E1h2+VQPr4iY+3HKmUnptCJ8IJ1e6g
         rRcYRFOLGZSVRFiGVhxCo1lmt7EZRC9pcHoFbt1TsefizyvPc9O3+cmBY7EXUjUd0DcQ
         7/cw==
In-Reply-To: <1437763434-28699-1-git-send-email-tj@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe@kernel.dk
Cc: vgoyal@redhat.com, linux-kernel@vger.kernel.org, avanzini.arianna@gmail.com, kernel-team@fb.com, hannes@cmpxchg.org, lizefan@huawei.com, cgroups@vger.kernel.org, Tejun Heo <tj@kernel.org>

blkg_to_cfqg() and blkcg_to_cfqgd() on a valid blkg with the policy
enabled are guaranteed to return non-NULL and the counterpart in
blk-throttle doesn't have these checks either.  Remove the spurious
NULL checks.

Signed-off-by: Tejun Heo <tj@kernel.org>
---
 block/cfq-iosched.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/block/cfq-iosched.c b/block/cfq-iosched.c
index 395476a..bcf4026 100644
--- a/block/cfq-iosched.c
+++ b/block/cfq-iosched.c
@@ -1752,12 +1752,10 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 	if (ret)
 		return ret;
 
-	ret = -EINVAL;
 	cfqg = blkg_to_cfqg(ctx.blkg);
 	cfqgd = blkcg_to_cfqgd(blkcg);
-	if (!cfqg || !cfqgd)
-		goto err;
 
+	ret = -EINVAL;
 	if (!ctx.v || (ctx.v >= CFQ_WEIGHT_MIN && ctx.v <= CFQ_WEIGHT_MAX)) {
 		if (!is_leaf_weight) {
 			cfqg->dev_weight = ctx.v;
@@ -1769,7 +1767,6 @@ static ssize_t __cfqg_set_weight_device(struct kernfs_open_file *of,
 		ret = 0;
 	}
 
-err:
 	blkg_conf_finish(&ctx);
 	return ret ?: nbytes;
 }
-- 
2.4.3
