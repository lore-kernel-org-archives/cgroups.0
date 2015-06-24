From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 1/7] blkcg: remove unnecessary request_list->blkg NULL test in blk_put_rl()
Date: Tue, 23 Jun 2015 22:44:07 -0400
Message-ID: <1435113853-12053-2-git-send-email-tj@kernel.org>
References: <1435113853-12053-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=M6jP2XSVrkSHxEPy5dc7/sCi/e+rA6uVkbv4m/EoD/8=;
        b=0MHAKG5ghybWGLQwUhTPBlAuN2tGp9LAnM5DH8j/hPQ71Wghetwji6kMXZGcQUQa2m
         XDGZzdvKhMH9mZnsEeZkZC+9JievU2VQ6rp1pnyiki5aaIB9PGLP18RMyN+XTnKPthXY
         GtMEODbITSLusWYZLSnUrtvCOUFdu787mnNWT4j/F4DjXUW97CKw02j+sv528E2/Ee/N
         VvLliaWg28TSvmX/YWrJPfkXkGOARB2jcOyhOyaCycyoVVqRx1NaBDbFABNJt1NBtTzY
         JA92+6eoLigmBQ3zMmD5YpLbtKISdTFO6tnn+MTt25yfdVSIQPT7W9xW/3IF3HuEWbyN
         vPZg==
In-Reply-To: <1435113853-12053-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, avanzini.arianna-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

Since ec13b1d6f0a0 ("blkcg: always create the blkcg_gq for the root
blkcg"), a request_list always has its blkg associated.  Drop
unnecessary rl->blkg NULL test from blk_put_rl().

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Vivek Goyal <vgoyal-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 include/linux/blk-cgroup.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/include/linux/blk-cgroup.h b/include/linux/blk-cgroup.h
index 07a32b8..50d1009 100644
--- a/include/linux/blk-cgroup.h
+++ b/include/linux/blk-cgroup.h
@@ -378,8 +378,7 @@ static inline struct request_list *blk_get_rl(struct request_queue *q,
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
