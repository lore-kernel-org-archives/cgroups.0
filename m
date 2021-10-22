From: Arnd Bergmann <arnd-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] memcg, kmem: mark cancel_charge() inline
Date: Fri, 22 Oct 2021 09:05:35 +0200
Message-ID: <20211022070542.679839-1-arnd@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634886348;
        bh=iLRhWGhOtATtNXfjLsY/C/FzcVIkkj6omLPayvSrHVc=;
        h=From:To:Cc:Subject:Date:From;
        b=WvBpQzKjqVFToSn3i2NADviklR3XuCrbfuC3GBfqsU7+otQA2XAlMiiV1wNk7LED6
         T0Vu2AL+7me+PouplKBEcm7CD5tf8wQJ91BYw5i+tcyIBxIRl9I5A8bCQAaM8/ukdf
         4hOSK/JiM35OiNJP6W9PhHmDIRrotBP57yFezB7OjY3U+DWO7nKc7Xcqz9Vm/ELfDR
         BRfJczzddWZwsF620p9imsVc5UiigA2Rxk4jplLQL11LFAdYJ962ELZRsVcVMgEoLX
         Y+9K0EkVREF4npPNMmr3rcKTSeiwG/XEXNxmlxkFz2ILlfy336WBO7XpAU8+6EUP5w
         NB8i6vWNlwLZA==
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Stephen Rothwell <sfr-3FnU+UHB4dNDw9hX6IcOSA@public.gmane.org>, Muchun Song <songmuchun-EC8Uxl6Npydl57MIdRCFDg@public.gmane.org>, Roman Gushchin <guro-b10kYP2dOMg@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, "Matthew Wilcox (Oracle)" <willy-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Waiman Long <longman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>

cancel_charge() is no longer called for CONFIG_MEMCG_KMEM on NOMMU
targets, which causes a compiletime warning:

mm/memcontrol.c:2774:13: error: unused function 'cancel_charge' [-Werror,-Wunused-function]

Remove the now-incorrect #ifdef and just mark the function
'inline' like the other related helpers. This is simpler
and means we no longer have to match the #ifdef with the
caller.

Fixes: 5f3345c17079 ("memcg, kmem: further deprecate kmem.limit_in_bytes")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
The 5f3345c17079 commit is in -mm, so the commit ID is not
stable. Feel free to just fold this into the other patch, or
take out that reference
---
 mm/memcontrol.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 6538595994d2..9edccfeac804 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2770,8 +2770,7 @@ static inline int try_charge(struct mem_cgroup *memcg, gfp_t gfp_mask,
 	return try_charge_memcg(memcg, gfp_mask, nr_pages);
 }
 
-#if defined(CONFIG_MEMCG_KMEM) || defined(CONFIG_MMU)
-static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
+static inline void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 {
 	if (mem_cgroup_is_root(memcg))
 		return;
@@ -2780,7 +2779,6 @@ static void cancel_charge(struct mem_cgroup *memcg, unsigned int nr_pages)
 	if (do_memsw_account())
 		page_counter_uncharge(&memcg->memsw, nr_pages);
 }
-#endif
 
 static void commit_charge(struct folio *folio, struct mem_cgroup *memcg)
 {
-- 
2.29.2

