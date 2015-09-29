From: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH 4/5] writeback: memcg dirty_throttle_control should be initialized with wb->memcg_completions
Date: Tue, 29 Sep 2015 12:47:53 -0400
Message-ID: <1443545274-18787-5-git-send-email-tj@kernel.org>
References: <1443545274-18787-1-git-send-email-tj@kernel.org>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=sender:from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=3R0aoVF9+puumpNz9vp7fGvtyDhyoRAMhOHoKEN0AxQ=;
        b=L6YN0CkphgKxWUOiTZxzNGBZnBBSJrYwAZkQYmWkvS3qo2kh+xijr2sK0zZjECXc8U
         UUx5yak2W/xeazlXFES7Dx8yduLQbE70VFNkDC/2S29lxKxDWcB8krbjtTL9/O4nY5DB
         bfd9rHrsnfm5Q0urNst5SZGpAIQ7ImgYu6FqHiB65RZ23SO8a9QKC+nSiBlMQBXcgbfF
         cfHz1JMoxqpvZNE+GWzsdhKfzdRtXETnrSEuLBQbQSkKx12gEspy2OvaD6bKI+nH297C
         SeCbIJWbTLwMjwicudmJNhAhWp3DGR1KfqZ43HaEDPH5W9VevY5zPsz8n9FbH6NoFRki
         uUtQ==
In-Reply-To: <1443545274-18787-1-git-send-email-tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, tytso-3s7WtUTddSA@public.gmane.org, dedekind1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, decui-0li6OtcxBFHby3iVrkZq2A@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org, Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>

MDTC_INIT() is used to initialize dirty_throttle_control for memcg
domains.  It used DTC_INIT_COMMON() to initialized mdtc->wb and
->wb_completions which is incorrect as DTC_INIT_COMMON() sets the
latter to wb->completions instead of wb->memcg_completions.  This can
lead to wildly incorrect results when calculating the proportion of
dirty memory the memcg domain should get.

Remove DTC_INIT_COMMON() and update MDTC_INIT() to initialize
mdtc->wb_completions to wb->memcg_completions.

Signed-off-by: Tejun Heo <tj-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Fixes: c2aa723a6093 ("writeback: implement memcg writeback domain based throttling")
---
 mm/page-writeback.c | 20 +++++++++++---------
 1 file changed, 11 insertions(+), 9 deletions(-)

diff --git a/mm/page-writeback.c b/mm/page-writeback.c
index 0f1a94e..56c0bff 100644
--- a/mm/page-writeback.c
+++ b/mm/page-writeback.c
@@ -145,9 +145,6 @@ struct dirty_throttle_control {
 	unsigned long		pos_ratio;
 };
 
-#define DTC_INIT_COMMON(__wb)	.wb = (__wb),				\
-				.wb_completions = &(__wb)->completions
-
 /*
  * Length of period for aging writeout fractions of bdis. This is an
  * arbitrarily chosen number. The longer the period, the slower fractions will
@@ -157,12 +154,16 @@ struct dirty_throttle_control {
 
 #ifdef CONFIG_CGROUP_WRITEBACK
 
-#define GDTC_INIT(__wb)		.dom = &global_wb_domain,		\
-				DTC_INIT_COMMON(__wb)
+#define GDTC_INIT(__wb)		.wb = (__wb),				\
+				.dom = &global_wb_domain,		\
+				.wb_completions = &(__wb)->completions
+
 #define GDTC_INIT_NO_WB		.dom = &global_wb_domain
-#define MDTC_INIT(__wb, __gdtc)	.dom = mem_cgroup_wb_domain(__wb),	\
-				.gdtc = __gdtc,				\
-				DTC_INIT_COMMON(__wb)
+
+#define MDTC_INIT(__wb, __gdtc)	.wb = (__wb),				\
+				.dom = mem_cgroup_wb_domain(__wb),	\
+				.wb_completions = &(__wb)->memcg_completions, \
+				.gdtc = __gdtc
 
 static bool mdtc_valid(struct dirty_throttle_control *dtc)
 {
@@ -213,7 +214,8 @@ static void wb_min_max_ratio(struct bdi_writeback *wb,
 
 #else	/* CONFIG_CGROUP_WRITEBACK */
 
-#define GDTC_INIT(__wb)		DTC_INIT_COMMON(__wb)
+#define GDTC_INIT(__wb)		.wb = (__wb),                           \
+				.wb_completions = &(__wb)->completions
 #define GDTC_INIT_NO_WB
 #define MDTC_INIT(__wb, __gdtc)
 
-- 
2.4.3
