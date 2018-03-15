From: Roman Gushchin <guro@fb.com>
Subject: Re: [patch -mm] mm, memcg: evaluate root and leaf memcgs fairly on
 oom
Date: Thu, 15 Mar 2018 16:46:53 +0000
Message-ID: <20180315164646.GA1853@castle.DHCP.thefacebook.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com>
 <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com>
 <20180314121700.GA20850@castle.DHCP.thefacebook.com>
 <alpine.DEB.2.20.1803141337110.163553@chino.kir.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.com; h=date : from : to : cc :
 subject : message-id : references : mime-version : content-type :
 in-reply-to; s=facebook; bh=wvP9lfp78CUgumF8vTx98Fl/jpODnmPt02mkKGtQolA=;
 b=NZX+NqMuaCMxeVWNW4J2rSWZiQlBmc1WcCs9fMlUrnS2zhhdAv+OoDmis44S06icKSdY
 cKtezXUCsijNd6a0S2zC2zQSlhlxUSbnf7U8oQ3XTLZnCP0mVhAcgRKizi5HYHfPqk2q
 jy2z7QvOowx5ih87PFznjRtNFa1ivplQlWc= 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=fb.onmicrosoft.com;
 s=selector1-fb-com; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=wvP9lfp78CUgumF8vTx98Fl/jpODnmPt02mkKGtQolA=;
 b=SMbP9viwW4/YYu147aaEg3670eLQDLhJ2VcAzt7/5nLAIZbZ7wmaMAO6ZW4sG3kZMRNF3xAIJzIRS+uXe74cTWefyJJe91O7JWuwG9aWXfdXdrFB0CFyRs9un7pqXX3IAjNGvziUhoq5tj79Pbkdmfg0hlJGa8CBVkKwaMvEV4w=
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.20.1803141337110.163553@chino.kir.corp.google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Transfer-Encoding: 7bit
To: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, Mar 14, 2018 at 01:41:03PM -0700, David Rientjes wrote:
> On Wed, 14 Mar 2018, Roman Gushchin wrote:
> 
> > > @@ -2618,92 +2620,65 @@ static long memcg_oom_badness(struct mem_cgroup *memcg,
> > >  		if (nodemask && !node_isset(nid, *nodemask))
> > >  			continue;
> > >  
> > > -		points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> > > -				LRU_ALL_ANON | BIT(LRU_UNEVICTABLE));
> > > -
> > >  		pgdat = NODE_DATA(nid);
> > > -		points += lruvec_page_state(mem_cgroup_lruvec(pgdat, memcg),
> > > -					    NR_SLAB_UNRECLAIMABLE);
> > > +		if (is_root_memcg) {
> > > +			points += node_page_state(pgdat, NR_ACTIVE_ANON) +
> > > +				  node_page_state(pgdat, NR_INACTIVE_ANON);
> > > +			points += node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE);
> > > +		} else {
> > > +			points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> > > +							       LRU_ALL_ANON);
> > > +			points += lruvec_page_state(mem_cgroup_lruvec(pgdat, memcg),
> > > +						    NR_SLAB_UNRECLAIMABLE);
> > > +		}
> > >  	}
> > >  
> > > -	points += memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) /
> > > -		(PAGE_SIZE / 1024);
> > > -	points += memcg_page_state(memcg, MEMCG_SOCK);
> > > -	points += memcg_page_state(memcg, MEMCG_SWAP);
> > > -
> > > +	if (is_root_memcg) {
> > > +		points += global_zone_page_state(NR_KERNEL_STACK_KB) /
> > > +				(PAGE_SIZE / 1024);
> > > +		points += atomic_long_read(&total_sock_pages);
> >                                             ^^^^^^^^^^^^^^^^
> > BTW, where do we change this counter?
> > 
> 
> Seems like it was dropped from the patch somehow.  It is intended to do 
> atomic_long_add(nr_pages) in mem_cgroup_charge_skmem() and 
> atomic_long_add(-nr_pages) mem_cgroup_uncharge_skmem().
> 
> > I also doubt that global atomic variable can work here,
> > we probably need something better scaling.
> > 
> 
> Why do you think an atomic_long_add() is too expensive when we're already 
> disabling irqs and dong try_charge()?

Hard to say without having full code :)
try_charge() is batched, if you'll batch it too, it will probably work.
