From: Michal Hocko <mhocko@kernel.org>
Subject: Re: [PATCH] memcg: Remove memcg_cgroup::id from IDR on
 mem_cgroup_css_alloc() failure
Date: Fri, 13 Apr 2018 14:51:01 +0200
Message-ID: <20180413125101.GO17484@dhcp22.suse.cz>
References: <ed75d18c-f516-2feb-53a8-6d2836e1da59@virtuozzo.com>
 <20180413110200.GG17484@dhcp22.suse.cz>
 <06931a83-91d2-3dcf-31cf-0b98d82e957f@virtuozzo.com>
 <20180413112036.GH17484@dhcp22.suse.cz>
 <6dbc33bb-f3d5-1a46-b454-13c6f5865fcd@virtuozzo.com>
 <20180413113855.GI17484@dhcp22.suse.cz>
 <8a81c801-35c8-767d-54b0-df9f1ca0abc0@virtuozzo.com>
 <20180413115454.GL17484@dhcp22.suse.cz>
 <abfd4903-c455-fac2-7ed6-73707cda64d1@virtuozzo.com>
 <20180413121433.GM17484@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20180413121433.GM17484@dhcp22.suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Kirill Tkhai <ktkhai@virtuozzo.com>
Cc: akpm@linux-foundation.org, hannes@cmpxchg.org, vdavydov.dev@gmail.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Fri 13-04-18 14:14:33, Michal Hocko wrote:
[...]
> Well, this is probably a matter of taste. I will not argue. I will not
> object if Johannes is OK with your patch. But the whole thing confused
> hell out of me so I would rather un-clutter it...

In other words, this

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index 8c2ed1c2b72c..ca7e981a8a1a 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4351,6 +4351,14 @@ static void __mem_cgroup_free(struct mem_cgroup *memcg)
 {
 	int node;
 
+	/*
+	 * We are trying to remove the idr key when the last memcg
+	 * reference drops which can be sooner than when the last
+	 * css reference is dropped to recycle ids faster.
+	 */
+	if (memcg->id.id > 0)
+		idr_remove(&mem_cgroup_idr, memcg->id.id);
+
 	for_each_node(node)
 		free_mem_cgroup_per_node_info(memcg, node);
 	free_percpu(memcg->stat_cpu);
@@ -4411,8 +4419,6 @@ static struct mem_cgroup *mem_cgroup_alloc(void)
 	idr_replace(&mem_cgroup_idr, memcg, memcg->id.id);
 	return memcg;
 fail:
-	if (memcg->id.id > 0)
-		idr_remove(&mem_cgroup_idr, memcg->id.id);
 	__mem_cgroup_free(memcg);
 	return NULL;
 }
-- 
Michal Hocko
SUSE Labs
