From: Michal Hocko <mhocko@suse.cz>
Subject: Re: [PATCH 2/2] mm/memcontrol.c: introduce helper
 mem_cgroup_zoneinfo_zone()
Date: Mon, 28 Apr 2014 17:04:26 +0200
Message-ID: <20140428150426.GB24807@dhcp22.suse.cz>
References: <1397862103-31982-1-git-send-email-nasa4836@gmail.com>
 <20140422095923.GD29311@dhcp22.suse.cz>
Mime-Version: 1.0
Return-path: <owner-linux-mm@kvack.org>
Content-Disposition: inline
In-Reply-To: <20140422095923.GD29311@dhcp22.suse.cz>
Sender: owner-linux-mm@kvack.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Jianyu Zhan <nasa4836@gmail.com>
Cc: hannes@cmpxchg.org, bsingharora@gmail.com, kamezawa.hiroyu@jp.fujitsu.com, cgroups@vger.kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org

On Tue 22-04-14 11:59:23, Michal Hocko wrote:
> On Sat 19-04-14 07:01:43, Jianyu Zhan wrote:
> > introduce helper mem_cgroup_zoneinfo_zone(). This will make
> > mem_cgroup_iter() code more compact.
> 
> I dunno. Helpers are usually nice but this one adds more code then it
> removes. It also doesn't help the generated code.
> 
> So I don't see any reason to merge it.

So should we drop it from mmotm?

> > Signed-off-by: Jianyu Zhan <nasa4836@gmail.com>
> > ---
> >  mm/memcontrol.c | 15 +++++++++++----
> >  1 file changed, 11 insertions(+), 4 deletions(-)
> > 
> > diff --git a/mm/memcontrol.c b/mm/memcontrol.c
> > index e0ce15c..80d9e38 100644
> > --- a/mm/memcontrol.c
> > +++ b/mm/memcontrol.c
> > @@ -683,6 +683,15 @@ mem_cgroup_zoneinfo(struct mem_cgroup *memcg, int nid, int zid)
> >  	return &memcg->nodeinfo[nid]->zoneinfo[zid];
> >  }
> >  
> > +static struct mem_cgroup_per_zone *
> > +mem_cgroup_zoneinfo_zone(struct mem_cgroup *memcg, struct zone *zone)
> > +{
> > +       int nid = zone_to_nid(zone);
> > +       int zid = zone_idx(zone);
> > +
> > +       return mem_cgroup_zoneinfo(memcg, nid, zid);
> > +}
> > +
> >  struct cgroup_subsys_state *mem_cgroup_css(struct mem_cgroup *memcg)
> >  {
> >  	return &memcg->css;
> > @@ -1232,11 +1241,9 @@ struct mem_cgroup *mem_cgroup_iter(struct mem_cgroup *root,
> >  
> >  	rcu_read_lock();
> >  	if (reclaim) {
> > -		int nid = zone_to_nid(reclaim->zone);
> > -		int zid = zone_idx(reclaim->zone);
> >  		struct mem_cgroup_per_zone *mz;
> >  
> > -		mz = mem_cgroup_zoneinfo(root, nid, zid);
> > +		mz = mem_cgroup_zoneinfo_zone(root, reclaim->zone);
> >  		iter = &mz->reclaim_iter[reclaim->priority];
> >  		if (prev && reclaim->generation != iter->generation) {
> >  			iter->last_visited = NULL;
> > @@ -1340,7 +1347,7 @@ struct lruvec *mem_cgroup_zone_lruvec(struct zone *zone,
> >  		goto out;
> >  	}
> >  
> > -	mz = mem_cgroup_zoneinfo(memcg, zone_to_nid(zone), zone_idx(zone));
> > +	mz = mem_cgroup_zoneinfo_zone(memcg, zone);
> >  	lruvec = &mz->lruvec;
> >  out:
> >  	/*
> > -- 
> > 1.9.0.GIT
> > 
> 
> -- 
> Michal Hocko
> SUSE Labs
> --
> To unsubscribe from this list: send the line "unsubscribe cgroups" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Michal Hocko
SUSE Labs

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
