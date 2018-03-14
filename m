From: David Rientjes <rientjes@google.com>
Subject: Re: [patch -mm] mm, memcg: evaluate root and leaf memcgs fairly on
 oom
Date: Wed, 14 Mar 2018 13:41:03 -0700 (PDT)
Message-ID: <alpine.DEB.2.20.1803141337110.163553@chino.kir.corp.google.com>
References: <alpine.DEB.2.20.1803121755590.192200@chino.kir.corp.google.com> <alpine.DEB.2.20.1803131720470.247949@chino.kir.corp.google.com> <20180314121700.GA20850@castle.DHCP.thefacebook.com>
Mime-Version: 1.0
Return-path: <linux-kernel-owner@vger.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:in-reply-to:message-id:references
         :user-agent:mime-version;
        bh=4Bte+yvrl469JjN9uXL9KYzrPwpe6yF/b78Yqf2mWtM=;
        b=DarlMN+kQmTJoiOP5EVd3IUKkCJ2Qw08hkHP/jU1pg58CQMqfVmCnSsJFBMVe+2sRQ
         G0JFlIAB5bAnycPJNKh6p1djYTpI0NIDFpxQOZu3zvG/Hhd0ZM8njCgqnA1kaQUcXH5q
         xE5V2BGSgG3ad/3+KR92YUnzmUOiJRYNdOz5rXPoH/gKFKqLdDGIBsAgk0qwr1/nWrGq
         iU48iJA6qrreYU71CTcMMNMj/0rjELZ05QIqwggAMoIprXlN7PGngdAQjLrBZYuXOazO
         EX+EdxvKI1GpnhxLNQEgSUZ9UVx2QrjSdB5/4hxGoJ/YyuRlloFUTlZweOJW2T3NUgLF
         Gmtw==
In-Reply-To: <20180314121700.GA20850@castle.DHCP.thefacebook.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <cgroups.vger.kernel.org>
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
To: Roman Gushchin <guro@fb.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@kernel.org>, Vladimir Davydov <vdavydov.dev@gmail.com>, Johannes Weiner <hannes@cmpxchg.org>, Tejun Heo <tj@kernel.org>, cgroups@vger.kernel.org, linux-kernel@vger.kernel.org, linux-mm@kvack.org

On Wed, 14 Mar 2018, Roman Gushchin wrote:

> > @@ -2618,92 +2620,65 @@ static long memcg_oom_badness(struct mem_cgroup *memcg,
> >  		if (nodemask && !node_isset(nid, *nodemask))
> >  			continue;
> >  
> > -		points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> > -				LRU_ALL_ANON | BIT(LRU_UNEVICTABLE));
> > -
> >  		pgdat = NODE_DATA(nid);
> > -		points += lruvec_page_state(mem_cgroup_lruvec(pgdat, memcg),
> > -					    NR_SLAB_UNRECLAIMABLE);
> > +		if (is_root_memcg) {
> > +			points += node_page_state(pgdat, NR_ACTIVE_ANON) +
> > +				  node_page_state(pgdat, NR_INACTIVE_ANON);
> > +			points += node_page_state(pgdat, NR_SLAB_UNRECLAIMABLE);
> > +		} else {
> > +			points += mem_cgroup_node_nr_lru_pages(memcg, nid,
> > +							       LRU_ALL_ANON);
> > +			points += lruvec_page_state(mem_cgroup_lruvec(pgdat, memcg),
> > +						    NR_SLAB_UNRECLAIMABLE);
> > +		}
> >  	}
> >  
> > -	points += memcg_page_state(memcg, MEMCG_KERNEL_STACK_KB) /
> > -		(PAGE_SIZE / 1024);
> > -	points += memcg_page_state(memcg, MEMCG_SOCK);
> > -	points += memcg_page_state(memcg, MEMCG_SWAP);
> > -
> > +	if (is_root_memcg) {
> > +		points += global_zone_page_state(NR_KERNEL_STACK_KB) /
> > +				(PAGE_SIZE / 1024);
> > +		points += atomic_long_read(&total_sock_pages);
>                                             ^^^^^^^^^^^^^^^^
> BTW, where do we change this counter?
> 

Seems like it was dropped from the patch somehow.  It is intended to do 
atomic_long_add(nr_pages) in mem_cgroup_charge_skmem() and 
atomic_long_add(-nr_pages) mem_cgroup_uncharge_skmem().

> I also doubt that global atomic variable can work here,
> we probably need something better scaling.
> 

Why do you think an atomic_long_add() is too expensive when we're already 
disabling irqs and dong try_charge()?
