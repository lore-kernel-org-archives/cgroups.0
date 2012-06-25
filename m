From: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v4 1/2] memcg: cleanup useless LRU_ALL_EVICTABLE
Date: Mon, 25 Jun 2012 19:15:34 +0800
Message-ID: <1340622934-13091-1-git-send-email-liwp.linux@gmail.com>
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20120113;
        h=from:to:cc:subject:date:message-id:x-mailer;
        bh=UWs78B+d39xsngFA/KujcHIvQ8UCl/EaTr1CpHyLaDI=;
        b=mCNIpdPIz08TGEepk6CpSlccSC7q5S/yVcIuf5R212O8UIRZ8iHMfejl5Hgu0Br6yU
         FnxW9JItfUM3NtO6tnPLHm6FQ46hDbjS2EQNkRVTBK3RrHIeq1gEgtRe2LjSUSINwXm1
         K0ydFLnOW0dpyRtAh4pHssK30uB/bH8qJv5sGU9r7cAiQXMuF/KUeQaVzCLQMVItnumW
         IGHRzOxufvyvLwgbI9eoIVDDrQNSru159s0ZTktacwmN68JREle5cmgHsJ7P1kwiDUkD
         16Ki+fPZKDTwyagujLpFJ8uqxxmC1eGfv1VT3aoASiASAh7fsEJBGCc0o3WjTzDnMcf2
         P7Vw==
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Michal Hocko <mhocko-AlSwsSmVLrQ@public.gmane.org>
Cc: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, KAMEZAWA Hiroyuki <kamezawa.hiroyu-+CUm20s59erQFUHtdCDX3A@public.gmane.org>, Balbir Singh <bsingharora-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

From: Wanpeng Li <liwp-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>

Since LRU_ALL_EVICTABLE is useless, just remove it.

Signed-off-by: Wanpeng Li <liwp.linux-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 include/linux/mmzone.h |    1 -
 1 file changed, 1 deletion(-)

diff --git a/include/linux/mmzone.h b/include/linux/mmzone.h
index 68c569f..8b10c35 100644
--- a/include/linux/mmzone.h
+++ b/include/linux/mmzone.h
@@ -209,7 +209,6 @@ struct lruvec {
 /* Mask used at gathering information at once (see memcontrol.c) */
 #define LRU_ALL_FILE (BIT(LRU_INACTIVE_FILE) | BIT(LRU_ACTIVE_FILE))
 #define LRU_ALL_ANON (BIT(LRU_INACTIVE_ANON) | BIT(LRU_ACTIVE_ANON))
-#define LRU_ALL_EVICTABLE (LRU_ALL_FILE | LRU_ALL_ANON)
 #define LRU_ALL	     ((1 << NR_LRU_LISTS) - 1)
 
 /* Isolate clean file */
-- 
1.7.9.5
