From: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH v2 3/5] mm/memcontrol: Reorder memcg_stock_pcp members to avoid holes
Date: Wed, 25 Jan 2023 04:35:00 -0300
Message-ID: <20230125073502.743446-4-leobras@redhat.com>
References: <20230125073502.743446-1-leobras@redhat.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1674632161;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i0PZh+yTsPG9Po4mo5Kh71H2anPuGxn31rIFI1zWHXw=;
        b=cEhyx4CVXxxP7oH0boIAzIj4YO3rZjYnryslJLa+Rx9MeLb9JMXiId3qKVrxhU4KnBgREv
        7K3uhEBsjOWnFhkMrwB0T5Lhjdwfn4Bq4OY54//l4L/BTbTEMWU+i4sFlixT6KhRDdUA9L
        NmsUkmfMGPPcqhFYN34dGmk6OHu5h/g=
In-Reply-To: <20230125073502.743446-1-leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
To: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>, Michal Hocko <mhocko-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Roman Gushchin <roman.gushchin-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Shakeel Butt <shakeelb-hpIqsD4AKlfQT0dZR+AlfA@public.gmane.org>, Muchun Song <muchun.song-fxUVXftIFDnyG1zEObXtfA@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Marcelo Tosatti <mtosatti-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org

In 64-bit architectures, the current layout of memcg_stock_pcp should look
like this:

struct memcg_stock_pcp {
        spinlock_t                 stock_lock;           /*     0     4 */
        /* 4 bytes hole */
        struct mem_cgroup *        cached;               /*     8     8 */
        unsigned int               nr_pages;             /*    16     4 */
        /* 4 bytes hole */
	[...]
};

This happens because pointers will have 8 bytes (64-bit) and ints will have
4 bytes.

Those 2 holes are avoided if we reorder nr_pages and cached,
effectivelly putting nr_pages in the first hole, and saving 8 bytes.

Signed-off-by: Leonardo Bras <leobras-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 1d5c108413c83..373fa78c4d881 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -2173,8 +2173,8 @@ void unlock_page_memcg(struct page *page)
 
 struct memcg_stock_pcp {
 	spinlock_t stock_lock; /* Protects the percpu struct */
-	struct mem_cgroup *cached; /* this never be root cgroup */
 	unsigned int nr_pages;
+	struct mem_cgroup *cached; /* this never be root cgroup */
 
 #ifdef CONFIG_MEMCG_KMEM
 	struct obj_cgroup *cached_objcg;
-- 
2.39.1

