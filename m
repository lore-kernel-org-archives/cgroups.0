From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/7] blkcg: use blkg_free() in blkcg_init_queue() failure path
Date: Tue, 23 Jun 2015 22:44:08 -0400
Message-ID: <1435113853-12053-3-git-send-email-tj@kernel.org>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=G75LPLzg5g8AbQwMleS+XMITmvuAVP+js4TEsar9hww=;
        b=AklpLIT5ZdDdpVV/SyUhu1uObcA5nFk/i4ILv7XPC+1zGeG0klQbxPDGnO/UNSTrAK
         7/xCvyggUydG5pAuL7J4S3MFAxc91OioTXIUussR92DFmKi7A9VZQQQAuKwxQZNFRdit
         IMWFwgb+KAYAy0G8/CFgBuCEWsuz2AsOFjDr/LieIE4oA+UW6SweC8fQV5qvoDtdvf2h
         JH3QqcX63UyLBaP2D7XjERX0ILh/IKP6f4XP49cXT/unYJcepF51KZ/qJKIsnrdR1l+r
         NnwEYzDCDLU44wnmtckj96LOAGk+hPgC823l9egNAX3jjw1Co2s9kywNG5PgHtQ4fE1q
         jSWg==
In-Reply-To: <1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

When blkcg_init_queue() fails midway after creating a new blkg, it
performs kfree() directly; however, this doesn't free the policy data
areas.  Make it use blkg_free() instead.  In turn, blkg_free() is
updated to handle root request_list special case.

While this fixes a possible memory leak, it's on an unlikely failure
path of an already cold path and the size leaked per occurrence is
miniscule too.  I don't think it needs to be tagged for -stable.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 1fddbbd..898f560 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -57,7 +57,8 @@ static void blkg_free(struct blkcg_gq *blkg)
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		kfree(blkg->pd[i]);
 
-	blk_exit_rl(&blkg->rl);
+	if (blkg->blkcg != &blkcg_root)
+		blk_exit_rl(&blkg->rl);
 	kfree(blkg);
 }
 
@@ -886,7 +887,7 @@ int blkcg_init_queue(struct request_queue *q)
 		radix_tree_preload_end();
 
 	if (IS_ERR(blkg)) {
-		kfree(new_blkg);
+		blkg_free(new_blkg);
 		return PTR_ERR(blkg);
 	}
 
-- 
2.4.3
