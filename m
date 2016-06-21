From: Johannes Weiner <hannes@cmpxchg.org>
Subject: Re: [PATCH 3/3] mm: memcontrol: fix cgroup creation failure after
 many small jobs
Date: Tue, 21 Jun 2016 11:46:01 -0400
Message-ID: <20160621154601.GA22431@cmpxchg.org>
References: <20160616034244.14839-1-hannes@cmpxchg.org>
 <20160616200617.GD3262@mtj.duckdns.org>
 <20160617162310.GA19084@cmpxchg.org>
 <20160617162516.GD19084@cmpxchg.org>
 <20160621101650.GD15970@esperanza>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20160621101650.GD15970@esperanza>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov@virtuozzo.com>
Cc: Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.cz>, Li Zefan <lizefan@huawei.com>, linux-mm@kvack.org, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-team@fb.com

On Tue, Jun 21, 2016 at 01:16:51PM +0300, Vladimir Davydov wrote:
> On Fri, Jun 17, 2016 at 12:25:16PM -0400, Johannes Weiner wrote:
> > After this patch, the IDs get released upon cgroup destruction and the
> > cache and css objects get released once memory reclaim kicks in.
> 
> With 65K cgroups it will take the reclaimer a substantial amount of time
> to iterate over all of them, which might result in latency spikes.
> Probably, to avoid that, we could move pages from a dead cgroup's lru to
> its parent's one on offline while still leaving dead cgroups pinned,
> like we do in case of list_lru entries.

Yep, that is true. list_lru is a bit easier because the walker stays
in the context of the original LRU list, whereas the cache/anon LRUs
are not. We'd have to have mem_cgroup_page_lruvec() etc. do a parent
walk to find the closest live ancestor. Maybe you have a better idea?

But it's definitely worth considering. I'll think more about it.

> > Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
> 
> Reviewed-by: Vladimir Davydov <vdavydov@virtuozzo.com>

Thanks!

> > +static struct idr mem_cgroup_idr;
> 
> static DEFINE_IDR(mem_cgroup_idr);

Oops, good catch. Andrew, could you kindly fold this?

From d1261ede8f975a5fccb2e9125562260e4b4b4f3d Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes@cmpxchg.org>
Date: Tue, 21 Jun 2016 11:36:13 -0400
Subject: [PATCH] mm: memcontrol: fix cgroup creation failure after many small
 jobs fix

init the IDR

Reported-by: Vladimir Davydov <vdavydov@virtuozzo.com>
Signed-off-by: Johannes Weiner <hannes@cmpxchg.org>
---
 mm/memcontrol.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index dc92b2df2585..b0de1342eab2 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4081,7 +4081,7 @@ static struct cftype mem_cgroup_legacy_files[] = {
  * those references are manageable from userspace.
  */
 
-static struct idr mem_cgroup_idr;
+static DEFINE_IDR(mem_cgroup_idr);
 
 static void mem_cgroup_id_get(struct mem_cgroup *memcg)
 {
-- 
2.8.3

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
