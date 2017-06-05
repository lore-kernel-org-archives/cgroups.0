From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Subject: Re: [PATCH 5/6] mm: memcontrol: per-lruvec stats infrastructure
Date: Mon, 5 Jun 2017 13:53:54 -0400
Message-ID: <20170605175354.GB8547@cmpxchg.org>
References: <20170530181724.27197-1-hannes@cmpxchg.org>
 <20170530181724.27197-6-hannes@cmpxchg.org>
 <20170603175002.GE15130@esperanza>
Mime-Version: 1.0
Return-path: <cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=cmpxchg.org
        ; s=x; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:Subject:
        Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3OHVfp13xtth1gn0moed8ysfTjl6rM7Wf1bV8NwyNSA=; b=Jko1tJ4DV9j+LKF+KxdxpHfcYn
        z3pwtiQ9M4Naw/5zW8ZUvoyiQckeKFyRMjRsyi7usPXZZK6nMl2I/gqGLfTxLh5+U7EUPoQTTfuun
        2V10Jm3WaVeDrQCo+sScURorkQWiFYDC5qNi0O5+ueIE7muYbOZ1BNl4Xhrw0Vb9n7HE=;
Content-Disposition: inline
In-Reply-To: <20170603175002.GE15130@esperanza>
Sender: cgroups-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Vladimir Davydov <vdavydov.dev-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Josef Bacik <josef-DigfWCa+lFGyeJad7bwFQA@public.gmane.org>, Michal Hocko <mhocko-IBi9RG/b67k@public.gmane.org>, Andrew Morton <akpm-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>, Rik van Riel <riel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-mm-Bw31MaZKKs3YtjvyW6yDsg@public.gmane.org, cgroups-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, kernel-team-b10kYP2dOMg@public.gmane.org

On Sat, Jun 03, 2017 at 08:50:02PM +0300, Vladimir Davydov wrote:
> On Tue, May 30, 2017 at 02:17:23PM -0400, Johannes Weiner wrote:
> > lruvecs are at the intersection of the NUMA node and memcg, which is
> > the scope for most paging activity.
> > 
> > Introduce a convenient accounting infrastructure that maintains
> > statistics per node, per memcg, and the lruvec itself.
> > 
> > Then convert over accounting sites for statistics that are already
> > tracked in both nodes and memcgs and can be easily switched.
> > 
> > Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
> > ---
> >  include/linux/memcontrol.h | 238 +++++++++++++++++++++++++++++++++++++++------
> >  include/linux/vmstat.h     |   1 -
> >  mm/memcontrol.c            |   6 ++
> >  mm/page-writeback.c        |  15 +--
> >  mm/rmap.c                  |   8 +-
> >  mm/workingset.c            |   9 +-
> >  6 files changed, 225 insertions(+), 52 deletions(-)
> > 
> ...
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index 9c68a40c83e3..e37908606c0f 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -4122,6 +4122,12 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
> >  	if (!pn)
> >  		return 1;
> >  
> > +	pn->lruvec_stat = alloc_percpu(struct lruvec_stat);
> > +	if (!pn->lruvec_stat) {
> > +		kfree(pn);
> > +		return 1;
> > +	}
> > +
> >  	lruvec_init(&pn->lruvec);
> >  	pn->usage_in_excess = 0;
> >  	pn->on_tree = false;
> 
> I don't see the matching free_percpu() anywhere, forget to patch
> free_mem_cgroup_per_node_info()?

Yes, I missed that.

---

From 4d09a522a2182acae4e36ded4211d05defd75b74 Mon Sep 17 00:00:00 2001
From: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
Date: Mon, 5 Jun 2017 10:59:41 -0400
Subject: [PATCH] mm: memcontrol: per-lruvec stats infrastructure fix 3

As pointed out, there is a missing free_percpu() for the lruvec_stat
object in the memcg's per node info. Add this.

Signed-off-by: Johannes Weiner <hannes-druUgvl0LCNAfugRpC6u6w@public.gmane.org>
---
 mm/memcontrol.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/mm/memcontrol.c b/mm/memcontrol.c
index e37908606c0f..093fe7e06e51 100644
--- a/mm/memcontrol.c
+++ b/mm/memcontrol.c
@@ -4139,7 +4139,10 @@ static int alloc_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 
 static void free_mem_cgroup_per_node_info(struct mem_cgroup *memcg, int node)
 {
-	kfree(memcg->nodeinfo[node]);
+	struct mem_cgroup_per_node *pn = memcg->nodeinfo[node];
+
+	free_percpu(pn->lruvec_stat);
+	kfree(pn);
 }
 
 static void __mem_cgroup_free(struct mem_cgroup *memcg)
-- 
2.13.0
