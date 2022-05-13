From: Yahu Gao <gaoyahu19-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] block,iocost: fix potential kernel NULL
Date: Fri, 13 May 2022 22:59:28 +0800
Message-ID: <20220513145928.29766-2-gaoyahu19@gmail.com>
References: <20220513145928.29766-1-gaoyahu19@gmail.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=L6n+4dfll/BRetr32yeP/ERgzE6Vl2zW43Zw49sqvUE=;
        b=hnYXjKWw+87VL85SaN68rpIkMD9dCJnWQWKiMcWhIGGUu4WsnUKCWaRNmGQwUTj6XF
         7GMMIyIetdkFWw+LSKsbtqEVp0G7o9Rhwz5e5wipdEpIfSH8wMoCN0VtYEFx6kwpKY4c
         9vxJIt6CnuZNA4J3AR+FHs2Kly6vpvXwOwVsMcuhrO4po39rjEETXmriLaYAfGLokvvS
         bYv4rJMoEGTQX+uzgMEJ98GSwyaI5fTbUqzxqDmUBaRw/rGW8+a9+PWvk+0eX6CNYr22
         +IiGF82f4IrjiLG20M2yO23egnCmhbTOaBWWL7O/mPs5Vj3sMOKv6FC7w4+R4Ph3sFse
         qh0Q==
In-Reply-To: <20220513145928.29766-1-gaoyahu19-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yahu Gao <yahugao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>, Kunhai Dai <daikunhai-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>

From: Yahu Gao <yahugao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>

Some inode pinned dying memory cgroup and its parent destroyed at first.
The parent's pd of iocost won't be allocated during function
blkcg_activate_policy.
Ignore the DYING CSS to avoid kernel NULL during iocost policy data init.

Signed-off-by: Yahu Gao <yahugao-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>
Signed-off-by: Kunhai Dai <daikunhai-+mmu7dyatJ+Rq8AjE7tl8g@public.gmane.org>

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index a91f8ae18b49..32472de2e61d 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1418,6 +1418,9 @@ int blkcg_activate_policy(struct request_queue *q,
 	list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
 		struct blkg_policy_data *pd;
 
+		if (blkg->blkcg->css.flags & CSS_DYING)
+			continue;
+
 		if (blkg->pd[pol->plid])
 			continue;
 
@@ -1459,8 +1462,11 @@ int blkcg_activate_policy(struct request_queue *q,
 
 	/* all allocated, init in the same order */
 	if (pol->pd_init_fn)
-		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node)
+		list_for_each_entry_reverse(blkg, &q->blkg_list, q_node) {
+			if (blkg->blkcg->css.flags & CSS_DYING)
+				continue;
 			pol->pd_init_fn(blkg->pd[pol->plid]);
+		}
 
 	__set_bit(pol->plid, q->blkcg_pols);
 	ret = 0;
-- 
2.30.1
