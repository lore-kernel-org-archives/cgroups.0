From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 3/7] blkcg: make blkcg_activate_policy() allow NULL ->pd_init_fn
Date: Tue,  7 Jul 2015 11:51:29 -0400
Message-ID: <1436284293-4666-4-git-send-email-tj@kernel.org>
References: <1436284293-4666-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Qxeo6Uo/6X/o6y+iPaMp9TnqTOBcnJh/BJiVvcN902c=;
        b=uZZ6sa5yzo4jXxeBKejp43ne3GcwnHknQ+fko2KYFwLbICtx5Dk4lONdYD4qjOT5E5
         K/e/5ZQ+USmnhRh2RuTQNWDFM7Y2eWzdgbCl/vwjpoO1AZHfXK6HmWgW3ix9/SsJY747
         4m4VAFK4OLeeY3jHT3nkA7Y+ggHko6+Xo7BSGu26kNWmFLDOYvhsV095sxe+EjJuHAaN
         v3bJrV74u0Bqe3iZk1E+NV0GMSdRQAOnDijl7WogsP/zMLqTgMJgAYOzwnSZZc6Hf6+r
         gHQUZFM/GKNuwpeth/aVOVUQXct/sqiR9BXq1Vw/48a8JkYmREkfq48sNDsKc9V/U4I6
         eILQ==
In-Reply-To: <1436284293-4666-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

blkg_create() allows NULL ->pd_init_fn() but blkcg_activate_policy()
doesn't.  As both in-kernel policies implement ->pd_init_fn, it
currently doesn't break anything.  Update blkcg_activate_policy() so
that its behavior is consistent with blkg_create().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 block/blk-cgroup.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/block/blk-cgroup.c b/block/blk-cgroup.c
index 73209a8..e16d1dc 100644
--- a/block/blk-cgroup.c
+++ b/block/blk-cgroup.c
@@ -1112,7 +1112,8 @@ int blkcg_activate_policy(struct request_queue *q,
 		blkg->pd[pol->plid] = pd;
 		pd->blkg = blkg;
 		pd->plid = pol->plid;
-		pol->pd_init_fn(blkg);
+		if (pol->pd_init_fn)
+			pol->pd_init_fn(blkg);
 
 		spin_unlock(&blkg->blkcg->lock);
 	}
-- 
2.4.3
