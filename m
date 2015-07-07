From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/7] blkcg: remove unnecessary request_list->blkg NULL test in blk_put_rl()
Date: Tue,  7 Jul 2015 11:51:27 -0400
Message-ID: <1436284293-4666-2-git-send-email-tj@kernel.org>
References: <1436284293-4666-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S+VHoy+GdIM0wa0hBMUNnoO0G+JVbTGGBdwR8o8OKZg=;
        b=orxqQfVVATL0D1w2dqf9+kvc6JStfJxK3+LAgMHVUyhjhPROFCyz6WAlaHQENwZOyS
         bRy3tiXt8Ik8eKKG7M/BPC0g8GPocDhajwpsN+EtIcd53qJG0SRy7F+fboQxUpOffNRZ
         3RAggoeHO0B7qJAQZs7a/d/jEFUIAWt60mKFp9CEDDL9Qi6BUiezzIZh0eJPnqhnC3Sx
         DVieLPn2L1vMmZD0jX1eO/bOsPnZCLIcMkyzXcJH0VQbKmHdz9HRo2R6I/kJGD5sHE2P
         9Z5TBThVTpnWusjKvDELnEVhKYPb1NouBrmc51d+Usbeip+CQ9kvP9DwP/2VIzZFX/r0
         UbJA==
In-Reply-To: <1436284293-4666-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: jack-AlSwsSmVLrQ@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Since ec13b1d6f0a0 ("blkcg: always create the blkcg_gq for the root
blkcg"), a request_list always has its blkg associated.  Drop
unnecessary rl->blkg NULL test from blk_put_rl().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/blk-cgroup.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 58cfab8..2e41f8c 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -399,8 +399,7 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
  */
 static inline void blk_put_rl(struct request_list *rl)
 {
-	/* root_rl may not have blkg set */
-	if (rl->blkg && rl->blkg->blkcg != &blkcg_root)
+	if (rl->blkg->blkcg != &blkcg_root)
 		blkg_put(rl->blkg);
 }
 
-- 
2.4.3
