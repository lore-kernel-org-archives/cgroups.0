From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH] memcg: Remove memcg_cgroup::id from IDR on
 mem_cgroup_css_alloc() failure
Date: Wed, 1 Aug 2018 11:55:52 -0400
Message-ID: <20180801155552.GA8600@cmpxchg.org>
References: <8a81c801-35c8-767d-54b0-df9f1ca0abc0@virtuozzo.com>
 <20180413115454.GL17484@dhcp22.suse.cz>
 <abfd4903-c455-fac2-7ed6-73707cda64d1@virtuozzo.com>
 <20180413121433.GM17484@dhcp22.suse.cz>
 <20180413125101.GO17484@dhcp22.suse.cz>
 <20180726162512.6056b5d7c1d2a5fbff6ce214@linux-foundation.org>
 <20180727193134.GA10996@cmpxchg.org>
 <20180729192621.py4znecoinw5mqcp@esperanza>
 <20180730153113.GB4567@cmpxchg.org>
 <20180731163908.603d7a27c6534341e1afa724@linux-foundation.org>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=mclUiBiBMjGqRmLDCY4DkBrnidOyVpPFZwnbKnVDC28=;
        b=MKganLeyqIuHbAnkaSYRU5XrkkLw7y5UIgIOUc9k8Q50v682xFSf8eWtBAHL5tsqkL
         VgVupLRxpdckKaVggK/KT66+2R07TsJvniJ0w5rmSk/4RDa8pZsEk3KLG4Hi1tkaQH1m
         zyPbzt+8PDJwNyRqhM6JIMHw2oizTzqYwCYUU7sRS6DDLgOKThfSrZFldyKbnKJwgfqH
         jfAHiqX2D1nT47EBvA+LGavyGVjnMmyAzAs0h7bnEU55VGfU5EELgd67mzfzAi2IS8LM
         B8x55WqQrsbAzcMRPgBBp5Xdth4ZlvOpj5MhZwLQd1pbV7XLEVOdbtYZHB3SIYzn77Q0
         7pWQ==
Content-Disposition: inline
In-Reply-To: <20180731163908.603d7a27c6534341e1afa724@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>, Michal Hocko <mhocko@kernel.org>, Kirill Tkhai <ktkhai@virtuozzo.com>, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue, Jul 31, 2018 at 04:39:08PM -0700, Andrew Morton wrote:
> On Mon, 30 Jul 2018 11:31:13 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Subject: [PATCH] mm: memcontrol: simplify memcg idr allocation and error
> >  unwinding
> > 
> > The memcg ID is allocated early in the multi-step memcg creation
> > process, which needs 2-step ID allocation and IDR publishing, as well
> > as two separate IDR cleanup/unwind sites on error.
> > 
> > Defer the IDR allocation until the last second during onlining to
> > eliminate all this complexity. There is no requirement to have the ID
> > and IDR entry earlier than that. And the root reference to the ID is
> > put in the offline path, so this matches nicely.
> 
> This patch isn't aware of Kirill's later "mm, memcg: assign memcg-aware
> shrinkers bitmap to memcg", which altered mem_cgroup_css_online():
> 
> @@ -4356,6 +4470,11 @@ static int mem_cgroup_css_online(struct
>  {
>  	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
>  
> +	if (memcg_alloc_shrinker_maps(memcg)) {
> +		mem_cgroup_id_remove(memcg);
> +		return -ENOMEM;
> +	}
> +
>  	/* Online state pins memcg ID, memcg ID pins CSS */
>  	atomic_set(&memcg->id.ref, 1);
>  	css_get(css);
> 

Hm, that looks out of place too. The bitmaps are allocated for the
entire lifetime of the css, not just while it's online.

Any objections to the following fixup to that patch?

From bbb785f1daca74024232aa34ba29a8a108556ace Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Wed, 1 Aug 2018 11:42:55 -0400
Subject: [PATCH] mm, memcg: assign memcg-aware shrinkers bitmap to memcg fix

The shrinker bitmap allocation is a bit out of place in the css
onlining path.

Allocate and free those bitmaps as part of the memcg alloc and free
procedures.

Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index c9098200326f..82eb40b715da 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4342,6 +4342,7 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
+	memcg_free_shrinker_maps(memcg);
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->stat_cpu);
@@ -4381,6 +4382,9 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 		if (alloc_mem_cgroup_per_node_info(memcg, node))
 			goto fail;
 
+	if (memcg_alloc_shrinker_maps(memcg))
+		goto fail;
+
 	if (memcg_wb_domain_init(memcg, GFP_KERNEL))
 		goto fail;
 
@@ -4470,11 +4474,6 @@ static int mem_cgroup_css_online(struct cgroup_subsys_state *css)
 {
 	struct mem_cgroup *memcg = mem_cgroup_from_css(css);
 
-	if (memcg_alloc_shrinker_maps(memcg)) {
-		mem_cgroup_id_remove(memcg);
-		return -ENOMEM;
-	}
-
 	/* Online state pins memcg ID, memcg ID pins CSS */
 	atomic_set(&memcg->id.ref, 1);
 	css_get(css);
@@ -4527,7 +4526,6 @@ static void mem_cgroup_css_free(struct cgroup_subsys_state *css)
 	vmpressure_cleanup(&memcg->vmpressure);
 	cancel_work_sync(&memcg->high_work);
 	mem_cgroup_remove_from_trees(memcg);
-	memcg_free_shrinker_maps(memcg);
 	memcg_free_kmem(memcg);
 	mem_cgroup_free(memcg);
 }
-- 
2.18.0

