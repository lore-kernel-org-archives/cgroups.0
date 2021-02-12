From: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
Subject: [PATCH 4/4] mm: memcontrol: fix swap uncharge on cgroup v2
Date: Sat, 13 Feb 2021 01:01:59 +0800
Message-ID: <20210212170159.32153-4-songmuchun@bytedance.com>
References: <20210212170159.32153-1-songmuchun@bytedance.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bytedance-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7mHQ3glb31sFuwvoGcKO+DumCO9HSr0Bb7Nri9jWV50=;
        b=mAnF3VGeuW6pSRvu2LN2xqj+dzYyLwh/OPEDqMeHluwaz2poT5if4WhFnoBubDskRD
         WhemKL3Sc0cI5yOpXFf9KOI9IxspEKlb0Yx00kM0w2z3lZWpHDh9nEqUqtIJIKQPqLA5
         xcpTmN54VOVH83PLYEfe7rFxnQwCu3TC8LcM+lp8sY5f2JdsTwXNHNUz/KY0RPxxBpqK
         ZJB6hm8JCvRjPWPpLFw2sWnkKZDw26g3HarWaEIjaNl5953EBj7UaCDr50tnWTqaScTC
         rvhmQZW1Vgq9yaElWbZpHKpFG09EA5M7Ga5tjZxGq+ijpVfQQ8fzo1Axg+qd6FtjiW1J
         52Uw==
In-Reply-To: <20210212170159.32153-1-songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org, mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org
Cc: cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>

The swap charges the actual number of swap entries on cgroup v2.
If a swap cache page is charged successful, and then we uncharge
the swap counter. It is wrong on cgroup v2. Because the swap
entry is not freed.

Fixes: 2d1c498072de ("mm: memcontrol: make swap tracking an integral part of memory control")
Signed-off-by: Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c737c8f05992..be6bc5044150 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -6753,7 +6753,7 @@ int mem_cgroup_charge(struct page *page, struct mm_struct *mm, gfp_t gfp_mask)
 	memcg_check_events(memcg, page);
 	local_irq_enable();
 
-	if (PageSwapCache(page)) {
+	if (!cgroup_subsys_on_dfl(memory_cgrp_subsys) && PageSwapCache(page)) {
 		swp_entry_t entry = { .val = page_private(page) };
 		/*
 		 * The swap entry might not get freed for a long time,
-- 
2.11.0

