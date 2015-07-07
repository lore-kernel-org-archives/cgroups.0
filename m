From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 2/7] blkcg: use blkg_free() in blkcg_init_queue() failure path
Date: Tue,  7 Jul 2015 11:51:28 -0400
Message-ID: <1436284293-4666-3-git-send-email-tj@kernel.org>
References: <1436284293-4666-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Z8rZ5wFLfmGy58PSMH5NOxdlL25NEvnh5TQvUereVq8=;
        b=esk71J3V3UxV0TMXNeOwkXimILIs9YtwpqeI/Efd+xPBuhbyr9Ag7tpokDY0j5s0k9
         kX+cmb7NhVJ3jIY4la+Lk5XTekoebR2C0ZwuRg7nxJ/4Qqc1EjyGdrDmniZp6IxvK6mt
         ovm8Aixm6ndNBiFUYIQf6OuWTlzPpoaWRrf+rrOkVABkrdGh5AQp55XNAH+3ZQf/byj6
         Bw8giAEP0dfX5UFHjHBBJ7vjE8mi9R5UBZndoLMccyc97Axpu0rYOKMR7KVCJXtEB4u5
         Ft39O0C1KV4Uv7eaRHhxpzUOakuc1xIaBEpF7Ifbbtwx2mJmmta8Gb8B9vvDuTdfLY4/
         1fdg==
In-Reply-To: <1436284293-4666-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

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
index dacd95d..73209a8 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -60,7 +60,8 @@ static void blkg_free(struct blkcg_gq *blkg)
 	for (i = 0; i < BLKCG_MAX_POLS; i++)
 		kfree(blkg->pd[i]);
 
-	blk_exit_rl(&blkg->rl);
+	if (blkg->blkcg != &blkcg_root)
+		blk_exit_rl(&blkg->rl);
 	kfree(blkg);
 }
 
@@ -923,7 +924,7 @@ int blkcg_init_queue(struct request_queue *q)
 		radix_tree_preload_end();
 
 	if (IS_ERR(blkg)) {
-		kfree(new_blkg);
+		blkg_free(new_blkg);
 		return PTR_ERR(blkg);
 	}
 
-- 
2.4.3
